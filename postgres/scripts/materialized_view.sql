-- PG Materialized View Examples
BEGIN;
    DROP TABLE IF EXISTS example;

    DROP MATERIALIZED VIEW IF EXISTS my_view_name;
COMMIT;

BEGIN;
    -- Create Table
    CREATE TABLE example (
        id INT,
        msg VARCHAR
    );
COMMIT;
    
BEGIN;
    -- Populate with data
    INSERT INTO example VALUES (1, '1'), (2, '2'), (3, '3'), (4, '4');
COMMIT;

BEGIN;
    -- Create Materialized View
    CREATE MATERIALIZED VIEW my_view_name
    AS
        SELECT * FROM example;
COMMIT;

BEGIN;
    -- Query against the view
    SELECT * FROM my_view_name;
COMMIT;