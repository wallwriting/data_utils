# Misc

Odds and ends that aren't easily categorized

Current contents:

### - basic_stored_proc_template.sql:
A template to help you write a stored proc--includes syntax for querying directly, executing a query, if/then statements, and for... loops

### - sp_wrapper.sql:
A proc for specific cases where you created a stored proc to create a temp table (which should be done for performance reasons) and you want to see the results of that temp table after calling the proc without the performance hit of using a cursor. This is a wrapper proc that will call the procedure you specify, then show the contents of the called queries temp table. Three arguments: proc name, argument text (including any quotes and commas), and the temp table created by the proc.

Use this set of commands and run them in batch:
BEGIN;
call sp_wrapper('/*your proc name*/', $$/*your arguments as a single string*/$$ , '/*your temp table in the proc*/');
select * FROM tmp_sp_wrapper_table;
drop table tmp_sp_wrapper_table;
COMMIT:

The second argument should exclude the unerlying proc's parentheses, but should include any single quotes and commas. The beginning and end double dollar signs have to stay in so that the database will treat everything in between as literal. The double dollar signs replace the single quote you would normally use to pass the argument.