-- timestamps for lowest flyby
select 
  time_stamp as nadir,
  altitude
from flyby_altitudes
where flyby_altitudes.altitude=28.576
and date_part(‘year’, time_stamp) = 2008
and date_part(‘week’, time_stamp) = 41;

-- the lowest timestamp for that week
select 
  min(time_stamp) +
  (max(time_stamp) - min(time_stamp))/2
  as nadir,
  altitude
from flyby_altitudes
where flyby_altitudes.altitude=28.576
and date_part(‘year’, time_stamp) = 2008
and date_part(‘week’, time_stamp) = 41
group by altitude;

-- the CTE
with lows_by_week as (
  select 
    date_part(‘year’,time_stamp) as year,
    date_part(‘week’,time_stamp) as week, 
    min(altitude) as altitude
  from flyby_altitudes
  group by 
    date_part(‘year’,time_stamp),
    date_part(‘week’,time_stamp)
), nadirs as (
  select (
      min(time_stamp) + (max(time_stamp) - min(time_stamp))/2
    ) as nadir,
    lows_by_week.altitude
  from flyby_altitudes,lows_by_week
  where flyby_altitudes.altitude
    =lows_by_week.altitude
  and date_part(‘year’, time_stamp) 
    = lows_by_week.year
  and date_part(‘week’, time_stamp) 
    = lows_by_week.week
  group by lows_by_week.altitude
  order by nadir
)
select 
  nadir at time zone ‘UTC’,
  altitude 
from nadirs;