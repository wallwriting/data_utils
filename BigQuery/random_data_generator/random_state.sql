CREATE FUNCTION demo.random_state() AS
((
SELECT 
    CASE 
        WHEN statenator = 1 THEN 'AL'
        WHEN statenator = 2 THEN 'AK'
        WHEN statenator = 3 THEN 'AS'
        WHEN statenator = 4 THEN 'AZ'
        WHEN statenator = 5 THEN 'AR'
        WHEN statenator = 6 THEN 'CA'
        WHEN statenator = 7 THEN 'CO'
        WHEN statenator = 8 THEN 'CT'
        WHEN statenator = 9 THEN 'DE'
        WHEN statenator = 10 THEN 'DC'
        WHEN statenator = 11 THEN 'FL'
        WHEN statenator = 12 THEN 'GA'
        WHEN statenator = 13 THEN 'GU'
        WHEN statenator = 14 THEN 'HI'
        WHEN statenator = 15 THEN 'ID'
        WHEN statenator = 16 THEN 'IL'
        WHEN statenator = 17 THEN 'IN'
        WHEN statenator = 18 THEN 'IA'
        WHEN statenator = 19 THEN 'KS'
        WHEN statenator = 20 THEN 'KY'
        WHEN statenator = 21 THEN 'LA'
        WHEN statenator = 22 THEN 'ME'
        WHEN statenator = 23 THEN 'MD'
        WHEN statenator = 24 THEN 'MA'
        WHEN statenator = 25 THEN 'MI'
        WHEN statenator = 26 THEN 'MN'
        WHEN statenator = 27 THEN 'MS'
        WHEN statenator = 28 THEN 'MO'
        WHEN statenator = 29 THEN 'MT'
        WHEN statenator = 30 THEN 'NE'
        WHEN statenator = 31 THEN 'NV'
        WHEN statenator = 32 THEN 'NH'
        WHEN statenator = 33 THEN 'NJ'
        WHEN statenator = 34 THEN 'NM'
        WHEN statenator = 35 THEN 'NY'
        WHEN statenator = 36 THEN 'NC'
        WHEN statenator = 37 THEN 'ND'
        WHEN statenator = 38 THEN 'MP'
        WHEN statenator = 39 THEN 'OH'
        WHEN statenator = 40 THEN 'OK'
        WHEN statenator = 41 THEN 'OR'
        WHEN statenator = 42 THEN 'PA'
        WHEN statenator = 43 THEN 'PR'
        WHEN statenator = 44 THEN 'RI'
        WHEN statenator = 45 THEN 'SC'
        WHEN statenator = 46 THEN 'SD'
        WHEN statenator = 47 THEN 'TN'
        WHEN statenator = 48 THEN 'TX'
        WHEN statenator = 49 THEN 'UT'
        WHEN statenator = 50 THEN 'VT'
        WHEN statenator = 51 THEN 'VA'
        WHEN statenator = 52 THEN 'VI'
        WHEN statenator = 53 THEN 'WA'
        WHEN statenator = 54 THEN 'WV'
        WHEN statenator = 55 THEN 'WI'
        WHEN statenator = 56 THEN 'WY'
        END
FROM 
            (
                SELECT 
                    CAST(RAND() * (56 - 1) + 1 AS INT64) AS statenator
            )
))        
;