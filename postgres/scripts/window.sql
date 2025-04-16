-- PG Window Function Examples

-- https://datalemur.com/blog/alight-solutions-sql-interview-questions
BEGIN;
    -- Create Table
    DROP TABLE IF EXISTS employee_performance;
    CREATE TABLE employee_performance (
        transaction_id INT PRIMARY KEY,
        employee_id VARCHAR,
        quarter INT,
        year INT,
        performance_rating DEC
    );
COMMIT;

BEGIN;
    -- Populate with data
    INSERT INTO employee_performance VALUES 
        (1, '001', 1, 2022, 3.5), 
        (2, '001', 2, 2022, 3.7), 
        (3, '002', 3, 2022, 4.1), 
        (4, '001', 3, 2022, 3.8),  
        (5, '002', 4, 2022, 4.3), 
        (6, '003', 1, 2022, 4.0), 
        (7, '002', 2, 2022, 3.9), 
        (8, '003', 3, 2022, 3.7), 
        (9, '003', 4, 2022, 4.0);
COMMIT;

/*
"As an HR analytics firm, Alight Solutions has to deal with a lot of employee data. Suppose, we have data of employees' 
performance throughout a year. We want to find out the average performance rating, maximum and minimum performance 
rating of each employee from the previous quarter. Create a SQL query to solve this problem using a Window Function."

year 	quarter	    employee_id	    avg_performance_rating	    max_performance_rating	    min_performance_rating
2022	2	        001	            3.6	                        3.7	                        3.5
2022	3	        001	            3.7	                        3.8	                        3.5
2022	4	        001	            3.66	                    3.8	                        3.5
2022	2	        002	            4.1	                        4.1	                        4.1
2022	3	        002             4.0	                        4.1	                        3.9
2022	4	        002	            4.1	                        4.3	                        3.9
2022	2	        003	            4.0	                        4.0	                        4.0
2022	3	        003	            3.85	                    4.0	                        3.7
2022	4	        003	            3.9	                        4.0	                        3.7
*/

BEGIN;
    -- https://www.postgresql.org/docs/current/tutorial-window.html
    SELECT
        year, 
        quarter, 
        employee_id,

        AVG(performance_rating) 
            OVER(PARTITION BY employee_id
                    ORDER BY quarter 
                    ROWS BETWEEN UNBOUNDED PRECEDING 
                    AND 1 PRECEDING) AS avg_performance_rating, 

        MAX(performance_rating) 
            OVER(PARTITION BY employee_id 
                    ORDER BY quarter 
                    ROWS BETWEEN UNBOUNDED PRECEDING 
                    AND 1 PRECEDING) AS max_performance_rating, 

        MIN(performance_rating)
            OVER(PARTITION BY employee_id 
                    ORDER BY quarter
                    ROWS BETWEEN UNBOUNDED PRECEDING 
                    AND 1 PRECEDING) AS min_performance_rating
    
    FROM employee_performance;
COMMIT;

/*
    Note: I've tinkered around a bit with the query above.
    
    It's from the link: https://datalemur.com/blog/alight-solutions-sql-interview-questions

    It seems a bit off. Verbatim copied results in the following:

    year | quarter | employee_id | avg_performance_rating | max_performance_rating | min_performance_rating 
    ------+---------+-------------+------------------------+------------------------+------------------------
    2022 |       1 | 001         |                        |                        |                       
    2022 |       2 | 001         |     3.5000000000000000 |                    3.5 |                    3.5
    2022 |       3 | 001         |     3.6000000000000000 |                    3.7 |                    3.5
    2022 |       2 | 002         |                        |                        |                       
    2022 |       3 | 002         |     3.9000000000000000 |                    3.9 |                    3.9
    2022 |       4 | 002         |     4.0000000000000000 |                    4.1 |                    3.9
    2022 |       1 | 003         |                        |                        |                       
    2022 |       3 | 003         |     4.0000000000000000 |                    4.0 |                    4.0
    2022 |       4 | 003         |     3.8500000000000000 |                    4.0 |                    3.7

    The adjusted query below displays something closer to the intended target output. 
    (Since in the original output example - the first quarter is always omitted.)
*/

BEGIN;
    -- https://www.postgresql.org/docs/current/tutorial-window.html
    SELECT 
        x.year,
        x.quarter,
        x.employee_id,
        x.avg_performance_rating,
        x.max_performance_rating,
        x.min_performance_rating 

    FROM 
        (SELECT
            year, 
            quarter, 
            employee_id,

            AVG(performance_rating) 
                OVER(PARTITION BY employee_id
                    ORDER BY quarter 
                    ROWS BETWEEN UNBOUNDED PRECEDING 
                    AND 1 PRECEDING) AS avg_performance_rating, 

            MAX(performance_rating) 
                OVER(PARTITION BY employee_id 
                    ORDER BY quarter 
                    ROWS BETWEEN UNBOUNDED PRECEDING 
                    AND 1 PRECEDING) AS max_performance_rating, 

            MIN(performance_rating)
                OVER(PARTITION BY employee_id 
                    ORDER BY quarter
                    ROWS BETWEEN UNBOUNDED PRECEDING 
                    AND 1 PRECEDING) AS min_performance_rating
    
        FROM employee_performance) AS x

    WHERE x.avg_performance_rating IS NOT NULL;
COMMIT;

/*
    year | quarter | employee_id | avg_performance_rating | max_performance_rating | min_performance_rating 
    ------+---------+-------------+------------------------+------------------------+------------------------
    2022 |       2 | 001         |     3.5000000000000000 |                    3.5 |                    3.5
    2022 |       3 | 001         |     3.6000000000000000 |                    3.7 |                    3.5
    2022 |       3 | 002         |     3.9000000000000000 |                    3.9 |                    3.9
    2022 |       4 | 002         |     4.0000000000000000 |                    4.1 |                    3.9
    2022 |       3 | 003         |     4.0000000000000000 |                    4.0 |                    4.0
    2022 |       4 | 003         |     3.8500000000000000 |                    4.0 |                    3.7
*/