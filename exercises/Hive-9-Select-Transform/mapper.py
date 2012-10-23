#!/usr/bin/env python
# Copyright (c) 2011-2012 Think Big Analytics.
# The mapper for the WordCount Streaming exercise.

import sys

for line in sys.stdin:
    words = line.strip().split()
    for word in words:
        print "%s\t1" % (word.lower())
    
