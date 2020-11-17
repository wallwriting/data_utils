/*creates random birthdate weighted by US national average age bands
the dates passed represent the lowest and highest birthdate years desired*/
CREATE OR REPLACE function demo.random_birthdate(low1 date, high1 date)
as
(
    (

        WITH tiers as
        (
        /*establishes percentage tiers,
        taken from US national averages,
        adjust as desired*/
        SELECT
        18.62 as tier_1,
        13.12 as tier_2,
        39.29 as tier_3,
        12.94 as tier_4,
        16.03 as tier_5
        )
        ,
        weight as
        (
        /*associates the weights from above to age bands*/
        select
        sequence_number as year1,
        CASE 
        WHEN sequence_number between 
                extract(year from current_date) - 14 
                AND extract(year from current_date)
                THEN t.tier_1
        WHEN sequence_number between 
                extract(year from current_date) - 24
                AND extract(year from current_date) - 15
                THEN t.tier_2
        WHEN sequence_number between 
                extract(year from current_date) - 54
                AND extract(year from current_date) - 25
                THEN t.tier_3
        WHEN sequence_number between 
                extract(year from current_date) - 64
                AND extract(year from current_date) - 55
                THEN t.tier_4
        ELSE t.tier_5
        END as pct
        from 
--        /*this assumes an age range of between the two explicit numbers below, adjust as desired*/
--        UNNEST(generate_array(extract(year from current_date) - 92, extract(year from current_date) - 13)) as sequence_number
        UNNEST(generate_array(extract(year from low1), extract(year from high1))) as sequence_number
        CROSS JOIN
        tiers t
        )
        ,
        year_as_string AS 
        (
        /*repeats the years based on the percentage weight,
        the higher the weight, the more times the year will
        show up*/
        SELECT *,
        --      extract(year from current_date) - year,
        CAST(w.year1 as string) yr_string
        FROM
        weight w
        /*creates a partial cross join*/
        JOIN 
        UNNEST(generate_array(0,100)) as ms1sequence_number
        ON ms1sequence_number <= w.pct
        order by rand()
        limit 1
        )
        SELECT
                CAST(
                ys.yr_string || '-'
                || CAST(EXTRACT(MONTH from bd1.base_date) as string) || '-'
                || CAST(EXTRACT(DAY FROM bd1.base_date) as string)
                as date)
        FROM
        /*gets a random date in order to extract a random month and day*/
        (
                SELECT DATE_FROM_UNIX_DATE(CAST(rand() * (UNIX_DATE('2019-12-31') - UNIX_DATE('2019-01-01')) + UNIX_DATE('2019-01-01') as int64)) as base_date
        ) as bd1
        CROSS JOIN
        year_as_string ys
    )
)
;
