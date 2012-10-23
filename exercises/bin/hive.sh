#!/usr/bin/env bash
#----------------------------------------------------------
# hive.sh: Invoke hive with additional jars in ../lib added
# to the HADOOP_CLASSPATH. This script is only required for
# a few of the exercises; their READMEs will to tell you
# to use it.

: ${HADOOP_CLASSPATH:=.}
rootdir=$(dirname $0)
for jar in $rootdir/../lib/*.jar
do
	jarname=$(basename $jar)
	case "$jarname" in
		hive-exec-*) ;;  # skip
		*)
			HADOOP_CLASSPATH=$HADOOP_CLASSPATH:$jar
			;;
	esac
done

echo "running: env HADOOP_CLASSPATH=$HADOOP_CLASSPATH hive $@"
env HADOOP_CLASSPATH=$HADOOP_CLASSPATH hive "$@"

