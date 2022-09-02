# Ripples

## Contents

 * [Monitoring (Prometheus + Grafana)](#monitoring-prometheus--grafana)
 * [PostgreSQL + PG Admin](#postgresql--pg-admin)
 * [Mongo Cluster + Monog Express](#mongo-cluster--monog-express)
 * [Redis + RedisInsight](#redis--redisinsight)
 * [CockroachDB Cluster](#cockroachdb-cluster)
 * [New Relic](#new-relic)
 * [Other scripts](#other-scripts)

## Monitoring (Prometheus + Grafana)

 * Web UI: http://localhost:30000
 * Grafana user: `admin`
 * Grafana password: `Grafana@1234`
 * Configuration file: [configs/prometheus.yml](configs/prometheus.yml)
 * The `node-exporter` is used as data sorce

## PostgreSQL + PG Admin

 * Web UI: http://localhost:50000
 * PG Admin email: `admin@pgadmin.org`
 * PG Admin password: `PGAdmin@1234`
 * Database URL: `postgresql://admin:Postgres1234@localhost:5432/example_db`

## Mongo Cluster + Monog Express

Full 3-node cluster is started and initialised with the following command:

```
bash scripts/mongo_init.sh
```

 * Cluster Init script: [scripts/mongo_init.sh](scripts/mongo_init.sh)
 * Web UI: http://localhost:10000
 * Web UI username: `express`
 * Web UI password: `MongoDB@1234`
 * Database admin username: `admin`
 * Database admin password: `MongoAdmin12`
 * Database url: `mongodb://admin:MongoAdmin12@localhost:10001/test`
 * Primary cluster: `localhost:10001`
 * Secondary clusters: `localhost:10002`,`localhost:10003`

## Redis + RedisInsight

## CockroachDB Cluster

To start cluster:
```
docker compose -f "docker-compose.roach.yml" up -d
```

Full 3-node cluster is initialised with the following command:

```
bash scripts/roach_init.sh
```

Cluster Init script: [scripts/roach_init.sh](scripts/roach_init.sh)

## New Relic

## Other Scripts

 * [Clean docker](scripts/clean_docker.sh) (Use option `+i` as argument to clean images as well)
