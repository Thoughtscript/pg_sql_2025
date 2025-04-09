-- PG Basic Queries Examples
BEGIN;
    -- Create Table
    DROP TABLE IF EXISTS example;
    CREATE TABLE example (
        id INT PRIMARY KEY,
        msg VARCHAR
    );
COMMIT;

BEGIN;
    -- Populate with data
    INSERT INTO example VALUES (1, '1'), (2, '2'), (3, '3'), (4, '4'), (5, '4'), (6, '4'), (7, '4');
COMMIT;

BEGIN;
    -- LIMIT last
    SELECT * FROM example AS e 
    ORDER BY e.id ASC 
    LIMIT 3;
COMMIT;

BEGIN;
    -- Unique values
    SELECT DISTINCT e.msg FROM example AS e;
COMMIT;

BEGIN;
    -- GROUP By
    SELECT COUNT(*) FROM example AS e
    GROUP BY e.msg;
COMMIT;

BEGIN;
    -- GROUP By and HAVING
    SELECT COUNT(*) FROM example AS e
    GROUP BY e.msg
    HAVING COUNT(*) > 2;
COMMIT;

BEGIN;
    -- SELECT specific rows by number or ranking
    SELECT *
    FROM (
        SELECT *, 
        ROW_NUMBER() OVER (ORDER BY TO_NUMBER(msg, '9')) AS row_num
        FROM example) AS e
    WHERE e.row_num = 2;
    -- https://www.postgresql.org/docs/current/functions-formatting.html
COMMIT;