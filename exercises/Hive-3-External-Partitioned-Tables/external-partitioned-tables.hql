-- Copyright (c) 2011-2012 Think Big Analytics.

-- Using External Tables with Partitions:

-- NOTE: Make sure you started hive with a definition for DATA and DB:
--   hive -d DATA=/data -d DB=yourdatabase
-- or
--   bin/hive.sh -d DATA=/data -d DB=yourdatabase

use ${DB};

-- We'll demonstrate the use of two features, external (vs. managed or
-- internal) tables and partitioning the table to speed up performance.
-- Recall that you can also use partitioning with managed tables.

-- We'll use historical stock price data from Infochimps.com:
--   NASDAQ: infochimps_dataset_4777_download_16185
--   NYSE:   infochimps_dataset_4778_download_16677

-- The EXTERNAL keyword tells Hive that the table storage will
-- be "external" to Hive, rather than the default internal 
-- storage. We'll specify where the storage exists below.
-- We'll also partition the table by the exchange and the 
-- stock symbol, which will speed-up queries selecting on either
-- field, because Hive will know it can skip partitions that 
-- don't match the specified query values!

CREATE EXTERNAL TABLE IF NOT EXISTS stocks (
  ymd             STRING,
  price_open      FLOAT, 
  price_high      FLOAT,
  price_low       FLOAT,
  price_close     FLOAT,
  volume          INT,
  price_adj_close FLOAT
)
PARTITIONED BY (exchange STRING, symbol STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

-- We don't have any partitions yet:

SHOW PARTITIONS stocks;

-- For EXTERNAL, partitioned tables, you use ALTER TABLE to add each
-- partition and specify a unique directory for its data.
-- We'll just add data for four stocks:

ALTER TABLE stocks ADD PARTITION(exchange = 'NASDAQ', symbol = 'AAPL')
LOCATION '${DATA}/stocks/input/plain-text/NASDAQ/AAPL';

ALTER TABLE stocks ADD PARTITION(exchange = 'NASDAQ', symbol = 'INTC')
LOCATION '${DATA}/stocks/input/plain-text/NASDAQ/INTC';

ALTER TABLE stocks ADD PARTITION(exchange = 'NYSE', symbol = 'GE')
LOCATION '${DATA}/stocks/input/plain-text/NYSE/GE';

ALTER TABLE stocks ADD PARTITION(exchange = 'NYSE', symbol = 'IBM')
LOCATION '${DATA}/stocks/input/plain-text/NYSE/IBM';


SHOW PARTITIONS stocks;

-- Try a test query. How fast are these two queries??

SELECT * FROM stocks WHERE exchange = 'NASDAQ' AND symbol = 'AAPL' LIMIT 10;
SELECT ymd, price_close FROM stocks WHERE exchange = 'NASDAQ' AND symbol = 'AAPL' LIMIT 10;

-- Try a few other queries to play with the data.
