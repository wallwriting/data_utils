DECLARE varHighDate Date;
DECLARE varLowDate Date;
DECLARE varCursor INT64;
DECLARE varRangeMax INT64;
DECLARE varCursorDate STRING;


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
SET varUri = 'gs://test_buck/raw/test_source_system/';

SET varRangeMax = (SELECT DATE_DIFF(varHighDate, varLowDate, DAY));

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
    || """  SELECT * """
    || """  FROM """ || varDataset || """.""" || varSrcTable 
    || """  WHERE CAST(""" || varPartitionDate || """ AS date) = '""" || varCursorDate || """'"""
    || """ ); """
    ;

    set varCursor = varCursor + 1;
END WHILE;
