CREATE OR REPLACE PROCEDURE sp_matched_column_list(srcTbl IN CHARACTER VARYING, tgtTbl IN CHARACTER VARYING, prefixVar IN CHARACTER VARYING)
AS $$
DECLARE
    col_nm_cursor RECORD;
    col_txt_var CHARACTER VARYING;
    dottedPrefixVar CHARACTER VARYING;
BEGIN
    DROP TABLE IF EXISTS tmp_matched_column_0a9joifsg8sji4322aap;
    CREATE TEMP TABLE tmp_matched_column_0a9joifsg8sji4322aap
        (test_col CHARACTER VARYING);

        INSERT INTO tmp_matched_column_0a9joifsg8sji4322aap SELECT '';
    
    
    /*sets up the column prefix if one was passed, ignores it if it wasn't*/
    IF prefixVar = '' THEN dottedPrefixVar = '';
        ELSIF right(prefixVar, 1) = '.' THEN dottedPrefixVar = prefixVar;
        ELSE dottedPrefixVar = prefixVar || '.';
    END IF;


    FOR col_nm_cursor IN 
                    /*gets column list from the system table
                    The join ensures only the matching column
                    names are involved in the upsert*/
                    SELECT 
                        tgt.column_name
                    FROM
                        (
                            SELECT
                                CAST(column_name AS CHARACTER VARYING) AS column_name,
                                data_type
                            FROM 
                                information_schema.columns 
                            WHERE 
                                table_name = tgtTbl
                            ORDER BY
                                1
                        ) tgt
                    JOIN
                        (
                            SELECT
                                CAST(column_name AS CHARACTER VARYING) AS column_name,
                                data_type
                            FROM 
                                information_schema.columns 
                            WHERE 
                                table_name = srcTbl
                            ORDER BY
                                1
                        ) src
                        ON tgt.column_name = src.column_name
                        AND tgt.data_type = src.data_type
        LOOP
          /*converts the cursor to a string*/
          col_txt_var = col_nm_cursor;
        
          UPDATE tmp_matched_column_0a9joifsg8sji4322aap
          SET test_col = CASE 
                              /*skips the blank column name in the first pass*/
                              WHEN test_col = '' 
                                /*string function removes the leading and trailing parentheses*/
                                THEN dottedPrefixVar || substring(col_txt_var, 2, (SELECT len(col_txt_var) - 2)) 
                                /*adds a comma in between the values*/
                                ELSE test_col || ', ' || dottedPrefixVar || substring(col_txt_var, 2, (SELECT len(col_txt_var) - 2)) 

                          END;
        END LOOP;
END;
$$ LANGUAGE plpgsql;  
