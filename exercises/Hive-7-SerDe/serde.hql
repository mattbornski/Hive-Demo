-- Copyright (c) 2011-2012 Think Big Analytics.

-- SerDes

-- WARNING: You must start hive using "bin/hive.sh" under the exercises
-- directory, if you haven't already done so:
--
--   bin/hive.sh -d DATA=/data -d DB=yourdatabase
--
-- Otherwise, you'll get a "Java exception" like:
--    Exception in thread "main" java.lang.NoClassDefFoundError: com/jayway/jsonpath/PathUtil
--    ...

use ${DB};

-- Let's use a JSON SerDe to parse the same Twitter data
-- we used in a previous exercise. This jar was built using
-- the code from:
--   https://github.com/ThinkBigAnalytics/hive-json-serde
-- A nice feature of this SerDe is that it allows us to 
-- do the explicit mapping from JSON fields to columns
-- in the SERDEPROPERTIES. Contrast this approach with Hive's
-- built in JSON UDF, 'get_json_object', which parses a STRING
-- and extracts the desired fields.
-- NOTE: There is also an AWS EMR SerDe for JSON parsing. 
-- It is demonstrated here: 
-- http://docs.amazonwebservices.com/ElasticMapReduce/latest/GettingStartedGuide/CreateJobFlowHive.html

-- As before, add an appropriate path before the jar files in the 
-- next three commands. As written we assume you invoked hive.sh 
-- while in the "exercises" directory; hence we reference the "lib"
-- subdirectory, where these jars are located.
-- The first one is our SerDe, hive-json-serde. The 2nd and 3rd
-- jars are required by it.

-- NOTE: For production secenarios, put jars in S3 and use, e.g.,
--   ADD JAR s3n://mybucket/path/to/hive-json-serde-0.3.jar;

ADD JAR lib/hive-json-serde-0.3.jar;
ADD JAR lib/json-path-0.5.4.jar;
ADD JAR lib/json-smart-1.0.6.3.jar;

-- We have a short section of the the Twitter "firehose" 
-- loaded in the cluster. The data is in JSON. For simplicity, we
-- will look at a small subset of the data fields.

CREATE EXTERNAL TABLE IF NOT EXISTS twitter (
  tweet_id         BIGINT,
  created_at       STRING,
  text             STRING,
  user_id          BIGINT,
  user_screen_name STRING,
  user_lang        STRING
)
ROW FORMAT SERDE "org.apache.hadoop.hive.contrib.serde2.JsonSerde"
WITH SERDEPROPERTIES (
  "tweet_id"="$.id",
  "created_at"="$.created_at",
  "text"="$.text",
  "user_id"="$.user.id",
  "user_screen_name"="$.user.screen_name",
  "user_lang"="$.user.lang"
)
LOCATION '${DATA}/twitter/input';

-- Here is an identical table where we explicitly specify
-- the INPUTFORMAT and OUTPUTFORMAT classes.
-- (You don't need to create this one...)

CREATE EXTERNAL TABLE IF NOT EXISTS twitter2 (
  tweet_id         BIGINT,
  created_at       STRING,
  text             STRING,
  user_id          BIGINT,
  user_screen_name STRING,
  user_lang        STRING
)
ROW FORMAT SERDE "org.apache.hadoop.hive.contrib.serde2.JsonSerde"
WITH SERDEPROPERTIES (
  "tweet_id"="$.id",
  "created_at"="$.created_at",
  "text"="$.text",
  "user_id"="$.user.id",
  "user_screen_name"="$.user.screen_name",
  "user_lang"="$.user.lang"
)
STORED AS 
INPUTFORMAT  'org.apache.hadoop.mapreduce.lib.input.TextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION '${DATA}/twitter/input';

-- EXERCISE: How could you determine the INPUTFORMAT and OUTPUTFORMAT used 
-- in a table?

-- Let's try a few queries.

SELECT * FROM twitter LIMIT 50;
SELECT user_id, user_screen_name FROM twitter WHERE user_lang != 'en';

-- EXERCISE: Modify the following query to list the unique "user_lang" values 
-- without duplication. Hint: A single keyword will do it.

SELECT user_lang FROM twitter;

-- EXERCISE: Write a query that lists user names and their user ids. 
-- Then modify the query to count the number of tweets per user. Hint: use GROUP BY.

SELECT user_screen_name, user_id FROM twitter LIMIT 20;

-- EXTRA CREDIT: Read through some of the tweets. What do they tell you about 
-- the state of mankind??
