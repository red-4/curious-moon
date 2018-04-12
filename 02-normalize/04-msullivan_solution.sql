-- it's the joins!
select 
  import.master_plan.start_time_utc::timestamp, 
  import.master_plan.title, 
  import.master_plan.description,
  event_types.id as event_type_id,
  targets.id as target_id,
  teams.id as team_id,
  requests.id as request_id,
  spass_types.id as spass_type_id
from import.master_plan
inner join event_types 
  on event_types.description 
  = import.master_plan.library_definition
left join targets 
  on targets.description 
  = import.master_plan.target
left join teams 
  on teams.description 
  = import.master_plan.team
left join requests 
  on requests.description 
  = import.master_plan.request_name
left join spass_types 
  on spass_types.description 
  = import.master_plan.spass_type;
