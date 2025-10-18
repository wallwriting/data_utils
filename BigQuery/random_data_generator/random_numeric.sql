/*creates random numeric digit*/
CREATE OR REPLACE function dpa.random_numeric(low numeric ,high numeric)
as
(
    (
        select CAST((rand() * (high - low) + low) AS NUMERIC)
    )
)
;
