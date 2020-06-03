/*creates random integer*/
CREATE OR REPLACE function random_integer(low BIGINT ,high BIGINT) 
RETURNS BIGINT
volatile
AS $$
   select cast(random() * ($2 - $1) + $1 as bigint)
/*use this  to drop*/
--drop function random_between(bigint, bigint)

/*use this syntax to use query results as the arguments*/
-- select
-- random_between(
--   --arg1
--   (select count(*) FROM /*table1*/)
--   , 
--   --arg2
--   (select count(*) FROM /*table2*/)
--   )

$$ language sql

;


/*creates a random decimal between two specified decimals*/
CREATE OR REPLACE function random_decimal(low decimal ,high decimal) 
RETURNS decimal
volatile
AS $$
   select random() * ($2 - $1) + $1

$$ language sql

;
