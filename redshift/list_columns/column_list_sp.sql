CREATE OR REPLACE PROCEDURE column_list_sp(tblName IN CHARACTER VARYING)
AS $$
DECLARE
    col_nm_cursor record;
    col_txt_var varchar(100);

BEGIN
    drop table if exists test_sp_table;
    create table test_sp_table
        (test_col varchar(2500));
    insert into test_sp_table select '';

    FOR col_nm_cursor IN 
                    /*gets column list from the system table*/
                    SELECT
                        cast(column_name as varchar(250)) as column_name
                    from 
                        information_schema.columns 
                    WHERE 
                        table_name = tblName
        LOOP
          /*converts the cursor to a string*/
          col_txt_var = col_nm_cursor;
        
          update test_sp_table
          set test_col = CASE 
                              /*skips the blank column name in the first pass*/
                              WHEN test_col = '' 
                                /*string function removes the leading and trailing parentheses*/
                                THEN substring(col_txt_var, 2, (select len(col_txt_var) - 2)) 
                                /*adds a comma in between the values*/
                                ELSE test_col || ', ' || substring(col_txt_var, 2, (select len(col_txt_var) - 2)) 
                          END;

        END LOOP;

END;
$$ LANGUAGE plpgsql;  
