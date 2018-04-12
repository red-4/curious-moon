## The INMS Raw Data

If you want to play around with the raw data and push things together using CSV Kit, you'll have to download the corresponding CSVs from the PDS. I would have added that data here, but it's about 30G total!

You can [head over to the PDS archive](https://pds-ppi.igpp.ucla.edu/search/view/?f=yes&id=pds://PPI/CO-S-INMS-3-L1A-U-V1.0/DATA/SATURN) which has an option to download *everything* related to the INMS. You don't need to as we only use a subset of this data, pertaining to Enceladus.

To find that data, run the query in the book which identifies the year and day of year:

```sql
select date_part('year',date), 
to_char(time_stamp, 'DDD') 
from enceladus_events
where event like '%closest%';
```

Now you can click through to each directory, downloading only the CSVs that you need.