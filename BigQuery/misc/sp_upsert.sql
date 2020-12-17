CREATE OR REPLACE PROCEDURE demo.sp_upsert(target_table_var STRING, source_table_var STRING, key_field_var STRING, version_field_var STRING, dml_field_var STRING)
BEGIN

DECLARE
    insert_var STRING;
DECLARE
    update_var STRING;
DECLARE
    col_txt_var STRING;
DECLARE
    col_array_var STRING;
DECLARE
    col_array_prefix_var STRING;
DECLARE
    finish_insert_var STRING;

/*creates two sets of column lists, one with a table prefix and one without, to be used later to 
dynamically generate the column list in the INSERT statement*/

set col_array_var = 
(
    SELECT 
        /*filters out the opening and closing brackets as well as the double quotes from the 
        array string in order touse it as an explicity column list in the query later on*/
        REPLACE
            (
                REPLACE
                    (
                        REPLACE
                            (
                                (format('%T', array_agg(tgt.column_name)))
                                , '[', ''
                            )
                        , ']', ''
                    )
                , '''"''', ''
            )
                    FROM
                        /*Gets the list of target columns from the INFORMATION_SCHEMA metadata table in order to compare it to the source columns*/
                        (
                            SELECT
                                CAST(column_name AS STRING) AS column_name,
                                data_type
                            FROM 
                                demo.INFORMATION_SCHEMA.COLUMNS
                            WHERE 
                                table_name = target_table_var
                            ORDER BY
                                1
                        ) tgt
                    JOIN
                        /*Gets the list of source columns from the INFORMATION_SCHEMA metadata table in order to compare it to the target columns*/
                        (
                            SELECT
                                CAST(column_name AS STRING) AS column_name,
                                data_type
                            FROM 
                                demo.INFORMATION_SCHEMA.COLUMNS
                            WHERE 
                                table_name = source_table_var
                            ORDER BY
                                1
                        ) src
                        ON tgt.column_name = src.column_name
                        /*this will filter out any columns where the names match but the datatypes don't*/
                        AND tgt.data_type = src.data_type
)
;


set col_array_prefix_var = 
(
    SELECT 
        /*filters out the opening and closing brackets as well as the double quotes from the 
        array string in order touse it as an explicity column list in the query later on*/
        REPLACE
            (
                REPLACE
                    (
                        REPLACE
                            (
                                (format('%T', array_agg(CONCAT('src.' || tgt.column_name))))
                                , '[', ''
                            )
                        , ']', ''
                    )
                , '''"''', ''
            )
                    FROM
                        /*Gets the list of target columns from the INFORMATION_SCHEMA metadata table in order to compare it to the source columns*/
                        (
                            SELECT
                                CAST(column_name AS STRING) AS column_name,
                                data_type
                            FROM 
                                demo.INFORMATION_SCHEMA.COLUMNS
                            WHERE 
                                table_name = target_table_var
                            ORDER BY
                                1
                        ) tgt
                    JOIN
                        /*Gets the list of source columns from the INFORMATION_SCHEMA metadata table in order to compare it to the target columns*/
                        (
                            SELECT
                                CAST(column_name AS STRING) AS column_name,
                                data_type
                            FROM 
                                demo.INFORMATION_SCHEMA.COLUMNS
                            WHERE 
                                table_name = source_table_var
                            ORDER BY
                                1
                        ) src
                        ON tgt.column_name = src.column_name
                        /*this will filter out any columns where the names match but the datatypes don't*/
                        AND tgt.data_type = src.data_type
)
;
/*This ends the column list generating section*/



/*hard codes the dml indiciator--this will eventually need to be flexible*/
SET insert_var = """'I'""";
SET update_var = """'U'""";

/*for the end of the insert statement, this will create different lines based on
whether the call passed a real dml indicator or a value of X*/
IF UPPER(dml_field_var) = 'X' THEN SET finish_insert_var = '1=1'; 
    ELSE SET finish_insert_var = 'src.' || dml_field_var || ' IN(' || insert_var || ', ' || update_var || ')';
--    else set finish_insert_var = '1=1';
END IF;



/*This starts the actual delete and insert*/
EXECUTE IMMEDIATE
/*deletes any existing target rows that will change in the batch*/
'DELETE FROM ' 
    || 'demo.' || target_table_var || 
' WHERE ' || key_field_var || ' IN' ||
    /*gets target table_key that have a version number lower than the source*/
'    (' ||
'        SELECT ' ||
'            maxtgt.' || key_field_var ||
'        FROM ' ||
            'demo.' || source_table_var || ' as maxtgt' || 
'    );'
;



EXECUTE IMMEDIATE
    /*inserts source data into target table, only inserting new rows*/
'    INSERT INTO ' || 
        'demo.' || target_table_var ||
'        (' || col_array_var || ') '  ||
'        SELECT '  ||
            /*replace this with whatever you need to insert*/
            col_array_prefix_var || 
'        FROM '  ||
            /*source*/ 
            'demo.' || source_table_var || ' src' ||
'        WHERE ' ||
            /*only inserts inserts and updates*/
            finish_insert_var ||  
    ' AND EXISTS ' ||
'        (' ||
'                SELECT 1 ' ||
'                FROM ' ||
                    /*This finds the max version number for each id*/
'                    (' ||
'                        SELECT ' ||
'                            src.' || key_field_var || ',' || 
'                            MAX(src.' || version_field_var || ') AS max_version_col ' ||
'                        FROM ' ||
                            'demo.' || source_table_var || ' src' || 
'                        GROUP BY ' ||
                            key_field_var ||  
'                    ) mx ' ||
'                  WHERE '  ||
                      'src' || '.' || key_field_var || ' = mx.' || key_field_var ||  
                      /*deletes anything that is not the max version number*/
'                      AND ' || 'src' || '.' || version_field_var || ' != mx.max_version_col' ||
'        );'

;

END;
