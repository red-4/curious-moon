-- make room for new stuff
alter table flybys
add speed_kms numeric(10,3),
add target_altitude numeric(10,3),
add transit_distance numeric(10,3);

-- calculate b 
select id, altitude,
  (altitude + 252) as total_altitude --b
from flybys;

-- calculate b and c
select id, altitude,
  (altitude + 252) as total_altitude, --b
  ((altitude + 252) / sind(73)) - 252 as target_altitude -- c
from flybys;

-- updating flybys with speed data
update flybys
set target_altitude=(
  (altitude + 252) / sind(73)
) - 252;

update flybys
set 
transit_distance = (
  (target_altitude + 252) * sind(17) * 2
);

-- getting the timestamps
select min(flyby_altitudes.time_stamp)
from flyby_altitudes
inner join flybys on flybys.time_stamp::date 
  = flyby_altitudes.time_stamp::date
and flybys.target_altitude = flyby_altitudes.altitude
