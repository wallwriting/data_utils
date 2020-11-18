/*creates a nonsensical string of characters
limited to 400 max character length*/
CREATE OR REPLACE FUNCTION demo.random_string(lenArg int64)
as
(
    (
                SELECT
                    /*keeps the length at the user-specified parameter*/
                    LEFT
                        /*replaces the brackets, spaces, double quotes from the array string*/
                        (
                        replace
                            (
                            replace
                                (
                                replace
                                        (
                                            format('%T', array_agg(val1)), '''", "''', ''
                                        )
                                , '''["''', ''
                                )
                            , '''"]''', ''
                            )
                        --, format('%T', array_agg(val1))
                        --        (ANY_VALUE(val1) OVER (ORDER BY LENGTH(val1) ROWS BETWEEN 1 PRECEDING AND CURRENT ROW))
                        , lenArg
                        )
                FROM
                (
                    SELECT val1
                    FROM
                    UNNEST(( ['GAR','PRE','ARP','PRO','OLE','ELL','COB','POC','BAR','OOP',
                                'TEI','LIP','MOM','NAN','OTA','POT','QUE','RES','STI','TIB',
                                    'UAB','VIC','WOX','XYE','YER','ZEE', 'APP', 'BOB', 'CRA', 'ERE',
                                        'UBO', 'OLA', 'EPA', 'IPA', 'YRE', 'ABO', 'EPL', 'ILE', 'OAT', 'UBE',
                                            ' ',' ',' ',' ' ])) as val1
                    ORDER BY rand()
                ) return1
    )
)
