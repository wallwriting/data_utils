/*creates random numeric digit--rounds the decmials off by the specified number of decimal places*/
CREATE OR REPLACE function dpa.random_numeric_rounded(argLow numeric ,argHigh numeric, argRound INT64)
as
(
    (
        select
          ROUND( 
          CAST((rand() * (argHigh - argLow) + argLow) AS NUMERIC)
          , argRound
          )
    )
)
;

