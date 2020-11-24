/*creates a credit card number, this will create non-valid numbers.
In order to create numbers that more closely follow real credit card rules,
generally for AI/ML purposes, change the first digit: 1 to 3, 7 to 4, 8 to 5, 9 to 6. 
*/

CREATE OR REPLACE FUNCTION demo.credit_card_generator()
as

(
    (
        SELECT
            /*first digit represents the card company*/
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
            /*second digit depends on the type of card from the first digit*/
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
            CASE 
                WHEN num2 <10 THEN '00' || cast(num2 as string)
                WHEN num2 <100 THEN '0' || cast(num2 as string)
                ELSE cast(num3a as string)
                END
            ||
            CASE
                /*the length of the number can be anywhere from 13 = 16 depending on the company
                One company can have either 13, hence the next section, or 16*/
                /*Pisa--shorter number*/
                WHEN fct1 BETWEEN 41 AND 50 THEN ''
                ELSE CAST(num3b as string)
                END
            ||
            CASE
                /*the first three are the only ones that are less than 16 digits*/
                /*Pisa--shorter number*/
                WHEN fct1 BETWEEN 41 AND 50 THEN ''
                /*Breakfast Club*/
                WHEN fct1 BETWEEN 1 AND 3 THEN ''
                /*Siberian Express*/
                WHEN fct1 BETWEEN 16 AND 40 THEN ''
                ELSE CAST(num3c as string) 
                END
        FROM
            /*Dones as a nested query with each rand() function listed as separate columns,
            this is the only way I could find to get the function to reseed the random value
            for each record created in a query that uses the function to generate multiple rows*/
            (
                SELECT
                    CAST(rand() * (9999 - 1) + 1 as int64) as num1,
                    CAST(rand() * (9999 - 1) + 1 as int64) as num2,
                    CAST(rand() * (999 - 1) + 1 as int64) as num3a,
                    CAST(rand() * (9 - 0) + 0 as int64) as num3b,
                    CAST(rand() * (9 - 0) + 0 as int64) as num3c,
                    CAST(rand() * (100 - 1) + 1 as int64) as fct1,
                    /*these are cast to string to make it easier to do the string function in the outside query's case statement*/
                    /*Breakfast Club*/
                    CAST(CAST(rand() * (3 - 1) + 1 as int64) as string) as club,
                    /*Siberian Express*/
                    CAST(CAST(rand() * (2 - 1) + 1 as int64) as string) as exprs,
                    /*Everything else*/
                    CAST(CAST(rand() * (9 - 0) + 0 as int64) as string) as misc
            )

    )
)


