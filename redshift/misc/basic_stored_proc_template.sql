CREATE OR REPLACE PROCEDURE /*your proc name*/(/*your input variable*/ IN CHARACTER VARYING, /*your inout variable*/ INOUT BIGINT , /*your out variable*/ OUT RECORD)
--DROP PROCEDURE ... use this to have a quick way of dropping a procedure when you need to change the arguments
AS $$
DECLARE
    /*your input variable*/ CHARACTER VARYING;
    /*your inout variable*/ BIGINT;
    /*your out variable*/ RECORD;
    /*text variable*/ CHARACTER VARYING;
BEGIN
    FOR /*your cursor*/ IN 
            /*your script here*/
        LOOP
            /*your loop here*/
        END LOOP;


IF /*condition here*/ THEN /*run this task*/;
    ELSIF /*condition here*/ THEN /*run this task*/;
    ELSEIF /*condition here--reshift can accept either spelling of elsif*/ THEN /*run this task*/;
    ELSE /*run this task*/;
END IF;


SELECT * FROM /*something*/;


/*EXECUTE needs to be used if you are going to use variables to generate dynamic SQL*/
EXECUTE
'DELETE
FROM
	 ' || /*your inout variable*/ || 
' WHERE 
	/*This is for cases where you need text enclosed in quotes*/
	 ' || /*your inoput variable*/ || ' = ' || quote_literal(/*text variable*/) || ';'
;

END;
$$ LANGUAGE plpgsql
SECURITY INVOKER;
