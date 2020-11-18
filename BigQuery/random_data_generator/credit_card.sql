/*creates a credit card number, this will create non-valid numbers.
In order to create numbers that more closely follow real credit card rules,
generally for AI/ML purposes, change the first digit: 1 to 3, 7 to 4, 8 to 5, 9 to 6. 
*/
CREATE OR REPLACE FUNCTION demo.credit_card_generator()
as
(
    (
        WITH 
        numpart1 as
        (
            SELECT 
                CAST(rand() * (9999 - 1) + 1 as int64) as num1
        ),
        numpart2 as
        (
            SELECT 
                CAST(rand() * (9999 - 1) + 1 as int64) as num2
        ),
        numpart3a as
        (
            SELECT 
                CAST(rand() * (999 - 1) + 1 as int64) as num3a
        ),
        numpart3b as
        (
            SELECT 
                CAST(rand() * (9 - 0) + 0 as int64) as num3b
        ),
        numpart3c as
        (
            SELECT 
                CAST(rand() * (9 - 0) + 0 as int64) as num3c
        ),
        factor1 as
        (
            SELECT 
                CAST(rand() * (100 - 1) + 1 as int64) as fct1
        ),
        digit2 as
        (
            SELECT
                /*Breakfast Club*/
                CAST(CAST(rand() * (3 - 1) + 1 as int64) as string) as club,
                /*Siberian Express*/
                CAST(CAST(rand() * (2 - 1) + 1 as int64) as string) as exprs,
                /*Everything else*/
                CAST(CAST(rand() * (9 - 0) + 0 as int64) as string) as misc
        )

        SELECT
            CASE
                /*Breakfast Club*/
                WHEN fct1 BETWEEN 1 AND 3 THEN '1'
                /*Disk Hoover*/
                WHEN fct1 BETWEEN 4 AND 15 THEN '9'
                /*Siberian Express*/
                WHEN fct1 BETWEEN 16 AND 40 THEN '1'
                /*Pisa*/
                WHEN fct1 BETWEEN 41 AND 70 THEN '7'
                /*Meister Karte*/
                ELSE '8' 
                END
            ||
            CASE
                /*Breakfast Club*/
                WHEN fct1 BETWEEN 1 AND 3 THEN REPLACE(
                                                    REPLACE(
                                                        REPLACE(club, '1', '0')
                                                    , '2', '6')
                                                    , '3', '8')
                /*Siberian Express*/
                WHEN fct1 BETWEEN 16 AND 40 THEN REPLACE(
                                                    REPLACE(exprs, '1', '4')
                                                    , '2', '7')
                ELSE misc
                END
            ||
            CASE
                WHEN num1 <10 THEN '000' || cast(num1 as string)
                WHEN num1 <100 THEN '00' || cast(num1 as string)
                WHEN num1 <1000 THEN '0' || cast(num1 as string)
                ELSE cast(num1 as string)
                END
            ||
            CASE 
                WHEN num2 <10 THEN '000' || cast(num2 as string)
                WHEN num2 <100 THEN '00' || cast(num2 as string)
                WHEN num2 <1000 THEN '0' || cast(num2 as string)
                ELSE cast(num2 as string)
                END
            ||
            cast(num3a as string)
            ||
            CASE
                /*Pisa--shorter number*/
                WHEN fct1 BETWEEN 41 AND 50 THEN ''
                ELSE CAST(num3b as string)
                END
            ||
            CASE
                /*Pisa--shorter number*/
                WHEN fct1 BETWEEN 41 AND 50 THEN ''
                /*Breakfast Club*/
                WHEN fct1 BETWEEN 1 AND 3 THEN ''
                /*Siberian Express*/
                WHEN fct1 BETWEEN 16 AND 40 THEN ''
                ELSE CAST(num3c as string) 
                END
        FROM
            numpart1, numpart2, numpart3a, numpart3b, numpart3c, factor1, digit2
    )
)
