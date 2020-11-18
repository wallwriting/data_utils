/*checks if a date's year is a leapyear*/
CREATE OR REPLACE function demo.leap_year_check(dt1 date) 
RETURNS boolean
as
(
    (
        SELECT 
            (
              MOD
                  (   extract(year from dt1) , 4    ) = 0 
              AND 
              MOD
                  (   extract(year from dt1) , 100   ) <> 0
            )    
            OR
              MOD
                  (   extract(year from dt1) , 400   ) = 0 
    )
)
;
