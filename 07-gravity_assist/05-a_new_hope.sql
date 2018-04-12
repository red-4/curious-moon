-- Eno's CTE
with mins as (
  select 
    min(altitude) as nadir,
    year,week
    from time_altitudes
  group by year, week
  order by year, week
), min_times as (
  select mins.*,
    min(time_stamp) as low_time,
    min(time_stamp) 
      + interval ‘20 seconds’ as window_end,
    min(time_stamp) 
      - interval ‘20 seconds’ as window_start
  from mins
  inner join time_altitudes ta
  on mins.year = ta.year 
  and mins.week = ta.week 
  and mins.nadir = ta.altitude
  group by mins.week, mins.year, mins.nadir 
), fixed_flybys as (
  select f.id, 
    f.name, 
    f.date, 
    f.altitude, 
    f.speed, 
    mt.nadir,
    mt.year, 
    mt.week, 
    mt.low_time, 
    mt.window_start, 
    mt.window_end
  from flybys f
  inner join min_times mt on
  date_part(‘year’, f.date) = mt.year and
  date_part(‘week’, f.date) = mt.week
)


-- create the table from the CTE
select * into flybys_2 
from fixed_flybys
order by date;

-- add a primary key
alter table flybys_2
add primary key (id);

-- drop the flybys table
drop table flybys cascade;
drop table time_altitudes;

-- rename flybys_2
alter table flybys_2
rename to flybys;


-- add a targeted field
alter table flybys
add targeted boolean not null default false;

-- set it
update flybys
set targeted=true
where id in (3,5,7,17,18,21);