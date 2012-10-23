-- Copyright (c) 2011-2012 Think Big Analytics.

-- UDFs, UDAFs, and UDTFs, and their use.

use ${DB};

-- You can see what functions are defined (including your own, as we'll see
-- below) and get a description about a particular function.

SHOW FUNCTIONS;
DESCRIBE FUNCTION year;
DESCRIBE FUNCTION EXTENDED year;

-- The term UDFs (User Defined Functions) is also used specifically for
-- functions that take a row at a time (or specific columns...) and 
-- return a new row (or value). That is, these UDFs are one-to-one
-- mappings.

-- The following 'dividends' query uses the year() and month() UDFs
-- to extract the year and month from a stock data point and the
-- lower() UDF to convert the symbol to lower case.

SELECT ymd, year(ymd), month(ymd), day(ymd), lower(symbol) FROM dividends LIMIT 20;

-- UDAFs (User Defined Aggregate Functions) take multiple rows and
-- return an "aggregate" of them as a new row. UDAFs are many-to-one mappings.
-- The following 'dividends' query uses the avg() and count() UDAFs
-- to average and sum the dividends payed by Apple.

SELECT avg(dividend), count(dividend) FROM dividends WHERE symbol = 'AAPL';

-- UDTFs (User Defined Table-Generating Functions) take a single row 
-- of data and return multiple new rows, effectively generating a new 
-- table. UDTFs are one-to-many mappings.
-- The following 'employees' query uses the explode() UDTF to expand
-- the `ubordinates ARRAY in the rows. Note that explode() requires 
-- the data to be in an ARRAY. Also, an "AS new_col" is required, 
-- even if it is not subsequently used.

SELECT explode(subordinates) AS subs FROM employees;

-- We have to use a LATERAL VIEW if we want to project other fields. 
-- Here is each manager and his or her subordinates, one at a time.

SELECT name, sub
FROM employees
LATERAL VIEW explode(subordinates) subView AS sub;

SELECT name, deduction_name, value
FROM employees
LATERAL VIEW explode(deductions) dView AS deduction_name, value;

SELECT name, sub, deduction_name, value
FROM employees
LATERAL VIEW explode(subordinates) subView AS sub
LATERAL VIEW explode(deductions) dView AS deduction_name, value;

