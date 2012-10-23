-- Copyright (c) 2011-2012 Think Big Analytics.

-- N-Gram analysis for Natural-language Processing (Data Mining) 
-- and statistics, specifically histograms.

-- NOTE: Make sure you started hive using our hive.sh script and
-- with a definition for DATA:
--   bin/hive.sh -d DATA=/data -d DB=yourdatabase

use ${DB};

-- NGrams are a useful technique for going beyond text analysis
-- based on single word counts, etc, to extracting meaningful
-- phrases from which probabilistic models can be built.

-- We're going to play with the Twitter data we used before, so first 
-- add the jars that can parse the data. (You don't need to run these
-- three commands again if you haven't existed the CLI since doing the
-- SerDe exercises, but it's harmless to run them again.)

ADD JAR lib/hive-json-serde-0.3.jar;
ADD JAR lib/json-path-0.5.4.jar;
ADD JAR lib/json-smart-1.0.6.3.jar;

-- In the Twitter data, select the 50 most frequent 2-word pairs,
-- called "digrams". We'll convert to lower case.
-- Note that we "explode" the array that ngrams() returns to convert
-- it into separate records, rather than a giant, inconvenient array.

SELECT explode(ngrams(sentences(lower(text)), 2, 50)) as ngs FROM twitter; 

-- EXERCISE: Try computing trigrams (3-word triplets).

-- EXERCISE: Change the query to use the Shakespeare corpus instead.
-- What are the most common digrams (n = 2), trigrams (n = 3), and 
-- four-grams (n = 4)? How do the results change? Is there any 
-- apparent performance overhead for larger N? Do you think these results
-- are more or less useful for understanding trends in the data?
-- In the natural language processing community, the general consensus is
-- that trigrams provide the best trade-off for finding meaningful samples 
-- of useful phrases.


-- Select the 100 most common words that appear after "I need" 
-- (converted to lower case) in a sample of Twitter data. 

SELECT explode(context_ngrams(sentences(lower(text)), array("i", "need", null), 100)) 
AS ngs FROM twitter;

-- EXERCISE: Try different words instead of "need".
-- EXERCISE: Try different leading phrases with 2 or more words.
-- EXERCISE: Try the context_ngrams query with Shakespeare's corpus, using
-- different the prefixes, such as "thou art" and "with all my heart".

-- Histograms:

-- Compute histogram data with 20 "bars" for AAPL's closing price.

SELECT histogram_numeric(price_close, 20) 
FROM stocks WHERE symbol = 'AAPL';

-- EXERCISE: Use this variation of the previous query to write the output to 
-- a local file. Use Excel or another tool at your disposal to graph the results.

INSERT OVERWRITE LOCAL DIRECTORY '/tmp/apple_hist'
SELECT histogram_numeric(price_close, 20) 
FROM stocks WHERE symbol = 'AAPL';

-- EXERCISE: Vary the number of histogram bars. How does the qualitative 
-- feel of the results change?
