-- PG Trigger, Function, and Procedure Examples
BEGIN;
    DROP FUNCTION IF EXISTS list_rows;
    DROP FUNCTION IF EXISTS my_add;
    DROP FUNCTION IF EXISTS find_msg_by_id;
    DROP FUNCTION IF EXISTS find_id_by_msg;
    DROP PROCEDURE IF EXISTS example_proc;
    DROP FUNCTION IF EXISTS trigger_func CASCADE;
COMMIT;

BEGIN;
    DROP TRIGGER IF EXISTS list_prior ON example;
    DROP TABLE IF EXISTS example;
COMMIT;

BEGIN;
    -- Create Table
     CREATE TABLE example (
        id INT,
        msg VARCHAR
    );
COMMIT;

-- Returns
BEGIN;
    -- https://www.postgresql.org/docs/17/xfunc-sql.html
    -- Can use ' instead of $$
    CREATE OR REPLACE FUNCTION find_msg_by_id(x INTEGER) RETURNS VARCHAR AS $$
        SELECT msg 
        FROM example
        WHERE id = x;
    $$ LANGUAGE SQL;
COMMIT;

BEGIN;
    -- https://www.postgresql.org/docs/17/xfunc-sql.html
    CREATE OR REPLACE FUNCTION find_id_by_msg(msg VARCHAR) RETURNS INTEGER AS '
        SELECT id 
        FROM example 
        WHERE msg = msg;
    ' LANGUAGE SQL;
COMMIT;

BEGIN;
    -- https://www.postgresql.org/docs/17/xfunc-sql.html
    CREATE OR REPLACE FUNCTION my_add(x INTEGER, y INTEGER) RETURNS INTEGER AS '
        SELECT x + y;
    ' LANGUAGE SQL;
COMMIT;

BEGIN;
    -- RETURN multiple records
    CREATE OR REPLACE FUNCTION list_rows() RETURNS TABLE(id INT, msg VARCHAR) AS '
        SELECT * FROM example;
    ' LANGUAGE SQL;
COMMIT;

BEGIN;
    -- Doesn't return
    CREATE PROCEDURE example_proc(x INTEGER, y VARCHAR) AS '
        UPDATE example SET msg = y WHERE id = x;
    ' LANGUAGE SQL;
COMMIT;

BEGIN;
    -- https://www.postgresql.org/docs/current/plpgsql-trigger.html
    -- TRIGGER FUNCTIONS must support TRIGGER and event RETURNS
    CREATE OR REPLACE FUNCTION trigger_func() RETURNS TRIGGER AS $$
        DECLARE
            my_id INTEGER;
        BEGIN
            SELECT id FROM example ORDER BY id DESC LIMIT 1 into my_id;
            RAISE NOTICE 'TRIGGER my_id: %', my_id;
            -- Must have a RETURN 
            RETURN NULL;
        END;
    $$ LANGUAGE plpgsql; -- Must be plpgsql

    -- https://www.postgresql.org/docs/current/sql-createtrigger.html
    -- Although the documentation still describes PROCEDURES - it's now an alias for FUNCTIONS only
    -- Only FUNCTIONS can be used with TRIGGERS now
    CREATE OR REPLACE TRIGGER list_prior
        AFTER INSERT OR UPDATE ON example
        EXECUTE FUNCTION trigger_func();
COMMIT;

BEGIN;
    -- Populate with data
    INSERT INTO example VALUES (1, '1'), (2, '2'), (3, '3'), (4, '4'), (5, '4'), (6, '4'), (7, '4');
    -- This single INSERT statement will TRIGGER once.

    INSERT INTO example VALUES (8, '100');
COMMIT;

-- Can only DECLARE outside a FUNCTION or PROCEDURE like so...
DO $$
DECLARE 
    my_var INTEGER;
    my_other_var INTEGER DEFAULT -1;
    my_text VARCHAR;
BEGIN
    SELECT find_msg_by_id(5) INTO my_text;
    RAISE NOTICE 'my_text: %', my_text; -- One of the easiest/best ways to log VARIABLES

    SELECT find_id_by_msg(my_text) INTO my_var;
    RAISE NOTICE 'my_var: %', my_var;

    --https://www.postgresql.org/docs/17/sql-call.html
    CALL example_proc(1, '999');
   
    SELECT my_add(my_var, 2) INTO my_var;
    RAISE NOTICE 'my_var: %', my_var;

    SELECT my_add(my_var, 5) INTO my_other_var;
    RAISE NOTICE 'my_other_var: %', my_other_var;
END $$;

BEGIN;
    SELECT * FROM example;
COMMIT;

BEGIN;
    CALL example_proc(2, '999');
    CALL example_proc(3, '999');

    SELECT list_rows();
COMMIT;