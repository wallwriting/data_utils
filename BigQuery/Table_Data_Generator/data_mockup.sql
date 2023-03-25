CREATE OR REPLACE PROCEDURE test.sp_datamockup(varLoadPrj STRING, varLoadDs STRING, varLoadTbl STRING, varKeyCol STRING, varLowKeyVal INT64, varHighKeyVal INT64)
BEGIN

DECLARE varCurColName STRING;
DECLARE varMaxColArray STRING;
DECLARE varGroomedColArray STRING;
DECLARE curColTrack INT64;
DECLARE varRangeLimit INT64;
DECLARE varCurColDatatype STRING;
DECLARE varRandomTimestamp STRING;
DECLARE varRandomInt STRING;
DECLARE varRandomString STRING;
DECLARE varRandomDate STRING;
DECLARE varRandomDatetime STRING;
DECLARE varCurFunction STRING;





SET varRandomTimestamp = """test.random_timestamp('2020-01-01 00:00:00', '2023-01-01 00:00:00')""";
SET varRandomInt = """test.random_integer(-1000000000, 1000000000)""";
SET varRandomString = """test.random_string(250)""";
SET varRandomDate = """test.random_date('2020-01-01', '2023-01-01')""";
SET varRandomDatetime = """test.random_datetime('2020-01-01 00:00:00', '2023-01-01 00:00:00')""";



/******************************************************************************/
/*************************Loads data for the key column************************/
/******************************************************************************/

IF (select IFNULL(CAST(max(id) AS STRING), 'DELETENULLFIELD') FROM test.update_test) = 'DELETENULLFIELD' THEN 
    /*Does the initial load of the key column--the number of rows is determined by the arguments passed*/
    EXECUTE IMMEDIATE
    'INSERT INTO ' || varLoadDs || '.' || varLoadTbl
    || ' (' || varKeyCol || ')'
    || 'SELECT sequence_number FROM test.meta_series WHERE sequence_number BETWEEN ' || varLowKeyVal || ' AND ' || varHighKeyVal ||';'
    ;
END IF;
/******************************************************************************/
/************************END SECTION*******************************************/
/******************************************************************************/






/*******************************************************************************/
/*********Gets list of not null columns to exclude from data load***************/
/*******************************************************************************/
    /*Creates a list of columns that are not NULL*/
    EXECUTE IMMEDIATE 
    'CREATE OR REPLACE TEMP TABLE tmp_ifnull_column_list_array AS '
    || ' SELECT '
    || '   REPLACE '
    || '        ( '
    || '            REPLACE'
    || '                ( '
    || '                    REPLACE'
    || '                        ( '
    || """                            (format('%T', array_agg(column_name))) """
    || """                          , '''["''' , 'IFNULL(CAST(MAX(' """
    || '                        ) '
    || """                  , '''"]''', ''') AS STRING), 'F')''' """
    || '                ) '
    || """          , '''", "''', ''') AS STRING), 'F'), IFNULL(CAST(MAX(''' """
    || '        ) AS col_array '
    || ' FROM '
    || '    ( '
    || '        SELECT '
    || '            column_name '
    || '        FROM '
    ||            varLoadPrj || '.' || varLoadDs || '.INFORMATION_SCHEMA.COLUMNS '
    || '       WHERE '
    || """            table_name = '""" || varLoadTbl || """' """
    || """            AND LEFT(data_type, 5) NOT IN('ARRAY', 'STRUC', 'JSON') """
    || '        ORDER BY '
    || '            ordinal_position '
    || '    ) '
    || ' ;'
    ;
    SET varMaxColArray = (SELECT * FROM tmp_ifnull_column_list_array);

    /*Creates a list of column names and removes any that are in the null list from the previous step*/
    EXECUTE IMMEDIATE 
    'CREATE OR REPLACE TEMP TABLE tmp_groomed_column_list_array AS '
    || ' SELECT '
    || '    /*filters out the opening and closing brackets as well as the double quotes from the        '
    || '    array string in order to use it as an explicity column list in the query later on*/          '
    || '    REPLACE                                                                                         '
    || '        (                                                                                           '
    -- || '        REPLACE                                                                                         '
    -- || '            (                                                                                           '
    || '            REPLACE                                                                                     '
    || '                (                                                                                       '
    || '                    REPLACE                                                                             '
    || '                        (                                                                               '
    || '                            REPLACE                                                                     '
    || '                                (                                                                       '
    || """                                    (FORMAT('%T', ARRAY_AGG(col1)))                                 """
    || """                                  , '[', ''                                                         """
    || '                                )                                                                       '
    || """                          , ']', ''                                                                 """
    || '                        )                                                                               '
    -- || """                  , '''"''', ''                                                                     """
    -- || '                )                                                                                       '
    || """            , 'xxxDELETETHISxxx, ', ''                                                              """
    || '            )                                                                                           '
    || """        , 'xxxDELETETHISxxx', ''                                                                    """
    || '        ) AS col_array                                                                                   '
    || ' FROM ' 
    || '    ( '
    || '        SELECT '
    || """            (CASE WHEN col2 = 'F' THEN 'xxxDELETETHISxxx' """
    || '                ELSE col1 ' 
    || '                END) as col1 '
    || '        FROM '
    || '            ( '
    || '                SELECT '
    || '                    ROW_NUMBER() OVER() as key, ' 
    || '                   * '
    || '                FROM '
    || '                UNNEST '
    || '                    (( '
    || '                    SELECT '
    || '                        ARRAY_AGG(column_name) '
    || '                    FROM '
    || '                    ( '
    || '                        SELECT '
    || '                            column_name '
    || '                        FROM '
    ||                            varLoadPrj || '.' || varLoadDs || '.INFORMATION_SCHEMA.COLUMNS '
    || '                       WHERE '
    || """                            table_name = '""" || varLoadTbl || """' """
    || """                            AND LEFT(data_type, 5) NOT IN('ARRAY', 'STRUC', 'JSON') """
    || '                        ORDER BY '
    || '                            ordinal_position '
    || '                    ) '
    || '                    )) col1 '
    || '            ) a '
    || '        JOIN '
    || '            ( '
    || '                SELECT ' 
    || '                    ROW_NUMBER() OVER() as key, ' 
    || '                    * '
    || '                FROM  '
    || '                    UNNEST '
    || '                        (( '
    || '                            SELECT ' 
    || '                                [ '
    ||                                varMaxColArray
    || '                                ] '
    || '                            FROM ' || varLoadPrj || '.' || varLoadDs || '.' || varLoadTbl
    || '                        )) col2 '
    || '        ) b '
    || '        ON a.key = b.key '
    || '    ) '
    || ' ; '
    ;

SET varGroomedColArray = (SELECT CASE WHEN TRIM(IFNULL(col_array, '')) = '' THEN '1 AS no_non_null_columns' ELSE col_array END FROM tmp_groomed_column_list_array);

/****************************************************************************************/
/***********************************END SECTION******************************************/
/****************************************************************************************/




/*creates a temp table that lists all columns for the table*/
CREATE TEMP TABLE tmp_column_tracker (num_id   INT64, column_name   STRING, data_type   STRING);

/*populates temp table with all columns except for the key column*/
EXECUTE IMMEDIATE 
'INSERT INTO tmp_column_tracker '
|| 'SELECT '
||     'row_number() OVER() AS num_id, '
||     'column_name, '
||     'data_type '
|| 'FROM ' 
||     varLoadPrj || '.' || varLoadDs || '.INFORMATION_SCHEMA.COLUMNS ' 
|| 'WHERE '
||     'table_name = ' || """'""" || varLoadTbl || """' """
||     'AND column_name NOT IN( ' || varGroomedColArray || ') '
||     """AND LEFT(data_type, 5) NOT IN('ARRAY', 'STRUC', 'JSON') """
||     'ORDER BY ordinal_position'
||     ';' 
;


SET varRangeLimit = (SELECT COUNT(*) FROM tmp_column_tracker);
SET curColTrack = 1;

/*starts looping through each column name*/
WHILE curColTrack <= varRangeLimit DO

            CREATE OR REPLACE TEMP TABLE tmp_current_column_name (col_name STRING);

            EXECUTE IMMEDIATE
            'INSERT INTO tmp_current_column_name SELECT column_name FROM tmp_column_tracker WHERE num_id = ' || curColTrack || ';' 
            ;

            SET varCurColName = (SELECT col_name FROM tmp_current_column_name);
            SET varCurColDatatype = (SELECT data_type from tmp_column_tracker WHERE num_id = curColTrack);

            IF varCurColDatatype = 'STRING' THEN SET varCurFunction = varRandomString;
                ELSEIF varCurColDatatype = 'TIMESTAMP' THEN SET varCurFunction = varRandomTimestamp;
                ELSEIF varCurColDatatype = 'INT64' THEN SET varCurFunction = varRandomInt;
                ELSEIF varCurColDatatype = 'DATE' THEN SET varCurFunction = varRandomDate;
                ELSEIF varCurColDatatype = 'DATETIME' THEN SET varCurFunction = varRandomDatetime;
            END IF;

            EXECUTE IMMEDIATE
            'UPDATE ' || varLoadDs || '.' || varLoadTbl
            || ' SET ' || varCurColName || ' = ' || varCurFunction
            || ' WHERE 1=1;'
            ;
    
    SET curColTrack = curColTrack + 1;


END WHILE;



END
