-- restricting by day
select 
targets.description as target, 
events.time_stamp, 
event_types.description as event
from events
inner join event_types on event_types.id = events.event_type_id
inner join targets on targets.id = events.target_id
where events.time_stamp::date='2005-02-17'
order by events.time_stamp;

-- constrict by Enceladus target
select 
targets.description as target, 
events.time_stamp, 
event_types.description as event
from events
inner join event_types on event_types.id = events.event_type_id
inner join targets on targets.id = events.target_id
where events.time_stamp::date='2005-02-17'
and targets.description = 'enceladus'
order by events.time_stamp;

--using the id as filter instead
select 
targets.description as target, 
events.time_stamp, 
event_types.description as event
from events
inner join event_types on event_types.id = events.event_type_id
inner join targets on targets.id = events.target_id
where events.time_stamp::date='2005-02-17'
and targets.id = 40 
order by events.time_stamp;

