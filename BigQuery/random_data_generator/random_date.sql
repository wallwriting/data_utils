/*creates random date. Format must be 'YYYY-MM-DD'*/
CREATE OR REPLACE function dpa.random_date(low date ,high date)
as
(
    (
        SELECT DATE_FROM_UNIX_DATE(CAST(rand() * (UNIX_DATE(high) - UNIX_DATE(low)) + UNIX_DATE(low) as int64))
    )
)
;
