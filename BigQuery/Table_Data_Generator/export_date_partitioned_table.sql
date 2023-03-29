DECLARE varHighDate Date;
DECLARE varLowDate Date;
DECLARE varCursor INT64;
DECLARE varRangeMax INT64;
DECLARE varCursorDate STRING;
DECLARE varMaxColArray STRING;
DECLARE varMaxColArrayWithDatatype STRING;


DECLARE varProject STRING;
DECLARE varDataset STRING;
DECLARE varSrcTable STRING;
DECLARE varPartitionDate STRING;
DECLARE varTgtTable STRING;
DECLARE varUri STRING;


SET varHighDate = '2023-01-01';
SET varLowDate = '2022-12-26';
SET varCursor = 0;
SET varDataset = 'test_dataset';
SET varSrcTable = 'source_test_table';
SET varPartitionDate = 'creation_date';
SET varTgtTable = 'external_test_table';
SET varUri = 'gs://test_bucket/raw/test_source_system/';

SET varRangeMax = (SELECT DATE_DIFF(varHighDate, varLowDate, DAY));


/*******************************************************************************/
/*****************************Gets list of columns *****************************/
/*******************************************************************************/


    /*Creates a list of columns*/
    EXECUTE IMMEDIATE 
    'CREATE OR REPLACE TEMP TABLE tmp_column_list AS '
    || ' SELECT '
    || '   REPLACE '
    || '        ( '
    || '            REPLACE'
    || '                ( '
    || '                    REPLACE'
    || '                        ( '
    || """                            (format('%T', array_agg(column_name))) """
    || """                          , '''["''' , ''' ''' """
    || '                        ) '
    || """                  , '''"]''', ''' ''' """
    || '                ) '
    || """          , '''", "''', ''', ''' """
    || '        ) AS col_array '
    || ' FROM '
    || '    ( '
    || """        SELECT column_name AS column_name """
    || '        FROM '
    ||            varProject || '.' || varDataset || '.INFORMATION_SCHEMA.COLUMNS '
    || '       WHERE '
    || """            table_name = '""" || varSrcTable || """' """
    || '        ORDER BY '
    || '            ordinal_position '
    || '    ) '
    || ' ;'
    ;
    SET varMaxColArray = (SELECT * FROM tmp_column_list);



    /*Creates a list of columns and datatypes*/
    EXECUTE IMMEDIATE 
    'CREATE OR REPLACE TEMP TABLE tmp_column_datatype_list AS '
    || ' SELECT '
    || '   REPLACE '
    || '        ( '
    || '            REPLACE'
    || '                ( '
    || '                    REPLACE'
    || '                        ( '
    || """                            (format('%T', array_agg(column_name))) """
    || """                          , '''["''' , ''' ''' """
    || '                        ) '
    || """                  , '''"]''', ''' ''' """
    || '                ) '
    || """          , '''", "''', ''', ''' """
    || '        ) AS col_array '
    || ' FROM '
    || '    ( '
    || """        SELECT column_name || ' ' || data_type AS column_name """
    || '        FROM '
    ||            varProject || '.' || varDataset || '.INFORMATION_SCHEMA.COLUMNS '
    || '       WHERE '
    || """            table_name = '""" || varSrcTable || """' """
    || '        ORDER BY '
    || '            ordinal_position '
    || '    ) '
    || ' ;'
    ;
    SET varMaxColArrayWithDatatype = (SELECT * FROM tmp_column_datatype_list);


WHILE varRangeMax > varCursor DO

    SET varCursorDate = (SELECT CAST((varHighDate - varCursor) AS STRING));

    EXECUTE IMMEDIATE
    'EXPORT DATA '
    || '  OPTIONS ( '
    || """    uri = '""" || varUri || varTgtTable || """/dt=""" || varCursorDate || """/*.csv', """
    || """    format = 'CSV', """
    || """    overwrite = true, """
    || """    header = true, """
    || """    field_delimiter = ',') """
    || """AS ( """
    || """  SELECT """ || varMaxColArray
    || """  FROM """ || varDataset || """.""" || varSrcTable 
    || """  WHERE CAST(""" || varPartitionDate || """ AS date) = '""" || varCursorDate || """'"""
    || """ ); """
    ;

    set varCursor = varCursor + 1;
END WHILE;





/*creates the external table in BQ*/
EXECUTE IMMEDIATE
"""CREATE OR REPLACE EXTERNAL TABLE """ || varDataset || """.external_""" || varTgtTable 
|| """(""" || varMaxColArrayWithDatatype || """) """
|| """ WITH PARTITION COLUMNS (dt DATE) """
|| """ OPTIONS (  format = 'CSV', """
||  """ uris = ['""" || varUri || varTgtTable || """/*'] """
|| """ , hive_partition_uri_prefix = '""" || varUri || varTgtTable || """/' """
|| """, field_delimiter = ',' """
|| """, skip_leading_rows=1 """
|| """); """
;
