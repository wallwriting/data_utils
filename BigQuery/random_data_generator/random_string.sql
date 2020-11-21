/*generates a random string based on an sha512 hash with non-alphanumeric characters removed.
The argument is for how long you need the string to be. The function can only generate a string
of approx 580 characters--the exact number differs because of the varying number of non-alphanumeric
characters that have to be removed from the hash*/

CREATE OR REPLACE FUNCTION demo.random_string(lenArg int64) as
(
    (
        SELECT 
            LEFT(col1 || col2 || col3 || col4 || col5 || col6 || col7, lenArg)
        FROM 
            (
            SELECT 
                regexp_replace(TO_BASE64(sha512(CAST(RAND() AS STRING))), '\\W+', '') as col1,
                regexp_replace(TO_BASE64(sha512(CAST(RAND() AS STRING))), '\\W+', '') as col2,
                regexp_replace(TO_BASE64(sha512(CAST(RAND() AS STRING))), '\\W+', '') as col3,
                regexp_replace(TO_BASE64(sha512(CAST(RAND() AS STRING))), '\\W+', '') as col4,
                regexp_replace(TO_BASE64(sha512(CAST(RAND() AS STRING))), '\\W+', '') as col5,
                regexp_replace(TO_BASE64(sha512(CAST(RAND() AS STRING))), '\\W+', '') as col6,
                regexp_replace(TO_BASE64(sha512(CAST(RAND() AS STRING))), '\\W+', '') as col7
            )
    )
)
;

