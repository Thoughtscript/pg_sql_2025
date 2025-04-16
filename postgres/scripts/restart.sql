BEGIN;
    DROP MATERIALIZED VIEW IF EXISTS my_view_name;

    DROP TABLE IF EXISTS jsonexample;
    
    DROP TABLE IF EXISTS example;
    
    DROP TABLE IF EXISTS joinexamplea;
    DROP TABLE IF EXISTS joinexampleb;

    DROP TABLE IF EXISTS employee_performance;
    DROP TABLE IF EXISTS employee_holidays;
COMMIT;