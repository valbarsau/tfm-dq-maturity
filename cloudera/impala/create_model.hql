DROP DATABASE dq_maturity;
CREATE DATABASE dq_maturity;



DROP TABLE dq_maturity.dataset_covid_indonesia_source;
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



DROP TABLE DQ_MATURITY.dataset_covid_indonesia_dmn;
CREATE EXTERNAL TABLE DQ_MATURITY.dataset_covid_indonesia_dmn (
    date_ STRING,
    location_iso_code STRING,
    new_cases STRING,
    new_deaths STRING,
    new_recovered STRING,
    total_cases STRING,
    total_deaths STRING,
    total_recovered STRING,
    location_level STRING,
    province STRING,
    country STRING,
    continent STRING,
    island STRING,
    total_regencies STRING,
    total_cities STRING,
    total_districts STRING,
    total_urban_villages STRING,
    total_rural_villages STRING,
    area_km2 STRING,
    population STRING,
    population_density STRING,
    new_cases_per_million STRING,
    total_cases_per_million STRING,
    new_deaths_per_Million STRING,
    total_deaths_per_million STRING,
    date_completeness BOOLEAN,
    location_iso_code_completeness BOOLEAN,
    new_cases_completeness BOOLEAN,
    new_deaths_completeness BOOLEAN,
    new_recovered_completeness BOOLEAN,
    total_cases_completeness BOOLEAN,
    total_deaths_completeness BOOLEAN,
    total_recovered_completeness BOOLEAN,
    location_level_completeness BOOLEAN,
    province_completeness BOOLEAN,
    country_completeness BOOLEAN,
    continent_completeness BOOLEAN,
    island_completeness BOOLEAN,
    total_regencies_completeness BOOLEAN,
    total_cities_completeness BOOLEAN,
    total_districts_completeness BOOLEAN,
    total_urban_villages_completeness BOOLEAN,
    total_rural_villages_completeness BOOLEAN,
    are_km2_completeness BOOLEAN,
    population_completeness BOOLEAN,
    population_density_completeness BOOLEAN,
    new_cases_per_million_completeness BOOLEAN,
    total_cases_per_million_completeness BOOLEAN,
    new_deaths_per_million_completeness BOOLEAN,
    total_deaths_per_million_completeness BOOLEAN,
    date_accuracy_accomplished_pattern BOOLEAN,
    date_accuracy_year INT,
    date_accuracy_month INT,
    date_accuracy_day INT,   
    date_accuracy STRING,
    location_iso_code_accuracy STRING,
    new_cases_accuracy BOOLEAN,
    new_deaths_accuracy BOOLEAN,
    new_recovered_accuracy BOOLEAN,
    total_cases_accuracy BOOLEAN,
    total_deaths_accuracy BOOLEAN,
    total_recovered_accuracy BOOLEAN,
    location_level_accuracy BOOLEAN,
    province_accuracy BOOLEAN,
    country_accuracy BOOLEAN,
    continent_accuracy BOOLEAN,
    island_accuracy BOOLEAN,
    total_regencies_accuracy BOOLEAN,
    total_cities_accuracy BOOLEAN,
    total_districts_accuracy BOOLEAN,
    total_urban_villages_accuracy BOOLEAN,
    total_rural_villages_accuracy BOOLEAN,
    are_km2_accuracy BOOLEAN,
    population_accuracy BOOLEAN,
    population_density_accuracy STRING,
    new_cases_per_million_accuracy STRING,
    total_cases_per_million_accuracy STRING,
    new_deaths_per_million_accuracy STRING,
    total_deaths_per_million_accuracy STRING,
    new_total_cases_consistency STRING,
    new_total_deaths_consistency STRING,
    new_total_recovered_consistency STRING,
    total_cities_districts_consistency STRING,
    total_districts_urban_villages_consistency STRING,
    population_density_consistency_calculation STRING,
    population_density_consistency_comparison_result STRING,
    new_cases_per_million_consistency_calculation STRING,
    new_cases_per_million_consistency_comparison_result STRING,
    total_cases_per_million_consistency_calculation STRING,
    total_cases_per_million_consistency_comparison_result STRING,
    new_deaths_per_million_consistency_calculation STRING,
    new_deaths_per_million_consistency_comparison_result STRING,
    total_deaths_per_million_consistency_calculation STRING,
    total_deaths_per_million_consistency_comparison_result STRING,
    location_iso_code_level_rural_consistency BOOLEAN,
    ir_completeness STRING,
    rcpmr INT,
    ir_accuracy STRING,
    ramr INT,
    ir_consistency STRING,
    rcsmr INT,
    rar_maturity_level INT,
    rar_maturity_desc STRING,
    rar_first_dimension_to_review STRING,
    rur STRING
)
STORED AS PARQUET
LOCATION '/user/hive/indonesia_covid19'
TBLPROPERTIES ("auto.purge"="true");