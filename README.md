# pg_sql_2025

[![](https://img.shields.io/badge/Docker-blue.svg)](https://www.docker.com/) [![](https://img.shields.io/badge/Postgres-16.2-lightblue.svg)](https://hub.docker.com/_/postgres)

## Setup and Use

Docker Compose:
```bash
docker compose up
```

Connection settings:
```
Host:       localhost:5432
User:       testuser
Password:   testpassword
Database:   postgres
```

### Scripts

Execute SQL through the Docker Shell:

```bash
# Exec in and login
psql -U postgres

# Execute command
postgres=# SELECT * FROM jsonexample;

# Exit
\q
:q 
```

Execute supplied scripts:
```bash
psql -U postgres -f /lab/scripts/restart.sql
```

```bash
psql -U postgres -f /lab/scripts/explain.sql
psql -U postgres -f /lab/scripts/materialized_view.sql
psql -U postgres -f /lab/scripts/example.sql
psql -U postgres -f /lab/scripts/json.sql
psql -U postgres -f /lab/scripts/joins.sql
psql -U postgres -f /lab/scripts/window.sql
psql -U postgres -f /lab/scripts/extract.sql

# Exit
\q
:q
```

## Gotcha's and Review Topics

1. PG onlysupports `''` not `""` for `VARCHAR`.
2. PG doesn't support `GO` and requires the following wrapping keywords for transactional statements/scripts:
   * `BEGIN;`
   * `END;`
3. Common scenarios for `EXPLAIN`:
   * `EXPLAIN ANALYZE <MY_QUERY>` 
   * `EXPLAIN <MY_QUERY>`
4. Check for dangling `,` and `:`. 
   * Make sure to add semicolons `:` to the end of a statement/command/expression!
5. `LIMIT` keyword is supported:
   * `TOP` is not.
   * `LIMIT` is appended (whereas `TOP` is prepended).
6. Text to Number formatting:
   * https://www.postgresql.org/docs/current/functions-formatting.html
7. **Window Functions** such as `<MY_FUNCTION()> OVER(PARTITION BY <MY_GROUPING_FIELD> <MY_OPTIONAL_FRAME_CLASE> ORDER BY <MY_SORTING_FIELD>)`:
   * Used to compare ordered rows to other rows of that ordering.
   * Note the optional **Frame Clause**: `ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING`.
8. `EXTRACT(<MY_TIME_UNIT> FROM <MY_DATE_OR_TIME_ENTRY>)`
   *  `EXTRACT(MONTH FROM start_date)`
   *  Better than parsing Text or String.
   * `GROUP BY` must also be present within.

## Resources and Links

1. https://www.datacamp.com/blog/top-postgresql-interview-questions-for-all-levels
2. https://www.interviewquery.com/p/postgresql-interview-questions
3. https://www.postgresql.org/docs/current/app-psql.html
4. https://www.postgresql.org/docs/current/functions-formatting.html
5. https://www.postgresql.org/docs/current/tutorial-window.html
6. https://www.postgresql.org/docs/current/datatype-datetime.html#DATATYPE-DATETIME-INPUT-DATES