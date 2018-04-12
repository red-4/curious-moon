-- load up a new schema for instrument data
drop schema if exists inms cascade;
create schema inms;

-- move chem data in there
alter table chem_data
set schema inms;

-- create the inms. readings table
select 
  sclk::timestamp as time_stamp,
  source::text,
  mass_table,
  alt_t::numeric(9,2) as altitude,
  mass_per_charge::numeric(6,3),
  p_energy::numeric(7,3),
  pythag(
    sc_vel_t_scx::numeric,
    sc_vel_t_scy::numeric,
    sc_vel_t_scz::numeric
  ) as relative_speed,
  c1counts::integer as high_counts,
  c2counts::integer as low_counts
into inms.readings
from import.inms
order by time_stamp;

alter table inms.readings
add id serial primary key;

-- add an FK to the flybys
alter table inms.readings
add flyby_id int references flybys(id);

update inms.readings
set flyby_id=flybys.id
from flybys 
where flybys.date = inms.readings.time_stamp::date;