-- the year/day of year for flybys
select date_part('year',date), 
to_char(time_stamp, 'DDD') 
from enceladus_events
where event like '%closest%';
