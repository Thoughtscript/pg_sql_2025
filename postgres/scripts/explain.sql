-- PG Explain Plan Examples
BEGIN;
    DROP TABLE IF EXISTS example;
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
    SELECT * FROM example;
    
    EXPLAIN SELECT * FROM example;
    
    EXPLAIN ANALYZE SELECT * FROM example;
COMMIT;