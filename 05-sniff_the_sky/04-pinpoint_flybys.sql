-- lowest flyby for Feb 2005?
select min(altitude)
from flyby_altitudes
where time_stamp::date = '2005-02-17';

-- lowest ever
select time_stamp, 
min(altitude)
from flyby_altitudes
order by min(altitude);

-- group the low data by time
select time_stamp, 
min(altitude)
from flyby_altitudes
group by time_stamp
order by min(altitude);

-- group by year
select 
date_part('year',time_stamp) as year,
min(altitude) as nadir
from flyby_altitudes
group by date_part('year',time_stamp);

-- grouping by year and month
select 
  date_part('year',time_stamp) as year,
  date_part('month',time_stamp) as month,
  min(altitude) as nadir
from flyby_altitudes
group by 
  date_part('year',time_stamp),
  date_part('month',time_stamp);

-- grouping by day
select 
  time_stamp::date as date,
  min(altitude) as nadir
from flyby_altitudes
group by 
  time_stamp::date;
order by date;

-- grouping by week
select 
  date_part('year',time_stamp) as year,
  date_part('week',time_stamp) as week, 
  min(altitude) as altitude
from flyby_altitudes
group by 
  date_part('year',time_stamp),
  date_part('week',time_stamp);