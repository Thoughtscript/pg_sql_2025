-- PG JOIN Examples
BEGIN;
    DROP TABLE IF EXISTS joinexamplea;
    DROP TABLE IF EXISTS joinexampleb;
COMMIT;

BEGIN;
  CREATE TABLE joinexamplea (
    id INT,
    text VARCHAR
  );
COMMIT;

BEGIN;
  CREATE TABLE joinexampleb (
    id INT,
    text VARCHAR,
    soft_fk_joinexamplea INT
  );
COMMIT;

BEGIN;
  INSERT INTO joinexamplea VALUES (1, '1'), (2, '2'), (3, '3');

  INSERT INTO joinexampleb VALUES (1, '1', 1), (2, '2', 1), (3, '3', 2), (1, '2', 3);
COMMIT;

BEGIN;
  SELECT * FROM joinexampleb AS B 
  INNER JOIN joinexamplea AS A
  ON B.soft_fk_joinexamplea = A.id;
COMMIT;