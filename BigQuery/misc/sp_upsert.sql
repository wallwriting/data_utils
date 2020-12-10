/*This handles merge cases where it's possible to get multiple database transactions against the same record in a single batch.
Currently a work in progress as its performance is not great*/

BEGIN

DECLARE
    insert_var STRING;
DECLARE
    update_var STRING;
DECLARE
    col_txt_var STRING;
DECLARE
    colArrayVar STRING;
DECLARE
    colArrayPrefixVar STRING;
DECLARE
    finishInsertVar STRING;

/*creates two sets of column lists, one with a table prefix and one without, to be used later to 
dynamically generate the column list in the INSERT statement*/

set colArrayVar = 
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
                                test.INFORMATION_SCHEMA.COLUMNS
                            WHERE 
                                table_name = target_table
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
                                test.INFORMATION_SCHEMA.COLUMNS
                            WHERE 
                                table_name = source_table
                            ORDER BY
                                1
                        ) src
                        ON tgt.column_name = src.column_name
                        /*this will filter out any columns where the names match but the datatypes don't*/
                        AND tgt.data_type = src.data_type
)
;


set colArrayPrefixVar = 
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
                                test.INFORMATION_SCHEMA.COLUMNS
                            WHERE 
                                table_name = 'tgt_test'
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
                                test.INFORMATION_SCHEMA.COLUMNS
                            WHERE 
                                table_name = 'src_test'
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
IF UPPER(source_dml_indicator) = 'X' THEN SET finishInsertVar = '1=1'; 
    ELSE SET finishInsertVar = 'src.' || source_dml_indicator || ' IN(' || insert_var || ', ' || update_var || ')';
--    else set finishInsertVar = '1=1';
END IF;



/*This starts the actual delete and insert*/
EXECUTE IMMEDIATE
/*deletes any existing target rows that will change in the batch*/
'DELETE FROM ' 
    || 'test.' || target_table || 
' WHERE ' || target_key || ' IN' ||
    /*gets target table_key that have a version number lower than the source*/
'    (' ||
'        SELECT ' ||
'            maxtgt.' || source_key ||
'        FROM ' ||
            'test.' || source_table || ' as maxtgt' || 
'    );'
;


EXECUTE IMMEDIATE
    /*In cases where there are multiple transactions in the incoming batch
    this will delete all but the latest record*/
    'DELETE FROM ' 
        || 'test.' || source_table ||
    ' WHERE EXISTS ' ||
'        (' ||
'                SELECT 1 ' ||
'                FROM ' ||
                    /*This finds the max version number for each id*/
'                    (' ||
'                        SELECT ' ||
'                            src.' || source_key || ',' || 
'                            MAX(src.' || source_version || ') AS max_version_col ' ||
'                        FROM ' ||
                            'test.' || source_table || ' src' || 
'                        GROUP BY ' ||
                            source_key ||  
'                    ) mx ' ||
'                  WHERE '  ||
                      source_table || '.' || source_key || ' = mx.' || source_key ||  
                      /*deletes anything that is not the max version number*/
'                      AND ' || source_table || '.' || source_version || ' != mx.max_version_col' ||
'        );'

;


EXECUTE IMMEDIATE
    /*inserts source data into target table, only inserting new rows*/
'    INSERT INTO ' || 
        'test.' || target_table ||
'        (' || colArrayVar || ') '  ||
'        SELECT '  ||
            /*replace this with whatever you need to insert*/
            colArrayPrefixVar || 
'        FROM '  ||
            /*source*/ 
            'test.' || source_table || ' src' ||
'        WHERE ' ||
            /*only inserts inserts and updates*/
            finishInsertVar ||  
'    ;'

;

END
