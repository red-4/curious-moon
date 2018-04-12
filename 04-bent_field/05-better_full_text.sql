-- look up by closest 
select id, title from enceladus_events
where search @@ to_tsquery('closest');

-- fixing the tsvector
drop view if exists enceladus_events;
create view enceladus_events as
select 
events.id,
events.title,
events.description,
events.time_stamp, 
events.time_stamp::date as date,
event_types.description as event,
to_tsvector(
    concat(events.description,'',events.title)
) as search
from events
inner join event_types 
on event_types.id = events.event_type_id
where target_id=40
order by time_stamp;

-- switching to materialized view
drop view if exists enceladus_events;
create materialized view enceladus_events as
select 
events.id,
events.title,
events.description,
event_types.description as event,
events.time_stamp::date as date,
events.time_stamp,
to_tsvector(concat(
events.description, ' ',
events.title)
) as search
from events
inner join event_types 
on event_types.id = events.event_type_id
where target_id=40
order by time_stamp;

-- indexing it 
create index idx_event_search
on enceladus_events using GIN(search);

-- querying it
select id, date,title
from enceladus_events 
where search @@ to_tsquery('closest');

-- sleuthing the date weirdness
select time_stamp, title 
from events
where time_stamp::date='2009-11-02'
order by time_stamp;

-- again
select (time_stamp at time zone 'UTC'), 
title 
from events
where (time_stamp at time zone 'UTC')::date='2009-11-02'
order by time_stamp;
