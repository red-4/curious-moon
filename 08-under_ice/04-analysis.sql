-- using the index - it's fast!
select * from inms.readings
where time_stamp > ‘2015-12-19 17:48:55.275’ 
and time_stamp < ‘2015-12-19 17:49:35.275’;

-- without hardcoded dates
select 
  name, 
  mass_per_charge, 
  time_stamp, 
  inms.readings.altitude 
from inms.readings
inner join flybys
on time_stamp >= window_start  
and time_stamp <= window_end
where flybys.id = 4;

-- speed comparison
select speed, avg(relative_speed)::numeric(9,1)
from flybys
inner join inms.readings on 
  time_stamp >= flybys.window_start and
  time_stamp <= flybys.window_end
group by speed;

