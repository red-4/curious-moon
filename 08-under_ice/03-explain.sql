-- how bad will this update be?
explain update inms.readings
set flyby_id=flybys.id
from flybys 
where flybys.date = inms.readings.time_stamp::date;

-- how about this one?
explain update inms.readings
set flyby_id = (
  select id from flybys
  where date = inms.readings.time_stamp::date
  limit 1
);

-- a junction table
drop table if exists flyby_readings;
create table flyby_readings(
  reading_id int 
    not null 
    unique
    references inms.readings(id),
  flyby_id int 
    not null 
    references flybys(id),
  primary key(reading_id,flyby_id)
);

-- fill it
insert into flyby_readings(flyby_id, reading_id)
select 
  flybys.id,
  inms.readings.id
from flybys
inner join inms.readings 
on date_part('year',time_stamp) = flybys.year
and date_part('week',time_stamp) = flybys.week;


-- just use an index!
drop table flyby_readings cascade;

create index idx_stamps 
on inms.readings(time_stamp)
where altitude is not null;