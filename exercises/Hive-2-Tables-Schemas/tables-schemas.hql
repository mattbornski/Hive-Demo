-- Copyright (c) 2011-2012 Think Big Analytics.

-- Tables and Schemas

-- NOTE: Make sure you started hive with a definition for DATA:
--   hive -d DATA=/data -d DB=yourdatabase
-- or
--   bin/hive.sh -d DATA=/data -d DB=yourdatabase

use ${DB};

-- The Employees table that has simple fields, like name and salary,
-- but also complex fields, including an array of subordinates' names,
-- A map of names of deductions and the percentage amount to be 
-- deducted at each pay period, and a struct containing the employee's
-- address. 
-- Note that for the complex data types, Java-style generic type 
-- arguments are used.
-- Next, if you know the table doesn't already exist, you can drop
-- the clause IF NOT EXISTS.
-- Finally, everything starting at "ROW FORMAT DELIMITED..." is OPTIONAL;
-- it's just regurgitating the default settings!

CREATE TABLE IF NOT EXISTS employees (
  name         STRING,
  salary       FLOAT,
  subordinates ARRAY<STRING>,
  deductions   MAP<STRING, FLOAT>,
  address      STRUCT<street:STRING, city:STRING, state:STRING, zip:INT>
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\001' 
COLLECTION ITEMS TERMINATED BY '\002' 
MAP KEYS TERMINATED BY '\003'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE;

SHOW TABLES;

-- Now let's load data into this table, from a LOCAL directory.
-- (We could load from HDFS directories, but there are complications we're 
-- going to avoid...)

-- First, confirm the directory exists and contains at least one file:

! ls /home/hadoop/data/employees/input;

-- Now load the data!

LOAD DATA LOCAL INPATH '/home/hadoop/data/employees/input/' 
INTO TABLE employees;


-- How fast is the following query?
-- Notice how the complex data values are formatted in the output.

SELECT * FROM employees;

-- Try this query and a few others that "project out" some of the columns.
-- Is it slower or faster than the previous one?

SELECT name, subordinates FROM employees;

-- What if we forget the schema?

DESCRIBE employees;

-- Want even more information?

DESCRIBE EXTENDED employees;

-- Look for the "location" field in the output and note the path:
--   hdfs://foobar/mnt/hive_081/warehouse/${DB}.db/employees
-- Where "${DB}" should actually be you database name.
-- (Note: The default path for the Apache Hive release would be 
--    hdfs://foobar/user/hive/warehouse/${DB}.db/employees)

dfs -ls /mnt/hive_081/warehouse/${DB}.db/employees;
dfs -cat /mnt/hive_081/warehouse/${DB}.db/employees/*;

-- We can drop the table after we're done with it. DON'T DO THIS NOW!!

-- DROP TABLE employees;
