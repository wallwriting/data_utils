This proc gets a list of all columns from an inputed table, separated by commas.

It is designed to be used to generate dynamic SQL where a list of columns are needed--specifically for the upsert function located here:
https://github.com/wallwriting/redshift_upsert

It is built as a standalone that is called by other procs, though the commands can simply be embedded into a single, longer proc.

Currently, mostly for testing purposes, it creates a staging table with a single record that lists the columns.

It only drops the staging table at the beginning of proc, so you will need to delete the table yourself or have your calling proc do so.

It can be modified to simply return the list as a cursor or output parameter.
