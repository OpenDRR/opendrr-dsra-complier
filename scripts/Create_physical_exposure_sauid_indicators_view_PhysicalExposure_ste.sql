-- create schema for new scenario
CREATE SCHEMA IF NOT EXISTS results_nhsl_metrovan_physical_exposure;

-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_settled_area_s CASCADE;
CREATE VIEW results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_settled_area_s AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.1 Settled Area
SELECT 
a.sauid AS "Sauid",
d."PRUID",
d."PRNAME",
d."ERUID",
d."ERNAME",
d."CDUID",
d."CDNAME",
d."CSDUID",
d."CSDNAME",
CAST(CAST(ROUND(CAST(a.sauidlon AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SauidLon",
CAST(CAST(ROUND(CAST(a.sauidlat AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "SauidLat",
c.sactype AS "E_SAC",
a.landuse AS "E_LandUse",
CAST(CAST(ROUND(CAST(a.sauid_km2 AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_AreaKm2",
CAST(CAST(ROUND(CAST(a.sauid_ha AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_AreaHa",
CAST(CAST(ROUND(CAST(SUM(a.number) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgNum",
CAST(CAST(ROUND(CAST(COALESCE(c.censusbldg,0) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_CensusBldg",
CAST(CAST(ROUND(CAST(c.censuspop AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_CensusPop",
CAST(CAST(ROUND(CAST(c.censusdu AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "E_CensusDU",
CAST(CAST(ROUND(CAST(AVG(a.popdu) AS NUMERIC),6) AS FLOAT) AS NUMERIC) as "E_People_DU",

d.geom AS "geom_poly"
--d.geompoint AS "geom_point"

FROM exposure.metrovan_building_exposure a
LEFT JOIN census.census_2016_canada c ON a.sauid = c.sauidt
LEFT JOIN boundaries."Geometry_SAUID" d on a.sauid = d."SAUIDt"
GROUP BY a.sauid,a.sauidlon,a.sauidlat,a.landuse,a.sauid_km2,a.sauid_ha,c.censuspop,c.censusbldg,c.censusdu,c.sactype,c.landuse,d."PRUID",d."PRNAME",d."ERUID",d."ERNAME",d."CDUID",d."CDNAME",d."CSDUID",
d."CSDNAME",d.geom;



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_building_function_s CASCADE;
CREATE VIEW results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_building_function_s AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.2 Building Function
SELECT 
a.sauid AS "Sauid",
d."PRUID",
d."PRNAME",
d."ERUID",
d."ERNAME",
d."CDUID",
d."CDNAME",
d."CSDUID",
d."CSDNAME",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.genocc IN ('Residential-LD','Residential-MD','Residential-HD') THEN a.bldg_ft2 ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgAreaRes",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.genocc = 'Commercial' THEN a.bldg_ft2 ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgAreaComm",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.genocc = 'Industrial' THEN a.bldg_ft2 ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgAreaInd",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.genocc = 'Civic' THEN a.bldg_ft2 ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgAreaCivic",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.genocc = 'Agricultural' THEN a.bldg_ft2 ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgAreaAgr",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_ResLD",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_ResMD",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_RESHD",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.genocc ='Commercial' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Comm",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.genocc ='Industrial' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Ind",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.genocc ='Civic' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Civic",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.genocc ='Agricultural' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Agr",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.genocc ='Residential-LD' THEN a.number ELSE 0 END) / AVG(a.popdu) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_SFHshlds",
CAST(CAST(ROUND(CAST((SUM(CASE WHEN a.genocc ='Residential-MD' THEN a.number ELSE 0 END) + SUM(CASE WHEN a.genocc ='Residential-HD' THEN a.number ELSE 0 END)) / AVG(a.popdu) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "ET_MFHshlds",

d.geom AS "geom_poly"
--d.geompoint AS "geom_point"

FROM exposure.metrovan_building_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d on a.sauid = d."SAUIDt"
GROUP BY a.sauid,d."PRUID",d."PRNAME",d."ERUID",d."ERNAME",d."CDUID",d."CDNAME",d."CSDUID",d."CSDNAME",d.geom;



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_building_type_s CASCADE;
CREATE VIEW results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_building_type_s AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.3 Building Type
SELECT 
a.sauid AS "Sauid",
d."PRUID",
d."PRNAME",
d."ERUID",
d."ERNAME",
d."CDUID",
d."CDNAME",
d."CSDUID",
d."CSDNAME",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='Wood' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Wood",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='Concrete' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Concrete",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='Precast' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PreCast",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='RMasonry' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_RMasonry",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='URMasonry' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_URMasonry",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='Steel' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Steel",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.gentype ='Manufactured' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_Manufactured",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.eqdeslev ='PC' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PreCode",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.eqdeslev ='LC' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_LowCode",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.eqdeslev ='MC' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_ModCode",
CAST(CAST(ROUND(CAST(SUM(CASE WHEN a.eqdeslev ='HC' THEN a.number ELSE 0 END) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_HiCode",

d.geom AS "geom_poly"
--d.geompoint AS "geom_point"

FROM exposure.metrovan_building_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d on a.sauid = d."SAUIDt"
GROUP BY a.sauid,d."PRUID",d."PRNAME",d."ERUID",d."ERNAME",d."CDUID",d."CDNAME",d."CSDUID",d."CSDNAME",d.geom;



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_people_s CASCADE;
CREATE VIEW results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_people_s AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.4 People
SELECT 
a.sauid AS "Sauid",
d."PRUID",
d."PRNAME",
d."ERUID",
d."ERNAME",
d."CDUID",
d."CDNAME",
d."CSDUID",
d."CSDNAME",
CAST(CAST(ROUND(CAST(SUM(a.day) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PopDay",
CAST(CAST(ROUND(CAST(SUM(a.night) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PopNight",
CAST(CAST(ROUND(CAST(SUM(a.transit) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_PopTransit",

d.geom AS "geom_poly"
--d.geompoint AS "geom_point"

FROM exposure.metrovan_building_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d on a.sauid = d."SAUIDt"
GROUP BY a.sauid,d."PRUID",d."PRNAME",d."ERUID",d."ERNAME",d."CDUID",d."CDNAME",d."CSDUID",d."CSDNAME",d.geom;



-- create physical exposure indicators
DROP VIEW IF EXISTS results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_assets_s CASCADE;
CREATE VIEW results_nhsl_metrovan_physical_exposure.nhsl_metrovan_physical_exposure_assets_s AS 

-- 1.0 Human Settlement
-- 1.1 Physical Exposure
-- 1.1.5 Assets
SELECT 
a.sauid AS "Sauid",
d."PRUID",
d."PRNAME",
d."ERUID",
d."ERNAME",
d."CDUID",
d."CDNAME",
d."CSDUID",
d."CSDNAME",
CAST(CAST(ROUND(CAST(SUM(a.structural + a.nonstructural + a.contents) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_AssetValue",
CAST(CAST(ROUND(CAST(SUM(a.structural + a.nonstructural) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_BldgValue",
CAST(CAST(ROUND(CAST(SUM(a.structural) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_StrValue",
CAST(CAST(ROUND(CAST(SUM(a.nonstructural) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_NStrValue",
CAST(CAST(ROUND(CAST(SUM(a.contents) AS NUMERIC),6) AS FLOAT) AS NUMERIC) AS "Et_ContValue",

d.geom AS "geom_poly"
--d.geompoint AS "geom_point"

FROM exposure.metrovan_building_exposure a
LEFT JOIN boundaries."Geometry_SAUID" d on a.sauid = d."SAUIDt"
GROUP BY a.sauid,d."PRUID",d."PRNAME",d."ERUID",d."ERNAME",d."CDUID",d."CDNAME",d."CSDUID",d."CSDNAME",d.geom;