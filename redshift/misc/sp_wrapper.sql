CREATE OR REPLACE PROCEDURE sp_wrapper(procName IN CHARACTER VARYING, procArgTxt IN CHARACTER VARYING, tmpTblName IN CHARACTER VARYING)
--DROP PROCEDURE sp_wrapper(procName CHARACTER VARYING)
AS $$
DECLARE
BEGIN
    EXECUTE
    'CALL ' || procName || '(' || procArgTxt || ');'
    ;
    EXECUTE
    'DROP TABLE IF EXISTS tmp_sp_wrapper_table;'
    ;
    EXECUTE
    'CREATE TABLE tmp_sp_wrapper_table AS  
    SELECT * FROM ' || tmpTblName || ';'
    ;
END;
$$ LANGUAGE plpgsql;  
