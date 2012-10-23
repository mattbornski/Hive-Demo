![](../../images/SmallThinkBigIcon.png)
# README for Hive-6-UDFs

Copyright &#169; 2011-2012 Think Big Analytics.

There are two `hql` scripts for this exercise:

* `udfs.hql` - Use Hive's built-in functions.
* `customudfs.hql` - Use a custom UDF we wrote.

This exercise contains the source for the custom UDF, written in Java, which computes moving averages of stock data (a common practice in "technical analysis" of markets).

The code is already built and ready to use in the Java "jar" file `moving-avg-udf.jar`. 

If you are a Java programmer, it's worth diving into the code to understand what it's doing, as you may frequently find yourself implementing custom UDFs. We have included Eclipse project files, so you can use the import feature to load the code into Eclipse. 

Also, you can build the code using `Ant`:

	ant

However, both the Eclipse project and `ant` will look for dependent jar files in the `exercises/lib` directory that we have not included. They include the main Hadoop jar file and others that it requires. Use the error messages to see what jars are missing and add them to the `lib` directory.
