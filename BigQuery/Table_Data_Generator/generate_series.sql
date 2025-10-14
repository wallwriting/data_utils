
/*Creates a series of sequential numbers into the billions.
This gives the same net effect as unnesting a generate_array() function,
but it lets the user create one at a large scale*/

/*used for the loop later*/
DECLARE cursorVar INT64 DEFAULT 0;

/*the next two numbers are multiplied to create a cross join
to create the initial batch of sequence numbers*/
DECLARE firstCrossVar INT64 DEFAULT 10;
DECLARE secCrossVar INT64 DEFAULT 10;

/*this is the muliplier used at each loop
to increase the number of records*/
DECLARE multVar INT64 DEFAULT 10;


/*This creates a table with the max sequence value--this will reduce the scanning costs
since only the one-record table needs to be queried.*/
CREATE TABLE IF NOT EXISTS test.meta_high_sequence
(high_sequence_number INT64)
AS
SELECT CAST((firstCrossVar * secCrossVar) AS INT64) AS high_sequence_number;


/*creates the main table if it doesn't exist*/
CREATE TABLE IF NOT EXISTS test.meta_series
  (sequence_number INT64)
  PARTITION BY RANGE_BUCKET(sequence_number, GENERATE_ARRAY(100000000, 500000000000, 100000000))
  CLUSTER BY (sequence_number)
  AS
SELECT
      (SELECT IFNULL(MAX(sequence_number), 0) FROM test.meta_series)
      +
      CAST(ROW_NUMBER() OVER() AS INT64)
  FROM
      UNNEST(GENERATE_ARRAY(1, secCrossVar))
  CROSS JOIN
      UNNEST(GENERATE_ARRAY(1,firstCrossVar))
  ;


BEGIN TRANSACTION;
  WHILE cursorVar < 9
    DO
    INSERT INTO test.meta_series
    SELECT
        (SELECT high_sequence_number FROM test.meta_high_sequence)
        +
        CAST(ROW_NUMBER() OVER() AS INT64)
    FROM
      test.meta_series a1
    CROSS JOIN
      UNNEST(GENERATE_ARRAY(1,multVar))
    ORDER BY 1
    ;

    UPDATE
      test.meta_high_sequence
    SET
      high_sequence_number = (SELECT MAX(sequence_number) FROM test.meta_series)
    WHERE 1=1
    ;
    SET cursorVar = cursorVar + 1;
  END WHILE;
COMMIT TRANSACTION;
