CREATE OR REPLACE PROCEDURE sp_column_list(tblName IN CHARACTER VARYING)
--DROP PROCEDURE column_list_sp(tblName IN CHARACTER VARYING)
AS $$
DECLARE
    col_nm_cursor RECORD;
    col_txt_var CHARACTER VARYING;

BEGIN
    /*Creates the temp table that will hold the column list. Arbitrary table suffix is hard coded
    because parameterizing would require more queries run as EXECUTE commands with quotes*/
    DROP TABLE IF EXISTS test_sp_table_043q97tyw674tgr9hj8uefijqw9dp;
    CREATE TEMP TABLE test_sp_table_043q97tyw674tgr9hj8uefijqw9dp
        (test_col VARCHAR(2500));
    INSERT INTO test_sp_table_043q97tyw674tgr9hj8uefijqw9dp SELECT '';

    FOR col_nm_cursor IN 
                    /*gets column list from the system table*/
                    SELECT
                        CAST(column_name AS VARCHAR(250)) AS column_name
                    FROM
                        information_schema.columns 
                    WHERE 
                        table_name = tblName
                    ORDER BY
                        ordinal_position
        LOOP
          /*converts the cursor to a string*/
          col_txt_var = col_nm_cursor;
        
          UPDATE test_sp_table_043q97tyw674tgr9hj8uefijqw9dp
          SET test_col = CASE 
                              /*skips the blank column name in the first pass*/
                              WHEN test_col = '' 
                                /*string function removes the leading and trailing parentheses*/
                                THEN substring(col_txt_var, 2, (SELECT len(col_txt_var) - 2)) 
                                /*adds a comma in between the values*/
                                ELSE test_col || ', ' || substring(col_txt_var, 2, (SELECT len(col_txt_var) - 2)) 
                          END;

        END LOOP;

END;
$$ LANGUAGE plpgsql;  
