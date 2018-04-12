-- simple join
select targets.description as target, 
time_stamp, 
title
from events
inner join targets on target_id=targets.id
order by time_stamp;

-- using partial string
select targets.description as target, 
time_stamp, 
title
from events
inner join targets on target_id=targets.id
where title like '%flyby%' or '%fly by%'
order by time_stamp;

-- correctly done without error
select targets.description as target, 
time_stamp, 
title
from events
inner join targets on target_id=targets.id
where title like '%flyby%' 
or title like '%fly by%'
order by time_stamp;


-- case insenstive
select targets.description as target, 
time_stamp, 
title
from events
inner join targets on target_id=targets.id
where title ilike '%flyby%' 
or title ilike '%fly by%'
order by time_stamp;

-- using regex
select targets.description as target, 
time_stamp, 
title
from events
inner join targets on target_id=targets.id
where title ~* '^T\d.*? flyby'
order by time_stamp;


-- more expansive regex 
select targets.description as target, 
time_stamp, 
title
from events
inner join targets on target_id=targets.id
where title ~* '^T[A-Z0-9_].*? flyby'
order by time_stamp;

-- adding event types
select targets.description as target, 
event_types.description as event,
time_stamp, 
time_stamp::date as date,
title
from events
left join targets on target_id=targets.id
left join event_types on event_type_id=event_types.id
where title ilike '%flyby%' 
or title ilike '%fly by%'
order by time_stamp;


-- sleuthing
select target, title, date 
from import.master_plan 
where start_time_utc::date = '2005-02-17' 
order by start_time_utc::date
order by time_stamp;