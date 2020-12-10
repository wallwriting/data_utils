CREATE FUNCTION demo.random_gender() AS
((
SELECT
    CASE 
        WHEN g.numbernator BETWEEN 1 AND 50 THEN 'F'
        WHEN g.numbernator BETWEEN 51 AND 99 THEN 'M'
        ELSE 'U'
        END AS customer_gender,
FROM

    (
        SELECT 
            CAST(RAND() * (100 - 1) + 1 AS INT64) AS numbernator
    ) g
))
;
