create table chem_data(
  name text,
  formula varchar(10),
  molecular_weight integer,
  peak integer,
  sensitivity numeric
);

copy chem_data 
from '[PATH]/data/chem_data.csv' -- data/INMS directory
with delimiter ',' header csv;
