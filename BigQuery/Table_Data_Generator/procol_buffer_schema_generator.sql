/*creates a protocol buffer schema from a specified table using INFORMATION_SCHEMA. This can be used to create a Pub/Sub topic*/

DECLARE varMaxColArray STRING;

DECLARE varLoadTbl STRING;
DECLARE varLoadPrj STRING;
DECLARE varLoadDs STRING;



/*******************************************************************************/
/*********Gets list of not null columns to exclude from data load***************/
/*******************************************************************************/

/*protocol buffer*/

    /*Creates a list of columns along with regex line breaks as well as the protocol buffer schema format prefix and suffix*/
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
    || """                          , '''["''' , '''syntax = "proto3"; \nmessage ProtocolBuffer {\n''' """
    || '                        ) '
    || """                  , '''"]''', '''\n}''' """
    || '                ) '
    || """          , '''", "''', ''' \n\t''' """
    || '        ) AS col_array '
    || ' FROM '
    || '    ( '
    || '        SELECT '
    || """            data_type || ' ' || column_name || ' = ' || ordinal_position || ';' AS column_name """
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

select varMaxColArray;

