# SO THIS IS NOT ACTUALLY A BASH SCRIPT. I gave it the .sh extension so I could have lovely highlighting in my text editor.

cd /data/ucb/wk6

wget –O /data/wikinews.json https://s3.amazonaws.com/ucbdatasciencew205/inclass_datasets/wikinews.json

hdfs dfs -put /data/ucb/wk6/wikinews.json /user/ucb/datafiles


su ucb

pyspark

wikinews = sc.textFile("/user/ucb/datafiles/wikinews.json")
print wikinews.first()

import json
print json.loads(wikinews.first()).keys()
news_json = wikinews.map(json.loads)
print news_json.toDebugString()
by_date = news_json.groupBy(lambda x: x['date'])
print by_date.count()

# 3154

print by_date.toDebugString()

(2) PythonRDD[11] at RDD at PythonRDD.scala:42 []
 |  MapPartitionsRDD[9] at mapPartitions at PythonRDD.scala:338 []
 |  ShuffledRDD[8] at partitionBy at NativeMethodAccessorImpl.java:-2 []
 +-(2) PairwiseRDD[7] at groupBy at <stdin>:1 []
    |  PythonRDD[6] at groupBy at <stdin>:1 []
    |  /user/ucb/datafiles/wikinews.json MapPartitionsRDD[1] at textFile at NativeMethodAccessorImpl.java:-2 []
    |  /user/ucb/datafiles/wikinews.json HadoopRDD[0] at textFile at NativeMethodAccessorImpl.java:-2 []


newrdd = news_json.map(lambda x: (x['title'],x['fulltext']))
count_words = newrdd.map(lambda x: (x[0], len(x[1].split())))

print count_words.take(10)

count_words.map(lambda x: json.dumps({"title":x[0], "count":x[1]})).saveAsTextFile("/user/ucb/datafiles/wikicounter")



# exit or go to another shell, to see your new awsome json file:
# btw, /user/ucb/datafiles/wikicounter/*, totally doen't work for me. boo, it worked for Dan.
hdfs dfs -tail /user/ucb/datafiles/wikicounter/part-00000









