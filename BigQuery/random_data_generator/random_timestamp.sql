/*creates random timestamp down to microseconds*/
CREATE OR REPLACE function dpa.random_timestamp(low timestamp ,high timestamp)
as
(
    (
        SELECT timestamp_micros(CAST(rand() * (UNIX_micros(high) - UNIX_micros(low)) + UNIX_micros(low) as int64))
    )
)
;
