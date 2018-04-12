--creating a view
drop view if exists enceladus_events;
create view enceladus_events as
select 
events.time_stamp, 
events.time_stamp::date as date,
event_types.description as event
from events
inner join event_types 
on event_types.id = events.event_type_id
where target_id=40
order by time_stamp;

-- querying the view
select * from enceladus_events
where date='2005-02-17';

-- redoing the view 
drop view if exists enceladus_events;
create view enceladus_events as
select 
events.id,
events.title,
events.description,
events.time_stamp, 
events.time_stamp::date as date,
event_types.description as event
from events
inner join event_types 
on event_types.id = events.event_type_id
where target_id=40
order by time_stamp;

