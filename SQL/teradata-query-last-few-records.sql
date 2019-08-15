-- Get row count --
select count(1)   				/* total non-null rows in column-1 */
from bear.timeseries as bts;


-- Get last 10 records ---
select *
from bear.timeseries
qualify rank() over(order by datex DESC, timex DESC) <= 10;  /* get ranks top 10 after descending sort by datex/timex */


-- get last 10% of records --
select *
from bear.timeseries
qualify rank() over(order by datex DESC, timex DESC) < ((select count(1) from bear.timeseries) * 0.1);