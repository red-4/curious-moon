drop table if exists master_plan;
create table master_plan(
  start_time_utc text,
  duration text,
  date text,
  team text,
  spass_type text,
  target text,
  request_name text,
  library_definition text,
  title text,
  description text
);
COPY import.master_plan FROM '/Users/rob/@Working/Enceladus/demos/01-enceladus_db/data/master_plan.csv' WITH DELIMITER ',' HEADER CSV;
-- will use to split up lookups