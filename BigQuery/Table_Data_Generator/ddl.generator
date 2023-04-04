/*creates DDL from an existing table*/

DECLARE varMaxColArray STRING;
DECLARE varCreateString STRING;

DECLARE varLoadTbl STRING;
DECLARE varLoadPrj STRING;
DECLARE varLoadDs STRING;


SET varLoadTbl = 'appwv_inventory_detail';
SET varLoadPrj = 'hwangjohn-project';
SET varLoadDs = 'atd';


SET varCreateString = 'CREATE TABLE ' || varLoadTbl || ' AS ';

/*******************************************************************************/
/*********Gets list of not null columns to exclude from data load***************/
/*******************************************************************************/

/*DDL*/

    /*Creates a DDL statement from an existing table*/
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
    || """                          , '''["''' , '' """
    || '                        ) '
    || """                  , '''"]''', '''\n);''' """
    || '                ) '
    || """          , '''", "''', ''' ,\n\t''' """
    || '        ) AS col_array '
    || ' FROM '
    || '    ( '
    || '        SELECT '
    || """            column_name || '        ' || data_type AS column_name """
    || '        FROM '
    ||            varLoadPrj || '.' || varLoadDs || '.INFORMATION_SCHEMA.COLUMNS '
    || '       WHERE '
    || """            table_name = '""" || varLoadTbl || """' """
--    || """            AND LEFT(data_type, 5) NOT IN('ARRAY', 'STRUC', 'JSON') """
    || '        ORDER BY '
    || '            ordinal_position '
    || '    ) '
    || ' ;'
    ;
    SET varMaxColArray = 'CREAT TABLE ' || varLoadTbl || ' AS \n( \n' || (SELECT * FROM tmp_ifnull_column_list_array);

select varMaxColArray;

