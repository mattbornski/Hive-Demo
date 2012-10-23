-- Copyright (c) 2011-2012 Think Big Analytics.

-- Join statements.

-- NOTE: Make sure you started hive with a definition for DATA:
--   hive -d DATA=/data -d DB=yourdatabase
-- or
--   bin/hive.sh -d DATA=/data -d DB=yourdatabase

use ${DB};

-- We'll continue using our stocks table, which we created thusly:

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

-- Let's also now create a new table of dividends, using the same
-- partitioning scheme. We have already set up the external files
-- in the distributed file system, so we won't go through the same
-- sequence of steps we used for "stocks".
-- Run the following sequence of commands to create the table and
-- add the required partitions.

CREATE EXTERNAL TABLE IF NOT EXISTS dividends (
  ymd             STRING,
  dividend        FLOAT
)
PARTITIONED BY (exchange STRING, symbol STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

ALTER TABLE dividends ADD PARTITION(exchange = 'NASDAQ', symbol = 'AAPL')
LOCATION '${DATA}/dividends/input/plain-text/NASDAQ/AAPL';

ALTER TABLE dividends ADD PARTITION(exchange = 'NASDAQ', symbol = 'INTC')
LOCATION '${DATA}/dividends/input/plain-text/NASDAQ/INTC';

ALTER TABLE dividends ADD PARTITION(exchange = 'NYSE', symbol = 'GE')
LOCATION '${DATA}/dividends/input/plain-text/NYSE/GE';

ALTER TABLE dividends ADD PARTITION(exchange = 'NYSE', symbol = 'IBM')
LOCATION '${DATA}/dividends/input/plain-text/NYSE/IBM';

-- Try a self join:

SELECT a.ymd, a.symbol, a.price_close, b.symbol, b.price_close 
FROM stocks a 
JOIN stocks b 
ON a.ymd    = b.ymd AND
   a.symbol = 'AAPL' AND 
   b.symbol = 'IBM'
WHERE a.ymd > '2010-01-01' 
LIMIT 20;

-- JOIN Performance.

-- These two inner join queries are identical except for the MAPJOIN 
-- directive in the second one. Hive will try to perform the whole join 
-- in the map phase, without a reduce phase. It will succeed because the 
-- dividends table is small enough to be cached in memory! How much
-- faster is the second query?

SELECT s.ymd, s.symbol, s.price_close, d.dividend
FROM dividends d
JOIN stocks s ON s.ymd = d.ymd AND s.symbol = d.symbol
WHERE s.symbol = 'AAPL';

SELECT /*+ MAPJOIN(d) */ s.ymd, s.symbol, s.price_close, d.dividend
FROM dividends d
JOIN stocks s ON s.ymd = d.ymd AND s.symbol = d.symbol
WHERE s.symbol = 'AAPL';

-- Remember, this is an optimization. Are the results EXACTLY the same? 
-- Why or why not? If they are different, how are they different and
-- is this a bad thing?


