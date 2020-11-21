/*creates random birthdate weighted by US national average age bands.
Derived ages are based on current year. Min age is 1 and max age is 90*/
CREATE OR REPLACE FUNCTION test.random_birthdate() AS
(
    (
        WITH 
            /*establishes the age band tiers,
            taken from US national averages.
            Percntage weights for the bands come later*/
            bands AS
            (
                SELECT 
                    RAND() AS rnum,
                    /*1 - 14 yrs old--change this if you want a higher minimum age than 1*/
                    EXTRACT(YEAR FROM CURRENT_DATE) - CAST(RAND() * (14 - 1) + 1 AS INT64) AS tier1,
                    /*15-24*/
                    EXTRACT(YEAR FROM CURRENT_DATE) - CAST(RAND() * (24 - 15) + 15 AS INT64) AS tier2,
                    /*25 - 54*/
                    EXTRACT(YEAR FROM CURRENT_DATE) - CAST(RAND() * (54 - 25) + 25 AS INT64) AS tier3,
                    /*55 - 64*/
                    EXTRACT(YEAR FROM CURRENT_DATE) - CAST(RAND() * (64 - 55) + 55 AS INT64) AS tier4,
                    /*64-90--change this if you want a higher max age than 90*/
                    EXTRACT(YEAR FROM CURRENT_DATE) - CAST(RAND() * (90 - 65) + 65 AS INT64) AS tier5
            ),
            /*establishes the percentage weights for each age band.
            This is taken from US national averages AS of 2020,
            adjust AS desired*/
            weights AS
            (
                SELECT
                    (
                        CASE 
                            WHEN rnum BETWEEN 0 AND .1862 THEN bands.tier1
                            WHEN rnum > .1862 AND rnum <= .3174 THEN bands.tier2
                            WHEN rnum > .3174 AND rnum <= .7103 THEN bands.tier3
                            WHEN rnum > .7103 AND rnum <= .8397 THEN bands.tier4
                            ELSE bands.tier5
                        END
                    ) yr
                FROM 
                    bands
            )
        /*starts the main query*/
        SELECT
            /*Does a leap year check of the random year that wAS generated 
            and creates a random date for that year*/
            CASE WHEN
                    (
                        (
                            MOD
                                (   EXTRACT(YEAR FROM CURRENT_DATE) , 4    ) = 0 
                            AND 
                            MOD
                                (   EXTRACT(YEAR FROM CURRENT_DATE) , 100   ) <> 0
                        )    
                        OR
                            MOD
                                (   EXTRACT(YEAR FROM CURRENT_DATE) , 400   ) = 0 
                    /*adds random number of days, between 0 and 365, to Jan 1st if it's a leap year*/
                    ) IS TRUE THEN CAST(CAST(weights.yr AS STRING) || '-01-01' AS DATE) 
                                                                            + CAST(RAND() * (365 - 0) + 0 AS INT64) 
                /*adds random number of days between 0 and 364 if it is not a leap year*/
                ELSE CAST(CAST(weights.yr AS STRING) || '-01-01' AS DATE)
                                                + CAST(RAND() * (364 - 0) + 0 AS INT64) 
                END
        FROM
            weights
    )
)
;
