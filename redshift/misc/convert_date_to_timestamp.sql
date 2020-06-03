/*takes inputted date and adds a random timestamp to it*/
CREATE OR REPLACE function fn_dt_to_ts(dt1 IN date) 
RETURNS timestamp
volatile
AS $$

/*takes a date and converts it to a timestamp with a random time set*/
select 
		cast(
		cast(($1) as varchar(50)) || ' ' ||
		cast(cast(floor(random()* (23-0 + 1) + 0) as smallint) as varchar(2)) || ':' ||
		cast(cast(floor(random()* (59-0 + 1) + 0) as smallint) as varchar(2)) || ':' ||
		cast(cast(floor(random()* (59-0 + 1) + 0) as smallint) as varchar(2)) || '.' ||
		cast(cast(floor(random()* (9999-0 + 1) + 0) as smallint) as varchar(4))
		as timestamp)
$$ language sql
