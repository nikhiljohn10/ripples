# MongoDB 3-Node Cluster

| **Mongo URL** | `mongodb://localhost:10001/test` |
|--|--|
| **Version** | 5.0.11 |
| **Container** | mongo |
| **Hostname** | mongo |
| **Username** | `admin` |
| **Password** | `MongoAdmin12` |
| **Command** | `make mongo` |

## Mongo Express

| **Web UI** | http://localhost:10000 |
|--|--|
| **Version** | latest |
| **Container** | mongo-express |
| **Hostname** | mongo-express |
| **Username** | `express` |
| **Password** | `MongoDB@1234` |

## Details

Database URL: 
```
mongodb://admin:MongoAdmin12@localhost:10001/test
```

| Node name | Host : Port | Cluster Type |
|--|--|--|
| mongo | localhost:10001 | Primary |
| mongo1 | localhost:10002 | Secondary |
| mongo2 | localhost:10003 | Secondary |

  * Cluster Init script: [scripts/mongo_init.sh](scripts/mongo_init.sh)
    * Use option `-f` to start a fresh container
  * Production ready
