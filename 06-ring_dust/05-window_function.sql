-- simple counts
select targets.description,
count(1) over (
    partition by targets.description
)
from events
inner join targets 
  on targets.id = target_id;

-- target distribution
select targets.description,
count(1) over ()
from events
inner join targets on targets.id = target_id;

-- percentile of target distribution
select 
  targets.description as target,
  100.0 * 
  (
    (count(1) over (
      partition by targets.description      )
    )::numeric / 
    (
      count(1) over ()
    )::numeric  ) as percent_of_mission
from events
inner join targets 
  on targets.id = target_id;

-- isolating with distinct
select 
  distinct(targets.description) as target,
  100.0 * (
    (count(1) over (partition by targets.description))::numeric
    / 
    (count(1) over ())::numeric) 
    as percent_of_mission
from events
inner join targets on targets.id = target_id
order by percent_of_mission desc;

-- looking at teams
select 
distinct(teams.description) as team,
100.0 * 
((count(1) over (partition by teams.description))::numeric /(count(1) over ())::numeric) as percent_of_mission
from events
inner join teams on teams.id = team_id
order by percent_of_mission desc;

-- min/max speeds
with kms as (
  select impact_date as the_date,
  date_part('month', time_stamp) as month,
  date_part('year', time_stamp) as year,
  pythag(x_velocity, y_velocity, z_velocity) as v_kms
  from cda.impacts
  where x_velocity <> -99.99
), speeds as (
  select kms.*,
  (v_kms * 60 * 60)::integer as kmh,
  (v_kms * 60 * 60 * .621)::integer as mph
  from kms
), rollup as (
  select distinct(year,month),
  year, month,
  max(mph) over (partition by month),
  min(mph) over (partition by month)
  from speeds
  order by year, month
)

select * from rollup;
