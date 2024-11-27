-- script to generate Canada  site level exposure table

DROP TABLE IF EXISTS exposure.metrovan_site_exposure CASCADE;

-- create table
CREATE TABLE exposure.metrovan_site_exposure(
PRIMARY KEY (id),
OBJECTID varchar,
id varchar,
SiteID varchar,
SiteLon float,
SiteLat float,
SauidID varchar,
SauidLat float,
SauidLon float,
Sauid_km2 float,
Sauid_ha float,
LandUse varchar,
taxonomy varchar,
number float,
structural float,
nonstructural float,
contents float,
business float,
"limit" float,
deductible float,
retrofitting float,
day float,
night float,
transit float,
GenOcc varchar,
OccClass1 varchar,
OccClass2 varchar,
PopDU float,
GenType varchar,
BldgType varchar,
NumFloors float,
Bldg_ft2 float,
BldYear float,
BldEpoch varchar,
SSC_Zone varchar,
EqDesLev varchar,
sauid varchar,
dauid varchar,
adauid varchar,
fsauid varchar,
csduid varchar,
csdname varchar,
cduid varchar,
cdname varchar,
SAC varchar,
eruid varchar,
ername varchar,
pruid varchar,
prname varchar,
OBJECTID_1 varchar,
OBJECTID_12 varchar,
SAUIDt varchar,
SAUIDi varchar,
Lon varchar,
Lat varchar,
Area_km2 varchar,
Area_ha varchar,
DAUIDt varchar,
DAUIDi varchar,
ADAUID_1 varchar,
CFSAUID varchar,
PRUID_1 varchar,
PRNAME_1 varchar,
CSDUID_1 varchar,
CSDNAME_1 varchar,
CSDTYPE varchar,
CDUID_1 varchar,
CDNAME_1 varchar,
CDTYPE varchar,
CCSUID varchar,
CCSNAME varchar,
ERUID_1 varchar,
ERNAME_1 varchar,
SACCODE varchar,
SACTYPE varchar,
CMAUID varchar,
CMAPUID varchar,
CMANAME varchar,
CMATYPE varchar,
Shape_Leng varchar,
Shape_Length varchar,
Shape_Area varchar

);