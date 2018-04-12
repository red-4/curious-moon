-- convenience for redoing
drop table if exists flybys;

--redone CTE
with lows_by_week as (
  select year, week,
  min(altitude) as altitude
  from flyby_altitudes
  group by year, week
), nadirs as (
  select low_time(altitude,year,week) as time_stamp,
  altitude
  from lows_by_week
)

-- exec the CTE, pushing results into flybys
select nadirs.*,
  -- set initial vals to null
  null::varchar as name,
  null::timestamptz as start_time,
  null::timestamptz as end_time
-- push to a new table
into flybys
from nadirs;

-- add a primary key
alter table flybys
add column id serial primary key;

-- using the key, create 
-- the name using the new id
-- || concatenates strings
-- and also coerces to string
update flybys
set name=’E-’|| id-1;
