/*creates random y/n flag--argument passed must be letter, word, or number depending on how you want the flag returned*/
CREATE OR REPLACE function dpa.random_flag(argType STRING)
AS
(
  (
    SELECT
    CASE 
      -- WHEN lower(argType) = 'word' THEN
      --               (CASE WHEN flg = '0' THEN 'No' ELSE 'Yes' END)
      WHEN lower(argType) = 'letter' THEN
                    (CASE WHEN flg = '0' THEN 'N' ELSE 'Y' END)
      WHEN lower(argType) = 'number' THEN flg 
      ELSE (CASE WHEN flg = '0' THEN 'No' ELSE 'Yes' END)

      END AS flag_value
    FROM
    (
      select 
        CAST(
              cast(rand() * (1 - 0) + 0 as int64)
            AS STRING

        ) as flg
    )
  )
)
