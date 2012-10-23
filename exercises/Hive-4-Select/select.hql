-- Copyright (c) 2011-2012 Think Big Analytics.

-- Select statements.

-- NOTE: Make sure you started hive with a definition for DATA and DB:
--   hive -d DATA=/data -d DB=yourdatabase
-- or
--   bin/hive.sh -d DATA=/data -d DB=yourdatabase

use ${DB};

-- Much of this exercise will be familiar, if you know SQL, so do the
-- exercises you find "informative". In particular, you should try the 
-- "floating point gotcha" starting around line 103. Also, make sure
-- you understand how to write queries that select elements of
-- collections. If you know "regular expressions", you'll like the
-- RLIKE clause. Finally, try GROUP BY query for the annual, average 
-- closing price for "AAPL" (Apple); When should you have bought AAPL
-- for your stock portfolio??


-- Recall that we created these two tables previously:
-- We'll use them for experimenting with SELECT.

-- CREATE EXTERNAL TABLE IF NOT EXISTS stocks (
--   ymd             STRING,
--   price_open      FLOAT, 
--   price_high      FLOAT,
--   price_low       FLOAT,
--   price_close     FLOAT,
--   volume          FLOAT,
--   price_adj_close FLOAT
-- )
-- PARTITIONED BY (exchange STRING, symbol STRING)
-- ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

-- CREATE TABLE IF NOT EXISTS employees (
--   name         STRING,
--   salary       FLOAT,
--   subordinates ARRAY<STRING>,
--   deductions   MAP<STRING, FLOAT>,
--   address      STRUCT<street:STRING, city:STRING, state:STRING, zip:INT>
-- )
-- ROW FORMAT DELIMITED
-- FIELDS TERMINATED BY '\001' 
-- COLLECTION ITEMS TERMINATED BY '\002' 
-- MAP KEYS TERMINATED BY '\003'
-- LINES TERMINATED BY '\n'
-- STORED AS TEXTFILE;  

-- First, let's look at 20 days-worth of APPL stock results, 
-- just the open and close prices.

SELECT ymd, price_open, price_close
FROM stocks WHERE symbol = 'AAPL' AND exchange = 'NASDAQ' LIMIT 20;

-- EXERCISE: What looks different in the output when you use "*" 
-- instead of a list of columns in the select clause? Is this query 
-- faster? 

-- The previous query uses a "partition filter" to limit the 
-- directories it scans to only the SINGLE directory for AAPL under
-- NASDAQ.


-- Built-in Functions:
-- Hive has many built-in functions, although they are often called
-- User Defined Functions (UDFs), because we can implement and add
-- our own functions using the same mechanisms that Hive uses! 

-- One kind of UDF is the user defined aggregate function (UDAF), 
-- which aggregates multiple records into a single output. For example,
-- let's count the number of records for AAPL: (6412)

SELECT count(*) FROM stocks 
WHERE symbol = 'AAPL' AND exchange = 'NASDAQ';

-- EXERCISE: Count the number of GE records. Which has more, AAPL or GE?

-- Average the closing price for AAPL: ($51.75)

SELECT avg(price_close) FROM stocks 
WHERE symbol = 'AAPL' AND exchange = 'NASDAQ';

-- DISTINCT
-- You can find distinct things, but what happens in this query?

SELECT DISTINCT symbol FROM stocks;

-- There is a bug in Hive before v0.9; DISTINCT does NOT work on
-- partition columns!


-- How do you query with ARRAY, MAP, and STRUCT elements? 
-- Let's use the employees table to see.

-- Select a value, given a key, from a MAP;
-- You specify the key inside array brackets. 
-- This query also does a floating-point comparison. Is the answer
-- what you expect??

SELECT name, deductions['Federal Taxes'] FROM employees 
WHERE deductions['Federal Taxes'] > 0.2;

-- Now try this variant. Is the answer different and what you expect?

SELECT name, deductions['Federal Taxes'] FROM employees 
WHERE deductions['Federal Taxes'] > cast(0.2 as float);


-- Select elements in an ARRAY:
-- You provide an integer index, starting at ZERO.
-- The query returns one name from the ARRAY. Note that we're asking
-- if "Todd Jones" is the SECOND person who is in the subordinate
-- array of a manager.

SELECT name FROM employees WHERE subordinates[1] = 'Todd Jones';

-- Who is a manager?

SELECT name FROM employees WHERE size(subordinates) > 0;

-- EXERCISE: Who isn't a manager?


-- Select elements in a STRUCT:
-- Use the "dot" notation: "struct.element".
-- Who lives in the 60500 Zip Code?

SELECT name FROM employees WHERE address.zip = 60500;

-- EXERCISE: Write a query that selects all managers with two or more 
-- employees.
-- EXERCISE: Write a query that selects all of the employees who DON'T
-- live in Chicago.
-- EXERCISE: Try doing other FLOAT comparisons. Do they behave as 
-- expected?


-- Hive supports the LIKE operator. 

SELECT name, address FROM employees WHERE address.city LIKE 'C%';

-- Hive also supports matching on Java-style regular expressions using
-- an extension, the RLIKE operator.
-- The expression at the end of this query says to match streets that 
-- contain either "Ontario" or "Chicago". The "|" indicates "or".

SELECT name, address FROM employees  
WHERE address.street RLIKE 'Ontario|Chicago';

-- This variation is effectively the same, but it matches the entire
-- street string. "^" and "$" match the beginning and end, respectively,
-- of a string. The ".*" match zero or more characters of any kind.
-- The parentheses are necessary make it clear that the expression is
-- "^.*(something).*$", where "something" is "Ontario|Chicago".

SELECT name, address FROM employees
WHERE address.street RLIKE '^.*(Ontario|Chicago).*$';


-- EXERCISE: Who lives in a Zip Code greater than 60500?
-- EXERCISE: Who pays 15% Federal Income Tax? (Besides Mitt Romney ;^)
-- EXERCISE: Who lives on a street that is a "Drive" or a "Park"?
 

-- GROUP BY divides the resulting data into groups, based on the 
-- specified criteria. NOTE: the GROUP BY can only refer to fields
-- (or their equivalents) referenced in the SELECT.

SELECT year(ymd), avg(price_close) 
FROM stocks
WHERE symbol = 'AAPL' AND exchange = 'NASDAQ'
GROUP BY year(ymd);

-- EXERCISE: Compute the average for GE.
-- EXERCISE: Compute the average for each month. 


-- GROUP BY ... HAVING is a way of further filtering the output.

SELECT year(ymd), avg(price_close)
FROM stocks 
WHERE symbol = 'AAPL' AND exchange = 'NASDAQ'
GROUP BY year(ymd) 
HAVING avg(price_close) > 50.0 AND avg(price_close) < 100.0;
