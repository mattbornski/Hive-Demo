-- Copyright (c) 2011-2012 Think Big Analytics.

-- Custom UDFs

-- NOTE: Start the Hive CLI in THIS directory! Relative paths used below.

use ${DB};

-- We'll use a Custom UDF implemented in Java to calculate the moving
-- average of stocks. Recall that previously we implemented the same
-- calculation using Python scripts and the SELECT TRANSFORM feature.

-- Note for Java Developers:
-- The source for the implementation is here:
--  ./src/main/java/com/thinkbiganalytics/ex/hiveudfs/MovingAverageUDF.java
-- If you are a Java programmer, you should study this example, as you may
-- find it necessary to implement your own UDFs from time to time.
-- You can load this directory as project into Eclipse or IntelliJ. From the
-- command line, you can build the jar and run the unit tests just by running
-- "ant".

-- We have already built this java code. The "jar" that you incorporate using
-- the ADD JAR command is named "moving-avg-udf.jar". Let's now add this jar.
-- Note the relative path to the jar used below; we assume you started the
-- CLI in this directory, that is, the directory that holds this HQL script!

-- NOTE: For production secenarios, put jars in S3 and use, e.g.,
--   ADD JAR s3n://mybucket/path/to/moving-avg-udf.jar;

ADD JAR Hive-6-UDFs/moving-avg-udf.jar;

CREATE TEMPORARY FUNCTION moving_avg AS 'com.thinkbiganalytics.ex.hiveudfs.MovingAverageUDF';

-- Verify it appears in...

SHOW FUNCTIONS;

DESCRIBE FUNCTION EXTENDED moving_avg;

SELECT ymd, symbol, price_close, moving_avg(50, symbol, price_close) 
FROM stocks 
WHERE symbol = 'AAPL' LIMIT 20;

-- EXERCISE: What happens if you pass 0 as the first argument to 
-- 'moving_avg'?

-- EXERCISE: Run this query, which writes the output to a local directory.
-- Verify that the moving averages for AAPL and IBM were correctly 
-- computed, i.e., that their numbers weren't mixed together (just 
-- "eyeball" the results.).
-- Note that if LOCAL is omitted, then the directory will be created in 
-- the cluster.

INSERT OVERWRITE LOCAL DIRECTORY '/tmp/apple_ibm'
SELECT ymd, symbol, price_close, moving_avg(50, symbol, price_close) 
FROM stocks 
WHERE symbol = 'AAPL' OR symbol = 'IBM';

-- When you're done with the directory, you can delete it:

!rm -rf /tmp/apple_ibm;
