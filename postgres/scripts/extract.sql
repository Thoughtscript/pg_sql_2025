BEGIN;
    -- Create Table
    DROP TABLE IF EXISTS employee_holidays;
    -- https://www.postgresql.org/docs/current/datatype-datetime.html#DATATYPE-DATETIME-INPUT-DATES
    CREATE TABLE employee_holidays  (
        employee_id INT PRIMARY KEY,
        begin_date DATE, -- inclusive
        end_date DATE -- exclusive
    );
COMMIT;

BEGIN;
    -- Populate with data
    INSERT INTO employee_holidays VALUES 
        (7542, '2021-06-22', '2021-06-24'), 
        (4845, '2021-05-01', '2021-05-05'), 
        (6351, '2021-12-24', '2021-12-28'), 
        (9636, '2021-03-01', '2021-03-01'), 
        (8426, '2021-09-10', '2021-09-15');
COMMIT;

/*
"As a database admin for Alight Solutions human resource department, 
you want to know how many days off employees took on average each month 
in 2021. Your task is to write a SQL query to calculate this information 
using the employee_holidays table, which has the following structure:"

month	average_days_off
3	    1
5	    5
6	    3
9	    6
12	    5
*/

BEGIN;
    SELECT 
        EXTRACT(MONTH FROM begin_date) AS month,
        AVG(end_date - begin_date + 1) AS average_days_off
    
    FROM employee_holidays

    WHERE 
        EXTRACT(YEAR FROM end_date) = 2021

    GROUP BY begin_date

    ORDER BY month ASC;
COMMIT;

/*
 month |    average_days_off    
-------+------------------------
     3 | 1.00000000000000000000
     5 |     5.0000000000000000
     6 |     3.0000000000000000
     9 |     6.0000000000000000
    12 |     5.0000000000000000
*/