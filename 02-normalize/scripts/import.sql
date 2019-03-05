drop table if exists events cascade;
drop table if exists teams cascade;
drop table if exists targets cascade;
drop table if exists spass_types cascade;
drop table if exists requests cascade;
drop table if exists event_types cascade;

create schema if not exists import;
drop table if exists import.master_plan;
create table import.master_plan(
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
