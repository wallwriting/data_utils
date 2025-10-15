/*creates random integer*/
CREATE OR REPLACE function dpa.random_integer(low int64 ,high int64)
as
((select cast(rand() * (high - low) + low as int64)))
;
