select current_timestamp;
select current_date;
select current_time;

SELECT CAST(CURRENT_DATE AS TIMESTAMP(0)) + ((CURRENT_TIME - TIME '00:00:00') HOUR TO SECOND(0)) + interval '0' hour;


select *
from bear.timeseries as bts
where cast(bts.datex as timestamp(0)) + (bts.timex - TIME '00:00:00' HOUR to SECOND) > 
(CAST(CURRENT_DATE AS TIMESTAMP(0)) + ((CURRENT_TIME - TIME '00:00:00') HOUR TO SECOND(0)) - interval '1000' minute);

