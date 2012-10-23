-- Copyright (c) 2011-2012 Think Big Analytics.

-- Transform/Map-Reduce Syntax

-- NOTE: Make sure you started hive with a definition for DATA:
--   hive -d DATA=/data -d DB=yourdatabase
-- or
--   bin/hive.sh -d DATA=/data -d DB=yourdatabase

use ${DB};

-- This is a technique for calling out to separate programs, 
-- written in any language, for map and/or reduce tasks.
-- We'll use it do Word Count on Shakespeare's plays.

-- First, create an external table for the original input, where 
-- we treat each line of the text file as a single field. The
-- "${DATA}/shakespeare/input" already exists.

CREATE EXTERNAL TABLE shakespeares_plays (line STRING)
LOCATION '${DATA}/shakespeare/input';

-- Now create an internal table for the output, which will contain
-- each word found and its total count.

CREATE TABLE shakespeares_plays_wc (word STRING, count INT)
ROW FORMAT 
DELIMITED FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE;

-- Now run the query discussed in the lecture. Note that we first 
-- "add" the python files, which copies them around the cluster to the 
-- working directories the individual tasks will have when they run. 
-- Hence, we don't need directory paths in the query when we call these 
-- scripts.
-- NOTE: We assume you are running in the "exercises" directory!

ADD FILE Hive-Transform/mapper.py;
ADD FILE Hive-Transform/reducer.py; 

FROM (
  FROM shakespeares_plays
  MAP line
  USING 'mapper.py'
  AS word, count
  CLUSTER BY word) wc
INSERT OVERWRITE TABLE shakespeares_plays_wc
  REDUCE wc.word, wc.count
  USING 'reducer.py'
  AS word, count;

-- Look at the output:

SELECT * FROM shakespeares_plays_wc LIMIT 100;

-- Here is the same MAP ... and REDUCE ... query written in the
-- alternative SELECT TRANSFORM (...) syntax.
-- Note the required parentheses...

FROM (
  FROM shakespeares_plays
  SELECT TRANSFORM (line)
  USING 'mapper.py'
  AS word, count
  CLUSTER BY word) wc
INSERT OVERWRITE TABLE shakespeares_plays_wc
  SELECT TRANSFORM (wc.word, wc.count)
  USING 'reducer.py'
  AS word, count;

-- Check the results:

SELECT * FROM shakespeares_plays_wc LIMIT 100;

-- EXERCISE: Try this same code on the Twitter data. Just use the "text"
-- column in the data.

-- EXERCISE: If you know Python, try to improve the string tokenization in the mapper.py script to remove punctuation, etc.
