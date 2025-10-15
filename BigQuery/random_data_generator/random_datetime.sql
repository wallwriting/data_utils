/*creates random datetime down to microseconds*/
CREATE OR REPLACE function dpa.random_datetime(low timestamp ,high timestamp)
as
(
        (
        SELECT CAST(
                    timestamp_micros(CAST(rand() * (UNIX_micros(high) - UNIX_micros(low)) + UNIX_micros(low) as int64))
                    AS datetime
                    )       
        )
)
;
