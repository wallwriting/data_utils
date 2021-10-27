CREATE OR REPLACE PROCEDURE test.sp_schemachangedetector(varSourceProject STRING, varSourceDataset STRING, varSourceTable STRING, varTargetDataset STRING, 
varTargetTable STRING, varAction STRING, /*varJoinKeyColumn STRING,*/ varSourceExcludeColumns ARRAY<STRING>, varTargetExcludeColumns ARRAY<STRING>)
BEGIN 

    DECLARE varSourceColumnCount INT64;
    DECLARE varTargetColumnCount INT64;
    DECLARE varColumnCountMatchFlag BOOLEAN;
    DECLARE varColumnNameMatchFlag BOOLEAN;
    DECLARE varDatatypeMatchFlag BOOLEAN;
    DECLARE varOrderMatchFlag BOOLEAN;
    DECLARE varSourceTableReadScript STRING;
    DECLARE varTargetTableReadScript STRING;
    DECLARE varSourceUnmatchedColumnsList ARRAY<STRING>;
    DECLARE varTargetUnmatchedColumnsList ARRAY<STRING>;
    DECLARE varSourceUnmatchedDatatypesList ARRAY<STRING>;
    DECLARE varTargetUnmatchedDatatypesList ARRAY<STRING>;
    DECLARE varSourceUnmatchedOrderList ARRAY<STRING>;
    DECLARE varTargetUnmatchedOrderList ARRAY<STRING>;
    DECLARE varBatchTimestampMicros INT64;
    DECLARE varActionSourceDmlStatement STRING;
    DECLARE varActionTargetDmlStatement STRING;
    DECLARE varSourceTempDmlSuffix STRING;
    DECLARE varTargetTempDmlSuffix STRING;
    DECLARE curColumnCounter INT64;
    DECLARE varRangeTotal INT64;
    DECLARE varAlterTableScript STRING;
    DECLARE varCurrentColumnName STRING;
    DECLARE varCurrentColumnDatatype STRING;
    DECLARE varColumnNameSuffix STRING;
    DECLARE varAppendInsertQuery STRING;

    DECLARE varAppendSourceListString STRING;
    DECLARE varAppendTargetListString STRING;




    DECLARE varTargetTempDmlSuffix2 STRING;
    DECLARE curColumnCounter2 INT64;
    DECLARE varRangeTotal2 INT64;
    DECLARE varAlterTableScript2 STRING;
    DECLARE varCurrentColumnName2 STRING;
    DECLARE varCurrentColumnDatatype2 STRING;
    DECLARE varColumnNameSuffix2 STRING;

    /*sets the current timestamp to integer due to its use in a table name later*/
    SET varBatchTimestampMicros = UNIX_MICROS(current_timestamp());

    /*********************************************************/
    /**************BEGIN EXCLUDED COLUMNS LIST****************/
    /*********************************************************/
    /*Creates the last line of the dml statement based on the excluded source table columns passed in the parameter*/
    IF 
        ARRAY_LENGTH(varSourceExcludeColumns) != 0 THEN SET varSourceTempDmlSuffix = 
                                                                """AND column_name NOT IN(""" || 
                                                                REPLACE
                                                                    (
                                                                        REPLACE
                                                                            (
                                                                                    (FORMAT('%T', varSourceExcludeColumns))
                                                                                    , '[', ''
                                                                            )
                                                                            , ']', '' 
                                                                    )
                                                                || """)"""
                                                                ;
        ELSE SET varSourceTempDmlSuffix = '';
    END IF;

    /*Creates the last line of the dml statement based on the excluded target columns passed in the parameter*/
    IF 
        ARRAY_LENGTH(varTargetExcludeColumns) != 0 THEN SET varTargetTempDmlSuffix = 
                                                                """AND column_name NOT IN(""" || 
                                                                REPLACE
                                                                    (
                                                                        REPLACE
                                                                            (
                                                                                    (FORMAT('%T', varTargetExcludeColumns))
                                                                                    , '[', ''
                                                                            )
                                                                            , ']', '' 
                                                                    )
                                                                || """)"""
                                                                ;
        ELSE SET varTargetTempDmlSuffix = '';
    END IF;
    /*********************************************************/
    /****************END EXCLUDED COLUMNS LIST****************/
    /*********************************************************/



    /*********************************************************/
    /**************BEGIN TEMP TABLE COLUMN INFO***************/
    /*********************************************************/
    /*creates temp tables to get info about the source and target tables*/
    SET varSourceTableReadScript =
                                    """CREATE OR REPLACE TEMP TABLE tmp_source_table_info AS """
                                    || """SELECT """
                                        || """table_catalog, """
                                        || """table_schema, """
                                        || """table_name, """
                                        || """column_name, """
                                        || """ordinal_position, """
                                        || """data_type, """
                                        || """is_partitioning_column, """
                                        || """clustering_ordinal_position """
                                    || """FROM """ 
                                        || varSourceDataset || """.INFORMATION_SCHEMA.COLUMNS """
                                    || """WHERE """ 
                                        || """table_name = '""" || varSourceTable || """' """
                                        # || """AND is_partitioning_column = 'NO' """
                                        # || """AND clustering_ordinal_position IS NULL """ 
                                        /*This is the list of columns to exclude from the comparison*/
                                        || varSourceTempDmlSuffix
                                        || """;"""
    ;

    SET varTargetTableReadScript = 
                                    """CREATE OR REPLACE TEMP TABLE tmp_target_table_info AS """
                                    || """SELECT """
                                        || """table_catalog, """
                                        || """table_schema, """
                                        || """table_name, """
                                        || """column_name, """
                                        || """ordinal_position, """
                                        || """data_type, """
                                        || """is_partitioning_column, """
                                        || """clustering_ordinal_position """
                                    || """FROM """ 
                                        || varTargetDataset || """.INFORMATION_SCHEMA.COLUMNS """
                                    || """WHERE """ 
                                        || """table_name = '""" || varTargetTable || """' """
                                        # || """AND is_partitioning_column = 'NO' """
                                        # || """AND clustering_ordinal_position IS NULL """ 
                                        /*This is the list of columns to exclude from the comparison*/
                                        || varTargetTempDmlSuffix
                                        || """;"""
    ;

    /*then executes the sql*/
    EXECUTE IMMEDIATE 
    varSourceTableReadScript
    ;
    EXECUTE IMMEDIATE 
    varTargetTableReadScript
    ;
    /*********************************************************/
    /****************END TEMP TABLE COLUMN INFO***************/
    /*********************************************************/


    /*DELETE THIS EVENTUALLY*/
    /*This creates a table that has the same structure as the existing table to get the list of column names--
    This is necessary due to a current issue with BQ where it will not update the informations schema when
    a table has a dropped column.*/

    EXECUTE IMMEDIATE
    """CREATE TABLE """ || varTargetDataset || """.""" || varSourceTable || "_" || CAST(varBatchTimestampMicros AS STRING) || """ AS """
    || """SELECT * FROM """ || varSourceProject || """.""" || varSourceDataset || """.""" || varSourceTable || """ WHERE 1=2;"""
    ; 
    EXECUTE IMMEDIATE
    """CREATE TABLE """ || varTargetDataset || """.""" || varTargetTable || "_" || CAST(varBatchTimestampMicros AS STRING) || """ AS """
    || """SELECT * FROM """ || varTargetDataset || """.""" || varTargetTable || """ WHERE 1=2;"""
    ; 

    EXECUTE IMMEDIATE
    """DELETE FROM tmp_source_table_info WHERE NOT EXISTS (SELECT 1 FROM """ || varTargetDataset || """.INFORMATION_SCHEMA.COLUMNS b WHERE b.table_name = '""" || 
        varSourceTable || """_""" ||  CAST(varBatchTimestampMicros AS STRING) || """' AND tmp_source_table_info.column_name = b.column_name);"""
    ;
    EXECUTE IMMEDIATE
    """DELETE FROM tmp_target_table_info WHERE NOT EXISTS (SELECT 1 FROM """ || varTargetDataset || """.INFORMATION_SCHEMA.COLUMNS b WHERE b.table_name = '""" || 
        varTargetTable || """_""" ||  CAST(varBatchTimestampMicros AS STRING) || """' AND tmp_target_table_info.column_name = b.column_name);"""
    ;

    EXECUTE IMMEDIATE
    """DROP TABLE """ || varTargetDataset || """.""" || varSourceTable || "_" || CAST(varBatchTimestampMicros AS STRING) || """;"""
    ;
    EXECUTE IMMEDIATE
    """DROP TABLE """ || varTargetDataset || """.""" || varTargetTable || "_" || CAST(varBatchTimestampMicros AS STRING) || """;"""
    ;
    /*END OF DELETE SECTION*/

    /*********************************************************/
    /**************BEGIN COLUMN COUNT CHECK*******************/
    /*********************************************************/
    /*gets a count of columns in both the source and target*/
    # SET varSourceColumnCount =
    #     (
    #     SELECT
    #         count(1)
    #     FROM 
    #         tmp_source_table_info
    #     )
    # ;
    # SET varTargetColumnCount = 
    #     (
    #     SELECT
    #         count(1)
    #     FROM 
    #         tmp_target_table_info
    #     )
    # ;

    # /*sets a flag whether the column counts match or not*/
    # IF 
    #     varSourceColumnCount = varTargetColumnCount THEN SET varColumnCountMatchFlag = TRUE;
    #     ELSE SET varColumnCountMatchFlag = FALSE;
    # END IF
    # ;
    /*********************************************************/
    /****************END COLUMN COUNT CHECK*******************/
    /*********************************************************/




    /*********************************************************/
    /**************BEGIN MISMATCH COLUMN NAMES****************/
    /*********************************************************/
    /*Creates an array of the columns on the source table that don't exist in the target*/
    SET varSourceUnmatchedColumnsList =
                                        (
                                        SELECT
                                            ARRAY_AGG(column_name)
                                        FROM 
                                            (
                                            SELECT
                                                src.column_name
                                            FROM
                                                tmp_source_table_info src
                                            LEFT JOIN
                                                tmp_target_table_info tgt
                                                ON src.column_name = tgt.column_name
                                            WHERE
                                                tgt.column_name IS NULL
                                            )
                                        )
    ;

    /*Creates an array of the columns on the target table that don't exist in the source*/
    SET varTargetUnmatchedColumnsList =
                                        (
                                        SELECT
                                            ARRAY_AGG(column_name)
                                        FROM 
                                            (
                                            SELECT
                                                tgt.column_name
                                            FROM
                                                tmp_target_table_info tgt
                                            LEFT JOIN
                                                tmp_source_table_info src
                                                ON tgt.column_name = src.column_name
                                                AND tgt.is_partitioning_column = 'NO'
                                                AND tgt.clustering_ordinal_position IS NULL
                                            WHERE
                                                src.column_name IS NULL
                                            )
                                        )
    ;

    /*Determines if there are unmatched column names on either the target or source*/
    IF 
        ARRAY_LENGTH(varTargetUnmatchedColumnsList) = 0 AND ARRAY_LENGTH(varSourceUnmatchedColumnsList) = 0 THEN SET varColumnNameMatchFlag = TRUE;
        ELSE SET varColumnNameMatchFlag = FALSE;
    END IF;
    /*********************************************************/
    /****************END MISMATCH COLUMN NAMES****************/
    /*********************************************************/



    /*********************************************************/
    /****************BEGIN MISMATCH DATATYPE******************/
    /*********************************************************/
    /*Creates list of source columns that have a matching name but mismatched datatype*/
    SET varSourceUnmatchedDatatypesList =
                                        (
                                        SELECT
                                            ARRAY_AGG(column_name)
                                        FROM 
                                            (
                                            SELECT
                                                src.column_name,
                                                src.data_type
                                            FROM
                                                tmp_source_table_info src
                                            JOIN
                                                tmp_target_table_info tgt
                                                ON src.column_name = tgt.column_name
                                                AND src.data_type != tgt.data_type
                                                # AND tgt.is_partitioning_column = 'NO'
                                                # AND tgt.clustering_ordinal_position IS NULL
                                            )
                                        )
    ;

    /*Creates list of target columns that have a matching name but mismatched datatype*/
    SET varTargetUnmatchedDatatypesList =
                                        (
                                        SELECT
                                            ARRAY_AGG(column_name)
                                        FROM 
                                            (
                                            SELECT
                                                tgt.column_name,
                                                tgt.data_type
                                            FROM
                                                tmp_target_table_info tgt
                                            JOIN
                                                tmp_source_table_info src
                                                ON tgt.column_name = src.column_name
                                                AND tgt.data_type != src.data_type
                                                # AND tgt.is_partitioning_column = 'NO'
                                                # AND tgt.clustering_ordinal_position IS NULL
                                            )
                                        )
    ;


    /*sets a flag to determine if there are mismatched datatypes on either source or target*/
    IF 
        ARRAY_LENGTH(varTargetUnmatchedDatatypesList) = 0 AND ARRAY_LENGTH(varSourceUnmatchedDatatypesList) = 0 THEN SET varDatatypeMatchFlag = TRUE;
        ELSE SET varDatatypeMatchFlag = FALSE;
    END IF;
    /*********************************************************/
    /******************END MISMATCH DATATYPE******************/
    /*********************************************************/


    /*********************************************************/
    /************BEGIN MISMATCH ORDINAL POSITION**************/
    /*********************************************************/
    /*Creates list of source columns that match name/datatype but have mismatched ordinal positions*/
    # SET varSourceUnmatchedOrderList =
    #                                     (
    #                                     SELECT
    #                                         ARRAY_AGG(column_name || ' ' || data_type)
    #                                     FROM 
    #                                         (
    #                                         SELECT
    #                                             src.column_name,
    #                                             src.data_type
    #                                         FROM
    #                                             tmp_source_table_info src
    #                                         JOIN
    #                                             tmp_target_table_info tgt
    #                                             ON src.column_name = tgt.column_name
    #                                             AND src.ordinal_position != tgt.ordinal_position
    #                                         )
    #                                     )
    # ;

    # /*Creates list of target columns that match name/datatype but have mismatched ordinal positions*/
    # SET varTargetUnmatchedOrderList =
    #                                     (
    #                                     SELECT
    #                                         ARRAY_AGG(column_name || ' ' || data_type)
    #                                     FROM 
    #                                         (
    #                                         SELECT
    #                                             tgt.column_name,
    #                                             tgt.data_type
    #                                         FROM
    #                                             tmp_target_table_info tgt
    #                                         JOIN
    #                                             tmp_source_table_info src
    #                                             ON tgt.column_name = src.column_name
    #                                             AND tgt.ordinal_position != src.ordinal_position
    #                                         )
    #                                     )
    # ;


    # /*sets flag to see if there are any mismatched ordinal positions*/
    # IF 
    #     ARRAY_LENGTH(varTargetUnmatchedOrderList) = 0 AND ARRAY_LENGTH(varSourceUnmatchedOrderList) = 0 THEN SET varOrderMatchFlag = TRUE;
    #     ELSE SET varOrderMatchFlag = FALSE;
    # END IF;
    /*********************************************************/
    /************BEGIN MISMATCH ORDINAL POSITION**************/
    /*********************************************************/


    /*********************************************************/
    /********BEGIN APPEND AND OVERWRITE COLUMN LIST***********/
    /*********************************************************/
    /*generates the list of columns that will be used later in cases of append or overwrite--
    for create, this will simply create the dml statement to create the new table*/
    IF 
    UPPER(varAction) = 'APPEND' THEN
                                    CREATE OR REPLACE TEMP TABLE tmp_source_unmatched_datatype_string_conversion AS
                                    SELECT varSourceUnmatchedDatatypesList as data_type_array;
                                    CREATE OR REPLACE TEMP TABLE tmp_source_unmatched_column_string_conversion AS
                                    SELECT varSourceUnmatchedColumnsList as column_name_array;
                                    CREATE OR REPLACE TEMP TABLE tmp_source_mismatched_column_list AS
                                        SELECT 
                                            ROW_NUMBER() OVER() AS row_id,
                                            column_name
                                        FROM
                                            (
                                                SELECT column_name FROM tmp_source_unmatched_datatype_string_conversion, UNNEST(data_type_array) column_name
                                                UNION DISTINCT
                                                SELECT column_name FROM tmp_source_unmatched_column_string_conversion, UNNEST(column_name_array) column_name
                                            )
                                        ;
        /*for overwrites, only creates the tables for the target--the table for the mismatched source fields will be created later--
        we don't bother including the ones for datatype mismatches because those will show up when handling the source side*/
        # ELSEIF UPPER(varAction) = 'OVERWRITE' THEN 
        #                             CREATE OR REPLACE TEMP TABLE tmp_source_unmatched_datatype_string_conversion AS
        #                             SELECT varSourceUnmatchedDatatypesList as data_type_array;
        #                             CREATE OR REPLACE TEMP TABLE tmp_source_unmatched_column_string_conversion AS
        #                             SELECT varSourceUnmatchedColumnsList as column_name_array;
        #                             CREATE OR REPLACE TEMP TABLE tmp_source_mismatched_column_list AS
        #                                 SELECT 
        #                                     ROW_NUMBER() OVER() AS row_id,
        #                                     column_name
        #                                 FROM
        #                                     (
        #                                         SELECT column_name FROM tmp_source_unmatched_datatype_string_conversion, UNNEST(data_type_array) column_name
        #                                         UNION DISTINCT
        #                                         SELECT column_name FROM tmp_source_unmatched_column_string_conversion, UNNEST(column_name_array) column_name
        #                                     )
        #                                 ;
        #                             CREATE OR REPLACE TEMP TABLE tmp_target_unmatched_datatype_string_conversion AS
        #                             SELECT varTargetUnmatchedDatatypesList as data_type_array;
        #                             CREATE OR REPLACE TEMP TABLE tmp_target_unmatched_column_string_conversion AS
        #                             SELECT varTargetUnmatchedColumnsList as column_name_array;
        #                             CREATE OR REPLACE TEMP TABLE tmp_target_mismatched_column_list AS
        #                                 SELECT 
        #                                     ROW_NUMBER() OVER() AS row_id,
        #                                     column_name
        #                                 FROM
        #                                     (
        #                                         SELECT column_name FROM tmp_target_unmatched_column_string_conversion, UNNEST(column_name_array) column_name
        #                                         UNION DISTINCT
        #                                         SELECT column_name FROM tmp_target_unmatched_datatype_string_conversion, UNNEST(data_type_array) column_name
        #                                     )
        #                                 ;

        ELSEIF UPPER(varAction) = 'CREATE' THEN
                                EXECUTE IMMEDIATE
                                """CREATE OR REPLACE TABLE """ || varTargetDataset || """.ELT_SCHEMACHECKER_""" || varTargetTable || """_""" || CAST(varBatchTimestampMicros AS STRING) || """ AS """
                                || """SELECT * FROM """ || varSourceProject || """.""" || varSourceDataset || """.""" || varSourceTable
                                || """; """
                            ;
    END IF;
    /*********************************************************/
    /**********END APPEND AND OVERWRITE COLUMN LIST***********/
    /*********************************************************/



    /*********************************************************/
    /**********BEGIN DROP OVERWRITE COLUMN ACTION*************/
    /*********************************************************/
    /*If it's an overwrite, it will delete from the target everything that is mismatched on the source*/
    # IF UPPER(varAction) = 'OVERWRITE' THEN
    #     /*sets up to drop any column that exists in the target but is mismatched to source*/
    #     SET curColumnCounter = 1;
    #     SET varRangeTotal = (SELECT COUNT(1) FROM tmp_target_mismatched_column_list);
    #     WHILE curColumnCounter <= varRangeTotal DO
    #         /*sets the current column name*/
    #         SET varCurrentColumnName = (SELECT column_name FROM tmp_target_mismatched_column_list WHERE row_id = curColumnCounter);
    #         /*creates the script to drop the column*/
    #         SET varAlterTableScript = """ALTER TABLE """ || varTargetDataset || """.""" || varTargetTable || """ DROP COLUMN """ || varCurrentColumnName || """;""" ;
    #         /*execuites alter table to drop column*/
    #         EXECUTE IMMEDIATE 
    #         varAlterTableScript;
    #         SET curColumnCounter = curColumnCounter + 1;
    #     END WHILE;
    # END IF
    # ;
    /*********************************************************/
    /************END DROP OVERWRITE COLUMN ACTION*************/
    /*********************************************************/


    /*********************************************************/
    /**************BEGIN APPEND COLUMN SUFFIX*****************/
    /*********************************************************/
    /*sets a column name suffix for append actions in order to avoid duplicate names--
    no suffix value if it's an overwrite*/
    IF 
        UPPER(varAction) = 'APPEND' THEN SET varColumnNameSuffix2 = '_' || CAST(varBatchTimestampMicros AS STRING);
        ELSE SET varColumnNameSuffix2 = '';
    END IF;
    /*********************************************************/
    /****************END APPEND COLUMN SUFFIX*****************/
    /*********************************************************/


/*********************************************************/
/*************BEGIN APPEND COLUMN LIST STRING*************/
/*********************************************************/
CREATE OR REPLACE TEMP TABLE tmp_append_column_list AS
    SELECT
        ROW_NUMBER() OVER() AS row_id,
        REPLACE
            (
                REPLACE
                    (
                        REPLACE
                            (
                                    (FORMAT('%T', ARRAY_AGG(source_column_name)))
                                    , '[', ''
                            )
                            , ']', '' 
                    )
                    , '''"''', '' 
            )
        AS source_column_string
        ,
        REPLACE
            (
                REPLACE
                    (
                        REPLACE
                            (
                                    (FORMAT('%T', ARRAY_AGG(target_column_name)))
                                    , '[', ''
                            )
                            , ']', '' 
                    )
                    , '''"''', ''
            )
        AS target_column_string
    FROM
        (
            SELECT
                src.column_name AS source_column_name,
                src.column_name || CASE WHEN tgt.column_name IS NULL THEN varColumnNameSuffix2 ELSE '' END AS target_column_name
            FROM
                tmp_source_table_info src
            LEFT JOIN
                tmp_target_table_info tgt
                ON src.column_name = tgt.column_name
                AND src.data_type = tgt.data_type
            UNION DISTINCT
            SELECT
                src.column_name AS source_column_name,
                # src.column_name  || CASE WHEN tgt.column_name IS NOT NULL THEN varColumnNameSuffix2 ELSE '' END
                src.column_name  || varColumnNameSuffix2
            FROM
                tmp_source_table_info src
            JOIN
                tmp_target_table_info tgt
                ON src.column_name = tgt.column_name
                AND src.data_type != tgt.data_type
        )
;
SET varAppendSourceListString = (SELECT source_column_string FROM tmp_append_column_list);
SET varAppendTargetListString = (SELECT target_column_string FROM tmp_append_column_list);
/*********************************************************/
/***************END APPEND COLUMN LIST STRING*************/
/*********************************************************/



    /*********************************************************/
    /***************BEGIN ADD COLUMN ACTION*******************/
    /*********************************************************/
    /*adds new columns*/
    IF UPPER(varAction) != 'CREATE' THEN
        SET curColumnCounter2 = 1;
        SET varRangeTotal2 = (SELECT COUNT(1) FROM tmp_source_mismatched_column_list);
        WHILE curColumnCounter2 <= varRangeTotal2 DO
            /*sets the current column name*/
            SET varCurrentColumnName2 = (SELECT column_name FROM tmp_source_mismatched_column_list WHERE row_id = curColumnCounter2);
            /*creates the script to add new column*/
            SET varCurrentColumnDatatype2 = (SELECT data_type FROM tmp_source_table_info t WHERE t.column_name = varCurrentColumnName2);
            SET varAlterTableScript2 = """ALTER TABLE """ || varTargetDataset || """.""" || varTargetTable || """ ADD COLUMN """ || varCurrentColumnName2 || varColumnNameSuffix2 
                                        || """ """ || varCurrentColumnDatatype2 || """;""" ;
            /*execuites alter table to add new column*/
            EXECUTE IMMEDIATE 
            varAlterTableScript2;

            SET curColumnCounter2 = curColumnCounter2 + 1;
        END WHILE;
    END IF;
    /*********************************************************/
    /*****************END ADD COLUMN ACTION*******************/
    /*********************************************************/

SET varAppendInsertQuery = 
"""INSERT INTO """ || varTargetDataset || """.""" || varTargetTable || """ (""" || varAppendTargetListString || """) """
|| """SELECT """
||    varAppendSourceListString || """ """
|| """FROM """ 
||    varSourceProject || """.""" || varSourceDataset || """.""" || varSourceTable
|| """;"""
;

EXECUTE IMMEDIATE 
varAppendInsertQuery;



END;
