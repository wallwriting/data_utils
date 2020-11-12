/*creates random integer*/
CREATE OR REPLACE function demo.random_integer(low int64 ,high int64)
as
((select cast(rand() * (low - high) + low as int64)))
;
