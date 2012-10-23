![](../../images/SmallThinkBigIcon.png)
# README for Hive-SerDe

Copyright &#169; 2011-2012 Think Big Analytics.

This exercise demonstrates several things:

1. How to write a custom SerDe.
2. How to use a JSON SerDe.

This directory uses a prebuilt version of a [Hive JSON SerDe](https://github.com/ThinkBigAnalytics/hive-json-serde) GitHub project, one of several on the InterWebs, which has some very nice features, as we illustrate in `serde.hql`.

The code in this exercise relies on three jar files that are in the `exercises/lib` directory. 

* `hive-json-serde-0.3.jar`: The JSON SerDe built from the GitHub project.
* `json-path-0.5.4.jar`: A support jar required by the SerDe.
* `json-smart-1.0.6.3.jar`: Another support jar required by the SerDe.

Because they need to be added to the `HADOOP_CLASSPATH` when invoking `hive`, you should run this exercise using `bin/hive.sh`, as for previous exercises. Also, the first few commands you'll execute use a relative path that assumes you started Hive in the `exercises` directory. 

So, first change to the `exercises` directory, run `bin/hive.sh`, then proceed to `serde.hql`.
