/*checks if a date's year is a leapyear*/
CREATE OR REPLACE function leap_year_check(dtArg timestamp) 
RETURNS boolean
volatile
AS $$
 SELECT (datepart(year, $1) % 4 = 0 AND datepart(year, $1) % 100 <> 0) OR datepart(year, $1) % 400 = 0 
$$ language sql
;
