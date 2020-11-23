/*creates zip codes. Full rules are not enforced other than the starting number of 00500*/
CREATE OR REPLACE FUNCTION demo.zip_code_generator()
as

(
    (
        SELECT
            CASE
                WHEN num1 <1000 THEN '00' || cast(num1 as string)
                WHEN num1 <10000 THEN '0' || cast(num1 as string)
                ELSE cast(num1 as string)
                END
        FROM
            (
                SELECT
                    CAST(rand() * (99999 - 500) + 500 as int64) as num1
            )

    )
)
