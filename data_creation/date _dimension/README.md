This spreadsheet can be used to create a DATE dimension in a data warehouse. The formulas can be used to create new data going forwards and backwards.
The first value needs a couple of the formulas replaced with hard-coded value because they require a previous value to exist.
The spreadsheet includes tabs to generate the data in different ways (as a csv to import, INSERT INTO DATE VALUES syntax, and INSERT INTO DATE SELECT syntax).
The columns before and after date should be modified to the date format specifications of the database you're loading into.
