select time_stamp,
  x_velocity,
  y_velocity,
  z_velocity,
sqrt(
  (x_velocity * x_velocity) + 
  (y_velocity * y_velocity) + 
  (z_velocity * z_velocity)
)::numeric(10,2) as v_kms
from cda.impacts
where x_velocity <> -99.99


--pythag function
drop function if exists pythag(
  numeric, 
  numeric, 
  numeric
);
create function pythag(
  x numeric, 
  y numeric, 
  z numeric, out numeric)
as $$
  select sqrt(
    (x * x) + 
    (y * y) + 
    (z * z)
  )::numeric(10,2);
$$
language sql;


-- using pythag function
select impact_date,
  pythag(x_velocity, y_velocity, z_velocity) as v_kms
from cda.impacts
where x_velocity <> -99.99

select sclk,
  pythag(
		sc_vel_t_x::numeric, 
		sc_vel_t_y::numeric, 
		sc_vel_t_z::numeric
	) as speed_kms
from import.inms
limit 100


-- BOOYAH
with kms as (
  select impact_date as the_date,
  date_part(‘month’, time_stamp) as month,
  date_part(‘year’, time_stamp) as year,
  pythag(x_velocity, y_velocity, z_velocity) as v_kms
  from cda.impacts
  where x_velocity <> -99.99
), speeds as (
  select kms.*,
  (v_kms * 60 * 60)::integer as kmh,
  (v_kms * 60 * 60 * .621)::integer as mph
  from kms
)
select * from speeds;
