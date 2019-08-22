/* --- [Part 1] Current date/time and current_timestamp ---*/

/* output the elements */
select current_date, current_time, current_timestamp;

/* output of current datetime as time_stamp*/
SELECT CAST(CURRENT_DATE AS TIMESTAMP(0)) + ((CURRENT_TIME - TIME '00:00:00') HOUR TO SECOND(0));

/* compare current date/time as time_stamp with the current_timestamp*/
SELECT CAST(CURRENT_DATE AS TIMESTAMP(0)) + ((CURRENT_TIME - TIME '00:00:00') HOUR TO SECOND(0)), CURRENT_TIMESTAMP(0);

/* remove time zone factor from current_timestamp */
select to_timestamp(to_char(current_timestamp, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS');

/* remove time zone factor from current_timestamp and offset by time zone difference(14hours) explicitly */
select to_timestamp(to_char(current_timestamp, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS') + interval '14' hour;



/*--- [Part 2]  Hard coded date time ---*/

select CAST('2019-08-14 20:40:00' as timestamp(0) format 'YYYY-MM-DDBHH:MI:SS');

SELECT CAST('2017-10-15 23:59:59.999999 +10:00' AS TIMESTAMP(6) WITH TIME ZONE FORMAT 'YYYY-MM-DDBHH:MI:SS.S(6)BZ');

SELECT CAST('2017-10-15 23:59:59 +10:00' AS TIMESTAMP(0) FORMAT 'YYYY-MM-DDBHH:MI:SS.S(6)BZ');



/* --- [Part 3] compare date/time by TYPE_DATE/TYPE_TIME -> TIMESTAMP ---*/

/* Test the output of date column */
select cast(bts.datex as timestamp(0))
from bear.timeseries as bts;

/* Test the output of time column */
select (bts.timex - TIME '00:00:00' HOUR to SECOND(0))
from bear.timeseries as bts;

/* Test the output of time column */
select cast(bts.timex as time(0) with time zone)
from bear.timeseries as bts;

/* Combine column of date/time into time_stamp */
select cast(bts.datex as timestamp(0)) + (bts.timex - TIME '00:00:00' HOUR to SECOND(0))
from bear.timeseries as bts;

/* Compare data/time in data table with current date/time */
select *
from bear.timeseries as bts
where cast(bts.datex as timestamp(0)) + (bts.timex - TIME '00:00:00' HOUR to SECOND) > 
(CAST(CURRENT_DATE AS TIMESTAMP(0)) + ((CURRENT_TIME - TIME '00:00:00') HOUR TO SECOND(0)) - interval '10' hour);

/* Compare data/time in data table with hard-coded date/time */
select *
from bear.timeseries as bts
where cast(bts.datex as timestamp(0)) + ((bts.timex - TIME '00:00:00' HOUR to SECOND)) >= 
CAST('2019-08-14 20:40:00' as timestamp(0) format 'YYYY-MM-DDBHH:MI:SS');

/* Compare data/time in data table with hard-coded date/time */
select *
from bear.timeseries as bts
where 
(cast(bts.datex as timestamp(0)) + ((bts.timex - TIME '00:00:00' HOUR to SECOND(0))) >= 
cast('2019-08-14 08:00:00' as timestamp(0) format 'YYYY-MM-DDBHH:MI:SS'))
and
(cast(bts.datex as timestamp(0)) + ((bts.timex - TIME '00:00:00' HOUR to SECOND(0))) < 
cast('2019-08-15 08:00:00' as timestamp(0) format 'YYYY-MM-DDBHH:MI:SS'));



/* --- [Part 4] compare date/time by TYPE_DATE/TYPE_TIME -> STRING -> TIMESTAMP ---*/

/* conver date/time -> string */
/* method-1: using 'concat' */
select concat(concat(to_char(bts.datex,'YYYY-MM-DD'), ' '), to_char(bts.timex))
from bear.timeseries as bts;
/* method-2: using operator '||' */
select to_char(bts.datex,'YYYY-MM-DD') || ' ' || to_char(bts.timex)
from bear.timeseries as bts;


/* conver date/time -> string -> timestamp */
/* method-1: using 'concat' */
select to_timestamp(concat(concat(to_char(bts.datex,'YYYY-MM-DD'), ' '), to_char(bts.timex)), 'YYYY-MM-DD HH24:MI:SS')
from bear.timeseries as bts;
/* method-2: using operator '||' */
select to_timestamp((to_char(bts.datex,'YYYY-MM-DD') || ' ' || to_char(bts.timex)), 'YYYY-MM-DD HH24:MI:SS')
from bear.timeseries as bts;

/* compare date/time with hard-coded datetime */
/* method-1: using 'concat' */
select *
from bear.timeseries as bts
where 
to_timestamp(concat(concat(to_char(bts.datex,'YYYY-MM-DD'), ' '), to_char(bts.timex)), 'YYYY-MM-DD HH24:MI:SS') >= 
to_timestamp('2019-08-14 08:00:00', 'YYYY-MM-DD HH24:MI:SS')
and
to_timestamp(concat(concat(to_char(bts.datex,'YYYY-MM-DD'), ' '), to_char(bts.timex)), 'YYYY-MM-DD HH24:MI:SS') < 
to_timestamp('2019-08-15 08:00:00', 'YYYY-MM-DD HH24:MI:SS');
/* method-2: using operator '||' */
select *
from bear.timeseries as bts
where 
to_timestamp((to_char(bts.datex,'YYYY-MM-DD') || ' ' || to_char(bts.timex)), 'YYYY-MM-DD HH24:MI:SS') >= 
to_timestamp('2019-08-14 08:00:00', 'YYYY-MM-DD HH24:MI:SS')
and
to_timestamp((to_char(bts.datex,'YYYY-MM-DD') || ' ' || to_char(bts.timex)), 'YYYY-MM-DD HH24:MI:SS') < 
to_timestamp('2019-08-15 08:00:00', 'YYYY-MM-DD HH24:MI:SS');

/* compare date/time with current_timestamp */
/* method-1: using 'concat' */
select *
from bear.timeseries as bts
where 
to_timestamp(concat(concat(to_char(bts.datex,'YYYY-MM-DD'), ' '), to_char(bts.timex)), 'YYYY-MM-DD HH24:MI:SS') > 
to_timestamp(to_char(current_timestamp, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS') - interval '120' hour;
/* method-2: using operator '||' */
select *
from bear.timeseries as bts
where 
to_timestamp((to_char(bts.datex,'YYYY-MM-DD') || ' ' || to_char(bts.timex)), 'YYYY-MM-DD HH24:MI:SS') > 
to_timestamp(to_char(current_timestamp, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS') - interval '120' hour;

