-- first look at chem results
select 
  flybys.name, 
  time_stamp, 
  inms.readings.altitude,
  inms.chem_data.name as chem
from inms.readings
inner join flybys on 
  time_stamp >= flybys.window_start 
  and time_stamp <= flybys.window_end
inner join inms.chem_data on 
  peak = mass_per_charge
where flybys.id = 4;


-- with density counters
select 
  inms.chem_data.name,
  sum(high_counts) as high_counts,
  sum(low_counts) as low_counts
from flybys
inner join inms.readings on 
  time_stamp >= flybys.window_start and
  time_stamp <= flybys.window_end
inner join inms.chem_data on peak = mass_per_charge
where flybys.id = 4
group by inms.chem_data.name,flybys.speed
order by high_counts desc;

-- E-3 and Molecular Hydrogen
select 
  inms.chem_data.name,
  source,
  sum(high_counts) as high_counts,
  sum(low_counts) as low_counts
from flybys
inner join inms.readings on 
  time_stamp >= flybys.window_start and
  time_stamp <= flybys.window_end
inner join inms.chem_data on peak = mass_per_charge
where flybys.id = 4
group by inms.chem_data.name, source
order by high_counts desc;

-- are we alone in the universe?
-- such a small query for such a big question...
select 
  flybys.name as flyby,
   inms.chem_data.name,
  source,
  sum(high_counts) as high_counts,
  sum(low_counts) as low_counts
from flybys
inner join inms.readings on 
  time_stamp >= flybys.window_start and
  time_stamp <= flybys.window_end
inner join inms.chem_data on peak = mass_per_charge
where flybys.targeted = true
and formula in (‘H2’,’CH4’,’CO2’,‘H2O’)
group by flybys.id,flybys.name,inms.chem_data.name, source
order by flybys.id;
