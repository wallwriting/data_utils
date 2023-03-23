CREATE OR REPLACE PROCEDURE test.sp_datamockup(varLoadPrj STRING, varLoadDs STRING, varLoadTbl STRING, varKeyCol STRING, varLowKeyVal INT64, varHighKeyVal INT64)
BEGIN


DECLARE varCurColName STRING;
DECLARE curColTrack INT64;
DECLARE varRangeLimit INT64;
DECLARE varCurColDatatype STRING;
DECLARE varRandomTimestamp STRING;
DECLARE varRandomInt STRING;
DECLARE varRandomString STRING;
DECLARE varCurFunction STRING;


--DECLARE varLoadTbl STRING;
--DECLARE varLoadPrj STRING;
--DECLARE varLoadDs STRING;
--DECLARE varKeyCol STRING;
-- DECLARE varLowKeyVal INT64;
-- DECLARE varHighKeyVal INT64;

-- SET varLoadPrj = 'test-project';
-- SET varLoadDs = 'test_dataset';
-- SET varLoadTbl = 'test_table';
-- SET varKeyCol = 'TRANSACTION_ID';
-- SET varLowKeyVal = 1;
-- SET varHighKeyVal = 408000000;

/*these are hard-coded proc calls for the random data UTFs--change them as desired*/
SET varRandomTimestamp = """test.random_timestamp('2020-01-01 00:00:00', '2023-01-01 00:00:00')""";
SET varRandomInt = """test.random_integer(-1000000000, 1000000000)""";
SET varRandomString = """test.random_string(250)""";


/*Does the initial load of the key column--the number of rows is determined by the arguments passed*/
EXECUTE IMMEDIATE
'INSERT INTO ' || varLoadDs || '.' || varLoadTbl
|| ' (' || varKeyCol || ')'
|| 'SELECT sequence_number FROM test.meta_series WHERE sequence_number BETWEEN ' || varLowKeyVal || ' AND ' || varHighKeyVal ||';'
;


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
||     'AND column_name != ' || """'""" || varKeyCol || """' """
||     'ORDER BY ordinal_position'
||     ';' 
;

/*sets the cursor range values*/
SET varRangeLimit = (SELECT COUNT(*) FROM tmp_column_tracker);
SET curColTrack = 1;


/*starts looping through each column names*/
WHILE curColTrack <= varRangeLimit DO


        CREATE OR REPLACE TEMP TABLE tmp_current_column_name (col_name STRING);

        EXECUTE IMMEDIATE
        'INSERT INTO tmp_current_column_name SELECT column_name FROM tmp_column_tracker WHERE num_id = ' || curColTrack || ';' 
        ;

        SET varCurColName = (SELECT col_name FROM tmp_current_column_name);
        SET varCurColDatatype = (SELECT data_type from tmp_column_tracker WHERE num_id = curColTrack);

        /*determines the datatype and uses the appropriate UDF*/
        IF varCurColDatatype = 'STRING' THEN SET varCurFunction = varRandomString;
            ELSEIF varCurColDatatype = 'TIMESTAMP' THEN SET varCurFunction = varRandomTimestamp;
            ELSEIF varCurColDatatype = 'INT64' THEN SET varCurFunction = varRandomInt;
        END IF;

        /*For the current column updates it with the appropriate UDF*/
        EXECUTE IMMEDIATE
        'UPDATE ' || varLoadDs || '.' || varLoadTbl
        || ' SET ' || varCurColName || ' = ' || varCurFunction
        || ' WHERE 1=1;'
        ;

        SET curColTrack = curColTrack + 1;


END WHILE;


END
