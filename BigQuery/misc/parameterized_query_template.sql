create or replace procedure demo.sp_query_template(tableVar string, excludeVar string)
BEGIN
--declare tableVar string;
--declare excludeVar string;
declare colVar string;

--set tableVar = '''date''';
--set excludeVar = '''Date_Key'''; 


/*sets the colVar variable to a string of column names based on a read of the information schema metaata*/
set colVar = 
(
    SELECT 
            /*filters out the opening and closing brackets as well as the double quotes from the 
            array string in order to use it as an explicit column list in the query later on*/
            REPLACE
                (
                    REPLACE
                        (
                            REPLACE
                                (
                                (format('%T', array_agg(CONCAT('tbl.' || tgt.column_name))))
                                    , '[', ''
                                )
                            , ']', ''
                        )
                    , '''"''', ''
                )
    FROM
        /*Gets the list of columns from the INFORMATION_SCHEMA metadata table*/
        (
            SELECT
                CAST(column_name AS STRING) AS column_name,
                data_type
            FROM 
                test.INFORMATION_SCHEMA.COLUMNS
            WHERE 
                table_name = tableVar
                AND column_name != excludeVar
            ORDER BY
                1
        ) tgt
)
;
/*uses the column names variable to execute a query*/
EXECUTE IMMEDIATE
'        SELECT '  ||
            /*the excluded column*/    
'           MIN(' || excludeVar || ') AS ' || excludeVar || ',' ||             
            /*uses the list of columns*/
            colVar || ' AS col_list' ||
'        FROM '  ||
            'test.' || tableVar || ' tbl' ||
'        GROUP BY ' ||
            colVar ||
'    ;'

;

END
