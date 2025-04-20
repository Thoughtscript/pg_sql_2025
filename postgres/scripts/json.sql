-- PG JSON Examples
BEGIN;
  DROP TABLE IF EXISTS jsonexample;
COMMIT;

BEGIN;
  -- Create table after check.   
  CREATE TABLE jsonexample (
    id INT,
    json_col JSON,
    json_array_col JSON,
    jsonb_col JSONB,
    jsonb_array_col JSONB
  );
COMMIT;

BEGIN;
  -- Insert values into table.
  INSERT INTO jsonexample VALUES (1,
    '[1,2,3]'::json,
    '[{"id": 0, "name": "a"},{"id": 1, "name": "a"},{"id": 2, "name": "c"}]'::json,
    '[1,2,3]'::jsonb,
    '[{"id": 0, "name": "a"},{"id": 1, "name": "a"},{"id": 2, "name": "c"}]'::jsonb
  );
COMMIT;

BEGIN;
  SELECT * FROM jsonexample;
COMMIT;

BEGIN;
  -- Insert more values into table.
  INSERT INTO jsonexample VALUES (2,
    '[1,2,3]'::json,
    '[{"id": 0, "name": "a"},{"id": 1, "name": "a"},{"id": 2, "name": "c"}]'::json,
    '[1,2,3]'::jsonb,
    '[{"id": 0, "name": "a"},{"id": 1, "name": "a"},{"id": 2, "name": "c"}]'::jsonb
  );

  INSERT INTO jsonexample
  SELECT id, json_col, json_array_col, jsonb_col, jsonb_array_col
  FROM json_populate_record (NULL::jsonexample,
    '{
      "id": 3,
      "json_col": {"name": "bob", "age": 111},
      "json_array_col": [{"id": 0, "name": "a"},{"id": 1, "name": "a"},{"id": 2, "name": "c"}],
      "jsonb_col": {"name": "sarah", "age": 2222},
      "jsonb_array_col": [{"id": 0, "name": "a"},{"id": 1, "name": "a"},{"id": 2, "name": "c"}]
    }'
 );
COMMIT;

BEGIN;
  -- Query into json array
  SELECT arr -> 'id' AS json_id, arr -> 'name' AS json_name 
  FROM jsonexample e, json_array_elements(e.json_array_col) arr
  WHERE (arr ->> 'id')::int > -1;

  -- Query json column
  SELECT json_col::json ->> 2 FROM jsonexample;

  SELECT json_col -> 'age' FROM jsonexample;

  SELECT json_col -> 'age' AS json_age FROM jsonexample WHERE (json_col ->> 'age')::int = 111;

  -- Query into jsonb array

  SELECT arr -> 'id' AS json_id, arr -> 'name' AS json_name
  FROM jsonexample e, jsonb_array_elements(e.jsonb_array_col) arr
  WHERE (arr ->> 'id')::int > -1;

  -- Query jsonb column

  SELECT jsonb_col::json ->> 2 FROM jsonexample;

  SELECT jsonb_col -> 'age' FROM jsonexample;

  SELECT jsonb_col -> 'name' AS jsonb_name, jsonb_col -> 'age' AS jsonb_age
  FROM jsonexample WHERE (jsonb_col ->> 'name') = 'sarah';
COMMIT;