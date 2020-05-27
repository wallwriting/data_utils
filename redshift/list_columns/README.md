# column_list_sp.sql

This proc gets a list of all columns from an inputed table, separated by commas.

It is designed to be used to generate dynamic SQL where a list of columns are needed--specifically for the upsert function located here:
https://github.com/wallwriting/redshift_upsert

It is built as a standalone that is called by other procs, though the commands can simply be embedded into a single, longer proc.

Uses a temp table rather than a cursor for performance reasons

Column order matches the ordinality in the table

# matched_column_list.sql

Takes two tables and returns only columns that match in name and datatype (order does not have to match)

Requires three arguments: target table, source table, and the prefix. The prefix is for cases where you need to generate dynamic SQL as part of a select query. If you want the list with no prefix, pass ''.

You can pass the same table name for source and target in cases where you want a column list from one table that has the alias prefix (the single-table column list proc can't generate the alias prefixes)
