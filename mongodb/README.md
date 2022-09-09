# Mongo Cluster + Monog Express

Full 3-node cluster is started and initialised with the following command:

```
bash scripts/mongo_init.sh
```

 * Web UI: http://localhost:10000
 * Database url: `mongodb://admin:MongoAdmin12@localhost:10001/test`
 * Primary cluster: `localhost:10001`
 * Secondary clusters: `localhost:10002`,`localhost:10003`
 * Cluster Init script: [scripts/mongo_init.sh](scripts/mongo_init.sh)
   * Use option `-f` to start a fresh container
 * Production ready
