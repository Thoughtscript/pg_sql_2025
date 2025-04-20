BEGIN;
    DROP MATERIALIZED VIEW IF EXISTS my_view_name;

    DROP TRIGGER IF EXISTS list_prior ON example;
    DROP TABLE IF EXISTS example;
    DROP FUNCTION IF EXISTS list_rows;
    DROP FUNCTION IF EXISTS my_add;
    DROP FUNCTION IF EXISTS find_msg_by_id;
    DROP FUNCTION IF EXISTS find_id_by_msg;
    DROP PROCEDURE IF EXISTS example_proc;

    DROP TABLE IF EXISTS jsonexample;
    
    DROP TABLE IF EXISTS example;
    
    DROP TABLE IF EXISTS joinexamplea;
    DROP TABLE IF EXISTS joinexampleb;

    DROP TABLE IF EXISTS employee_performance;
    DROP TABLE IF EXISTS employee_holidays;
COMMIT;