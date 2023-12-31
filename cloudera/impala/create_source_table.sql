DROP TABLE IF EXISTS dq_maturity.dataset_covid_indonesia_source;
CREATE EXTERNAL TABLE dq_maturity.dataset_covid_indonesia_source (
    date_ STRING,
    location_iso_code STRING,
    location_ STRING,
    new_cases STRING,
    new_deaths STRING,
    new_recovered STRING,
    new_active_cases STRING,
    total_cases STRING,
    total_deaths STRING,
    total_recovered STRING,
    total_active_cases STRING,
    location_level STRING,
    city_or_regency STRING,
    province STRING,
    country STRING,
    continent STRING,
    island STRING,
    time_zone STRING,
    special_status STRING,
    total_regencies STRING,
    total_cities STRING,
    total_districts STRING,
    total_urban_villages STRING,
    total_rural_villages STRING,
    area_km2 STRING,
    population STRING,
    population_density STRING,
    longitude STRING,
    latitude STRING,
    new_cases_per_million STRING,
    total_cases_per_million STRING,
    new_deaths_per_million STRING,
    total_deaths_per_million STRING,
    total_deaths_per_rb STRING,
    case_fatality_rate STRING,
    case_recovered_rate STRING,
    growth_factor_of_new_cases STRING,
    growth_factor_of_new_deaths STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ";"
LOCATION '/user/hive/source'
TBLPROPERTIES('serialization.null.format'='');
