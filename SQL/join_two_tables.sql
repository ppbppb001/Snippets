create table tmptbl (id smallint(5), misc varchar(10)); /* create a table */

load data local infile 'e:\\ipython\\test_actor.id.csv' into table tmptbl;  /* load data from csv into table */

select s.actor_id, s.first_name, t.id
from sakila.actor s, tmptbl t
where s.actor_id=t.id;   /* join two table by conditons in where clause */
 
drop table tmptbl;  /*delte table*/
