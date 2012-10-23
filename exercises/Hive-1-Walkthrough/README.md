![](../../images/SmallThinkBigIcon.png)
# README for Hive-Walkthrough

Copyright &#169; 2011-2012 Think Big Analytics.

This exercise gets you started with Hive.

## Starting Hive

Log into the cluster using the instructions in the [README](../../README.html).

Normally, once you're logged into the cluster, you just run the command `hive` to start the Hive CLI, but we'll start it with a "wrapper" shell script, for reasons we'll explain later.

So, first change to the `exercises` directory:

  cd exercises

For help on the `hive` CLI, use the `-h` option:

  bin/hive.sh -h

To start the Hive CLI (command-line interface), use this command:

  bin/hive.sh -d DATA=/data -d DB=your-name

We've passed a few extra arguments to define two *variables* that work something like `bash` shell environment variables:

* We're assuming that our Hive scripts use a parameter `DATA` to define where data files are located. We have already staged this data in HDFS in the `/data` directory.
* Since we're sharing clusters, each of you will create a Hive *database* using your name or whatever name you want to use. Of course, it can't have spaces, etc. Just use your "favorite" login name. This could be the same name you used to create a work directory in the startup [README](../../README.html). So, the second parameter defines a variable `DB` that we'll use as the name of your database. 

Because `DATA=/data` doesn't specify a full URI, e.g., `hdfs://server:port/data`, this path will default to HDFS (the Hadoop Distributed File System). 

If you wanted to use an S3 location instead, you could use something like this example:

  bin/hive.sh -d DATA=s3n://some-bucket/data -d DB=your-name 

In the HiveQL scripts, you reference the `DATA` and `DB` variables with `${DATA}` and `${DB}`, respectively.

Finally, we won't do this today, but you could run a HiveQL script file with the `-f` option:

  hive -d DATA=/data -d DB=your-name -f some-file.hql

## Next Steps

Open the first HiveQL file, `session.hql` in this directory. We'll go through it together to understand many useful commands to get us started.

For more information on Hive commands, see the *Hive Cheat Sheet* distributed with the lab.

