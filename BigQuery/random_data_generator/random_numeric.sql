/*creates random numeric digit*/
CREATE OR REPLACE function demo.random_numeric(low numeric ,high numeric)
as
(
    (
        select rand() * (high - low) + low
    )
)
;
