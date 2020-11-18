CREATE OR REPLACE FUNCTION demo.date_array(rowArg int64, startArg date, endArg date)
as
(
  (
    (
      WITH argTable AS 
        (
        --  SELECT 100 as rowCount1, DATE '2010-01-01' startDt, DATE '2020-12-31' endDt
        SELECT rowArg as rowCount1, startArg as startDt, endArg as endDt
        )
      SELECT ARRAY
      (
        SELECT
          (format('%T', array_agg(random_date)))
        FROM
        (
          SELECT 
            DATE_FROM_UNIX_DATE(CAST(start_date + (end_date - start_date) * RAND() AS INT64)) random_date
          FROM 
            argTable, 
            UNNEST(GENERATE_ARRAY(1, rowCount1)) id,
            UNNEST([STRUCT(UNIX_DATE(startDt) AS start_date, UNIX_DATE(endDt) AS end_date)])
        )
      )
    )
  )
)
