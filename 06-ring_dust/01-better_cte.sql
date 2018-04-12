drop materialized view if exists flyby_altitudes;
create materialized view flyby_altitudes as
select 
  (sclk::timestamp) as time_stamp,
  date_part('year', (sclk::timestamp)) as year,
  date_part('week', (sclk::timestamp)) as week,
  alt_t::numeric(10,3) as altitude
from import.inms
where target='ENCELADUS'
and alt_t IS NOT NULL;

-- simplifying CTE
with lows_by_week as (
  select year, week,
  min(altitude) as altitude
  from flyby_altitudes
  group by year,week
), nadirs as (
  select (
    min(time_stamp) + (max(time_stamp) - min(time_stamp))/2
    ) as nadir,
    lows_by_week.altitude
  from flyby_altitudes,lows_by_week
  where flyby_altitudes.altitude=lows_by_week.altitude
  and flyby_altitudes.year = lows_by_week.year
  and flyby_altitudes.week = lows_by_week.week
  group by lows_by_week.altitude
  order by nadir
)
select nadir,altitude 
from nadirs;

-- using a function
drop function if exists low_time(
  numeric, 
  double precision, 
  double precision
);
create function low_time(
  alt numeric,
  yr double precision,
  wk double precision, 
  out timestamp without time zone
)
as $$
  select 
    min(time_stamp) 
    + ((max(time_stamp) - min(time_stamp)) /2) 
      as nadir
  from flyby_altitudes
  where flyby_altitudes.altitude=alt
  and flyby_altitudes.year = yr
  and flyby_altitudes.week = wk
$$ language sql;

-- refactored CTE using function
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
select * from nadirs;