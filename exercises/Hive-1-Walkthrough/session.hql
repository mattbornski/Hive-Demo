-- Copyright (c) 2011-2012 Think Big Analytics.

-- Hive Walkthrough

-- This is a comment line, supported in Hive v0.8.0 or later.
-- (Yes, Hive didn't have a comment convention for scripts before then!)


-- Run a shell command (semicolon required!) It doesn't understand
-- file "globs" nor shell environment variables, like $HOME.

! ls -l;
! pwd ;
! ls exercises ;

-- Run a distributed file system command (semicolon required!)

dfs -ls /data;

-- We'll dive into the details for the following examples, but for now
-- just get a "sense" of what they are doing.

-- Show the tables (there aren't any yet).

SHOW TABLES;

-- Create a "database" with the same name as your user name.
-- Make sure you use a name, assigned to the DB, that IS UNIQUE!

CREATE DATABASE ${DB};

-- This will be your working database throughout the class. When working on
-- a shared cluster, everyone needs their own database to avoid name
-- collisions when creating tables. Even when you have a dedicated system 
-- of your own, it is still a good practice to organize your tables into 
-- databases, so we'll do that in this class.

-- Look at the databases defined. You should see "default", your database,
-- and the other databases for the people sharing your cluster:

SHOW DATABASES;

-- Now "use" your database, instead of the default database. 
-- As written, this command WON'T work unless you started hive with the
-- "-d DB=mydatabasename" option!

use ${DB};

-- Show the tables again (there should be none):

SHOW TABLES;

-- Quit gracefully (you can also use Control-D). 
-- We won't actually do this now!
-- quit;
