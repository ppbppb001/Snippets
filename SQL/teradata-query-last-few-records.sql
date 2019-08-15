/* Get row count */
select count(1)   				/* total non-null rows in column-1 */
from bear.timeseries as bts;


/* Get last 10 records - descending result */
select *
from bear.timeseries
qualify rank() over(order by datex DESC, timex DESC) <= 10;  /* get ranks top 10 after descending sort by datex/timex */

/* Get last 10 records - descending result - simpler verion*/
select *
from bear.timeseries
qualify rank(datex, timex) <= 10;  /* get ranks top 10 after descending sort by datex/timex */

/* Get last 10 records - ascending result */
select * order by datex ASC, timex ASC
from bear.timeseries
qualify rank() over(order by datex DESC, timex DESC) <= 10;  /* get ranks top 10 after descending sort by datex/timex */

/* Get last 10 records - ascending result - simpler version*/
select * order by datex ASC, timex ASC
from bear.timeseries
qualify rank(datex, timex) <= 10;  /* get ranks top 10 after descending sort by datex/timex */


/* get last 10% of records - descending result */
select *
from bear.timeseries
qualify rank() over(order by datex DESC, timex DESC) <= ((select count(1) from bear.timeseries) * 0.1);

/* get last 10% of records - descending result - simpler version*/
select *
from bear.timeseries
qualify rank(datex, timex) <= ((select count(1) from bear.timeseries) * 0.1);
