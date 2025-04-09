-- Create super user.

CREATE ROLE testuser LOGIN SUPERUSER PASSWORD 'testpassword';

DROP MATERIALIZED VIEW IF EXISTS my_view_name;

DROP TABLE IF EXISTS jsonexample;
DROP TABLE IF EXISTS example;
    
DROP TABLE IF EXISTS joinexamplea;
DROP TABLE IF EXISTS joinexampleb;