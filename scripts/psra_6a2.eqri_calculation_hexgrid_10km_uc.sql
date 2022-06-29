-- script to test new PSRA calculation
-- hg 10km level

-- calculate social fabric hg 10km uc aggregation
DROP TABLE IF EXISTS results_psra_national.psra_sri_social_fabric_score_hg_10km_uc CASCADE;
CREATE TABLE results_psra_national.psra_sri_social_fabric_score_hg_10km_uc AS
(
SELECT
b.gridid_10,
AVG("SVlt_Score" * b.area_ratio) AS "SVlt_Score"

FROM results_nhsl_social_fabric.nhsl_social_fabric_indicators_s a
LEFT JOIN boundaries."SAUID_HexGrid_10km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_10km_unclipped" c ON b.gridid_10 = c.gridid_10
GROUP BY b.gridid_10,c.geom
);



-- calculate vars needed from hg aggregation
DROP TABLE IF EXISTS results_psra_national.psra_sri_var_hg_10km_uc CASCADE;
CREATE TABLE results_psra_national.psra_sri_var_hg_10km_uc AS
(
SELECT 
c.gridid_10,

SUM("eCt_Fatality_b0" * b.area_ratio) AS "eCt_Fatality_b0",
AVG("eCtr_Fatality_b0" * b.area_ratio) AS "eCtr_Fatality_b0",
SUM("eCt_Fatality_r1" * b.area_ratio) AS "eCt_Fatality_r1",
AVG("eCtr_Fatality_r1" * b.area_ratio) AS "eCtr_Fatality_r1",
SUM("eAALt_Asset_b0" * b.area_ratio) AS "eAALt_Asset_b0",
AVG("eAALm_Asset_b0" * b.area_ratio) AS "eAALm_Asset_b0",
SUM("eAALt_Bldg_b0" * b.area_ratio) AS "eAALt_Bldg_b0",
AVG("eAALm_Bldg_b0" * b.area_ratio) AS "eAALm_Bldg_b0",
SUM("eAALt_Str_b0" * b.area_ratio) AS "eAALt_Str_b0",
SUM("eAALt_NStr_b0" * b.area_ratio) AS "eAALt_NStr_b0",
SUM("eAALt_Cont_b0" * b.area_ratio) AS "eAALt_Cont_b0",
SUM("eAALt_Asset_r1" * b.area_ratio) AS "eAALt_Asset_r1",
AVG("eAALm_Asset_r1" * b.area_ratio) AS "eAALm_Asset_r1",
SUM("eAALt_Bldg_r1" * b.area_ratio) AS "eAALt_Bldg_r1",
AVG("eAALm_Bldg_r1" * b.area_ratio) AS "eAALm_Bldg_r1",
SUM("eAALt_Str_r1" * b.area_ratio) AS "eAALt_Str_r1",
SUM("eAALt_NStr_r1" * b.area_ratio) AS "eAALt_NStr_r1",
SUM("eAALt_Cont_r1" * b.area_ratio) AS "eAALt_Cont_r1"

FROM results_psra_national.psra_indicators_s_tbl a
LEFT JOIN boundaries."SAUID_HexGrid_10km_intersect_unclipped" b ON a."Sauid" = b.sauid
LEFT JOIN boundaries."HexGrid_10km_unclipped" c ON b.gridid_10 = c.gridid_10
GROUP BY c.gridid_10
);



-- sri calc table 1
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc1_hg_10km_uc CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc1_hg_10km_uc AS
(
SELECT
a.gridid_10,

-- exposure
a."E_CensusPop",
a."Et_PopNight",
a."Et_PopTransit",
a."Et_BldgNum",
a."Et_AssetValue",

-- EQ Risk b0
b."eCt_Fatality_b0",
b."eCtr_Fatality_b0",
b."eAALt_Asset_b0",
b."eAALm_Asset_b0",
b."eAALt_Bldg_b0",
b."eAALm_Bldg_b0",
b."eAALt_Str_b0",
b."eAALt_NStr_b0",
b."eAALt_Cont_b0",

-- EQ Risk r1
b."eCt_Fatality_r1",
b."eCtr_Fatality_r1",
b."eAALt_Asset_r1",
b."eAALm_Asset_r1",
b."eAALt_Bldg_r1",
b."eAALm_Bldg_r1",
b."eAALt_Str_r1",
b."eAALt_NStr_r1",
b."eAALt_Cont_r1",

-- sovi
c."SVlt_Score" AS "SVlt_Score_avg",
CASE
	WHEN (c."SVlt_Score" /(SELECT MAX("SVlt_Score") FROM results_psra_national.psra_sri_social_fabric_score_hg_10km_uc))*100 > 0 THEN
	(c."SVlt_Score" /(SELECT MAX("SVlt_Score") FROM results_psra_national.psra_sri_social_fabric_score_hg_10km_uc))*100
	WHEN (c."SVlt_Score" /(SELECT MAX("SVlt_Score") FROM results_psra_national.psra_sri_social_fabric_score_hg_10km_uc))*100 = 0 THEN 0.0001 END AS "SVlt_Score_minmax",
--(c."SVlt_Score" /(SELECT MAX("SVlt_Score") FROM results_psra_national.psra_sri_social_fabric_score_hg_10km_uc))*100 AS "SVlt_Score_minmax",

-- eqri abs b0
b."eAALt_Asset_b0" AS "AAL_b0", 
b."eCt_Fatality_b0" AS "AAF_b0",
b."eCt_Fatality_b0" * 7982324 AS "AAF_VSL_b0",
b."eAALt_Asset_b0" + (b."eCt_Fatality_b0" * 7982324) AS "TotalLosses_b0",

-- eqri abs r1
b."eAALt_Asset_r1" AS "AAL_r1", 
b."eCt_Fatality_r1" AS "AAF_r1",
b."eCt_Fatality_r1" * 7982324 AS "AAF_VSL_r1",
b."eAALt_Asset_r1" + (b."eCt_Fatality_r1" * 7982324) AS "TotalLosses_r1",

-- erqi norm b0
b."eAALm_Asset_b0" AS "AAL_Ratio_b0",
b."eCtr_Fatality_b0" AS "AAF_Ratio_b0",

-- erqi norm r1
b."eAALm_Asset_r1" AS "AAL_Ratio_r1",
b."eCtr_Fatality_r1" AS "AAF_Ratio_r1"

FROM results_nhsl_physical_exposure.nhsl_physical_exposure_indicators_hexgrid_10km_uc a
LEFT JOIN results_psra_national.psra_sri_var_hg_10km_uc b ON a.gridid_10 = b.gridid_10
LEFT JOIN results_psra_national.psra_sri_social_fabric_score_hg_10km_uc c ON a.gridid_10 = c.gridid_10
);



-- sri calc table 2
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc2_hg_10km_uc CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc2_hg_10km_uc AS
(
SELECT 
"gridid_10",
"TotalLosses_b0"/(SELECT MAX("TotalLosses_b0") FROM results_psra_national.psra_sri_calc1_hg_10km_uc) AS "Totallosses_minmax_b0",
"SVlt_Score_minmax" * ("TotalLosses_b0"/(SELECT MAX("TotalLosses_b0") FROM results_psra_national.psra_sri_calc1_hg_10km_uc)*100) AS "eqri_abs_b0",
("SVlt_Score_minmax" * ("TotalLosses_b0"/(SELECT MAX("TotalLosses_b0") FROM results_psra_national.psra_sri_calc1_hg_10km_uc)*100))^(0.333333) AS "eqri_abs_cbrt_b0",
"TotalLosses_b0"/("Et_AssetValue" + ("Et_PopTransit" * 7982324)) AS "TotalLosses_Ratio_b0",

"TotalLosses_b0"/(SELECT MAX("TotalLosses_r1") FROM results_psra_national.psra_sri_calc1_hg_10km_uc) AS "Totallosses_minmax_r1",
"SVlt_Score_minmax" * ("TotalLosses_r1"/(SELECT MAX("TotalLosses_r1") FROM results_psra_national.psra_sri_calc1_hg_10km_uc)*100) AS "eqri_abs_r1",
("SVlt_Score_minmax" * ("TotalLosses_r1"/(SELECT MAX("TotalLosses_r1") FROM results_psra_national.psra_sri_calc1_hg_10km_uc)*100))^(0.333333) AS "eqri_abs_cbrt_r1",
"TotalLosses_r1"/("Et_AssetValue" + ("Et_PopTransit" * 7982324)) AS "TotalLosses_Ratio_r1"

FROM results_psra_national.psra_sri_calc1_hg_10km_uc
);



-- sri calc table 3
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc3_hg_10km_uc CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc3_hg_10km_uc AS
SELECT
a."gridid_10",
(a.eqri_abs_cbrt_b0/(SELECT MAX(eqri_abs_cbrt_b0) FROM results_psra_national.psra_sri_calc2_hg_10km_uc)*100) AS "eqri_abs_cbrt_minmax_b0",
(a."TotalLosses_Ratio_b0"/(SELECT MAX("TotalLosses_Ratio_b0") FROM results_psra_national.psra_sri_calc2_hg_10km_uc)*100) AS "TotalLosses_Ratio_minmax_b0",
(a."TotalLosses_Ratio_b0"/(SELECT MAX("TotalLosses_Ratio_b0") FROM results_psra_national.psra_sri_calc2_hg_10km_uc)*100)* b."SVlt_Score_minmax" AS "eqri_norm_b0",
((a."TotalLosses_Ratio_b0"/(SELECT MAX("TotalLosses_Ratio_b0") FROM results_psra_national.psra_sri_calc2_hg_10km_uc)*100)* b."SVlt_Score_minmax")^(0.333333) AS "eqri_norm_cbrt_b0",

(a.eqri_abs_cbrt_r1/(SELECT MAX(eqri_abs_cbrt_r1) FROM results_psra_national.psra_sri_calc2_hg_10km_uc)*100) AS "eqri_abs_cbrt_minmax_r1",
(a."TotalLosses_Ratio_r1"/(SELECT MAX("TotalLosses_Ratio_r1") FROM results_psra_national.psra_sri_calc2_hg_10km_uc)*100) AS "TotalLosses_Ratio_minmax_r1",
(a."TotalLosses_Ratio_r1"/(SELECT MAX("TotalLosses_Ratio_r1") FROM results_psra_national.psra_sri_calc2_hg_10km_uc)*100)* b."SVlt_Score_minmax" AS "eqri_norm_r1",
((a."TotalLosses_Ratio_r1"/(SELECT MAX("TotalLosses_Ratio_r1") FROM results_psra_national.psra_sri_calc2_hg_10km_uc)*100)* b."SVlt_Score_minmax")^(0.333333) AS "eqri_norm_cbrt_r1"

FROM results_psra_national.psra_sri_calc2_hg_10km_uc a
LEFT JOIN results_psra_national.psra_sri_calc1_hg_10km_uc b  ON a."gridid_10" = b."gridid_10";



-- sri calc table 4
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc4_hg_10km_uc CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc4_hg_10km_uc AS
(
SELECT
"gridid_10",
(eqri_norm_cbrt_b0/(SELECT MAX(eqri_norm_cbrt_b0) FROM results_psra_national.psra_sri_calc3_hg_10km_uc)*100) AS "eqri_norm_cbrt_minmax_b0",
(eqri_norm_cbrt_r1/(SELECT MAX(eqri_norm_cbrt_r1) FROM results_psra_national.psra_sri_calc3_hg_10km_uc)*100) AS "eqri_norm_cbrt_minmax_r1"

FROM results_psra_national.psra_sri_calc3_hg_10km_uc
);



-- sri calc table final
DROP TABLE IF EXISTS results_psra_national.psra_sri_calc_hg_10km_uc CASCADE;
CREATE TABLE results_psra_national.psra_sri_calc_hg_10km_uc AS
(
SELECT
a."gridid_10",

-- exposure
a."E_CensusPop",
a."Et_PopNight",
a."Et_PopTransit",
a."Et_BldgNum",
a."Et_AssetValue",

-- sovi
a."SVlt_Score_avg",
a."SVlt_Score_minmax",

-- EQ risk b0
a."eCt_Fatality_b0",
a."eCtr_Fatality_b0",
a."eAALt_Asset_b0",
a."eAALm_Asset_b0",
a."eAALt_Bldg_b0",
a."eAALm_Bldg_b0",
a."eAALt_Str_b0",
a."eAALt_NStr_b0",
a."eAALt_Cont_b0",

-- eqri abs b0
a."AAL_b0",
a."AAF_b0",
a."AAF_VSL_b0",
a."TotalLosses_b0",
b."Totallosses_minmax_b0",
b.eqri_abs_b0,
b.eqri_abs_cbrt_b0,
c.eqri_abs_cbrt_minmax_b0,
CASE
	WHEN c.eqri_abs_cbrt_minmax_b0 >= 0 AND c.eqri_abs_cbrt_minmax_b0 <= 3.78 THEN 'Very Low Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 3.78 AND c.eqri_abs_cbrt_minmax_b0 <= 9.78 THEN 'Low Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 9.78 AND c.eqri_abs_cbrt_minmax_b0 <= 22.57 THEN 'Moderate Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 22.57 AND c.eqri_abs_cbrt_minmax_b0 <= 55.73 THEN 'High Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 55.73 AND c.eqri_abs_cbrt_minmax_b0 <= 100 THEN 'Very High Score'
END AS "eqri_abs_rating_b0",
	
-- eqri norm b0
a."AAL_Ratio_b0",
a."AAF_Ratio_b0",
b."TotalLosses_Ratio_b0",
c."TotalLosses_Ratio_minmax_b0",
c.eqri_norm_b0,
c.eqri_norm_cbrt_b0,
d.eqri_norm_cbrt_minmax_b0,
CASE
	WHEN d.eqri_norm_cbrt_minmax_b0 >= 0 AND d.eqri_norm_cbrt_minmax_b0 <= 6.83 THEN 'Very Low Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 6.83 AND d.eqri_norm_cbrt_minmax_b0 <= 12.64 THEN 'Relatively Low Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 12.64 AND d.eqri_norm_cbrt_minmax_b0 <= 21.44 THEN 'Relatively Moderate Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 21.44 AND d.eqri_norm_cbrt_minmax_b0 <= 35.82 THEN 'Relatively High Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 35.82 AND d.eqri_norm_cbrt_minmax_b0 <= 100 THEN 'Very High Score'
END AS "eqri_norm_rating_b0",
	
-- EQ risk r1
a."eCt_Fatality_r1",
a."eCtr_Fatality_r1",
a."eAALt_Asset_r1",
a."eAALm_Asset_r1",
a."eAALt_Bldg_r1",
a."eAALm_Bldg_r1",
a."eAALt_Str_r1",
a."eAALt_NStr_r1",
a."eAALt_Cont_r1",
	
-- eqri abs r1
a."AAL_r1",
a."AAF_r1",
a."AAF_VSL_r1",
a."TotalLosses_r1",
b."Totallosses_minmax_r1",
b.eqri_abs_r1,
b.eqri_abs_cbrt_r1,
c.eqri_abs_cbrt_minmax_r1,
CASE
	WHEN c.eqri_abs_cbrt_minmax_b0 >= 0 AND c.eqri_abs_cbrt_minmax_b0 <= 3.78 THEN 'Very Low Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 3.78 AND c.eqri_abs_cbrt_minmax_b0 <= 9.78 THEN 'Low Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 9.78 AND c.eqri_abs_cbrt_minmax_b0 <= 22.57 THEN 'Moderate Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 22.57 AND c.eqri_abs_cbrt_minmax_b0 <= 55.73 THEN 'High Score'
	WHEN c.eqri_abs_cbrt_minmax_b0 > 55.73 AND c.eqri_abs_cbrt_minmax_b0 <= 100 THEN 'Very High Score'
END AS "eqri_abs_rating_r1",
	
-- eqri norm r1
a."AAL_Ratio_r1",
a."AAF_Ratio_r1",
b."TotalLosses_Ratio_r1",
c."TotalLosses_Ratio_minmax_r1",
c.eqri_norm_r1,
c.eqri_norm_cbrt_r1,
d.eqri_norm_cbrt_minmax_r1,
CASE
	WHEN d.eqri_norm_cbrt_minmax_b0 >= 0 AND d.eqri_norm_cbrt_minmax_b0 <= 6.83 THEN 'Very Low Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 6.83 AND d.eqri_norm_cbrt_minmax_b0 <= 12.64 THEN 'Relatively Low Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 12.64 AND d.eqri_norm_cbrt_minmax_b0 <= 21.44 THEN 'Relatively Moderate Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 21.44 AND d.eqri_norm_cbrt_minmax_b0 <= 35.82 THEN 'Relatively High Score'
	WHEN d.eqri_norm_cbrt_minmax_b0 > 35.82 AND d.eqri_norm_cbrt_minmax_b0 <= 100 THEN 'Very High Score'
END AS "eqri_norm_rating_r1"
-- e.geom

FROM results_psra_national.psra_sri_calc1_hg_10km_uc a
LEFT JOIN results_psra_national.psra_sri_calc2_hg_10km_uc b ON a."gridid_10" = b."gridid_10"
LEFT JOIN results_psra_national.psra_sri_calc3_hg_10km_uc c ON a."gridid_10" = c."gridid_10"
LEFT JOIN results_psra_national.psra_sri_calc4_hg_10km_uc d ON a."gridid_10" = d."gridid_10"
-- LEFT JOIN boundaries."HexGrid_10km_unclipped" e ON a."gridid_10" = e."gridid_10"
);

DROP TABLE IF EXISTS results_psra_national.psra_sri_calc1_hg_10km_uc, results_psra_national.psra_sri_calc2_hg_10km_uc, results_psra_national.psra_sri_calc3_hg_10km_uc, results_psra_national.psra_sri_calc4_hg_10km_uc,
results_psra_national.psra_sri_social_fabric_score_hg_10km_uc, results_psra_national.psra_sri_var_hg_10km_uc CASCADE;