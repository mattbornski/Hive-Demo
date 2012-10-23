#!/usr/bin/env python
# Copyright (c) 2011-2012 Think Big Analytics.
# The reducer for the WordCount Streaming exercise.

import sys

# In the Java API the reducer receives:
#  key1 [value11 value12 ...]
#  key2 [value21 value22 ...]
#  ...
# In the streaming API, the reducer receives:
#  key1 value11
#  key1 value12
#  ...
#  key2 value21
#  key2 value22
#  ...

(last_key, last_count) = (None, 0)
for line in sys.stdin:
  (key, count) = line.strip().split("\t")
  if last_key and last_key != key:
    print "%s\t%d" % (last_key, last_count)
    (last_key, last_count) = (key, int(count))
  else:
    last_key = key
    last_count += int(count)

if last_key:
    print "%s\t%d" % (last_key, last_count)

