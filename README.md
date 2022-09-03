# Ripples

## Contents

 * [Summary](#summary)
 * [PostgreSQL + PG Admin](#postgresql--pg-admin)
 * [Mongo Cluster + Monog Express](#mongo-cluster--monog-express)
 * [CockroachDB Cluster](#cockroachdb-cluster)
 * [Redis + RedisInsight](#redis--redisinsight)
 * [Keycloak](#keycloak)
 * [Monitoring (Prometheus + Grafana)](#monitoring-prometheus--grafana)
 * [Other scripts](#other-scripts)

## Summary

| Container        | PostgreSQL                      | MongoDB                         | CockroachDB                     | Redis                           | Keycloak                         | Monitoring(Grafana)             |
|------------------|---------------------------------|---------------------------------|---------------------------------|---------------------------------|----------------------------------|---------------------------------|
| Extra Tool       | PG-Admin:6.13                   | Mongo-Express                   | None                            | RedisInsight:1.13.0             | None                             | Node Express:v1.3.1             |
| Version          | 14.5                            | 5.0.11                          | v22.1.6                         | 7.0.4                           | 19.0.1                           | 9.1.2                           |
| Dependency       | None                            | Init Script                     | Init Script                     | None                            | PostgreSQL                       | Prometheus:v2.38.0              |
| Make command     | `make postgres`                 | `make mongo`                    | `make roach`                    | `make redis`                    | `make keycloak`                  | `make monitor`                  |
| WebUI Port       | [50000](http://localhost:50000) | [10000](http://localhost:10000) | [20000](http://localhost:20000) | [40000](http://localhost:40000) | [50443](https://localhost:50443) | [30000](http://localhost:30000) |
| WebUI User/Email | admin@pgadmin.org               | express                         | None                            | None                            | admin                            | admin                           |
| WebUI Password   | PGAdmin@1234                    | MongoDB@1234                    | None                            | None                            | Keycloak@123                     | Grafana@1234                    |
| Admin User       | admin                           | admin                           | None                            | default                         | server.keystore                  | None                            |
| Admin Password   | Postgres1234                    | MongoAdmin12                    | None                            | Redis@123456                    | KeyCloakPassW0rd                 | None                            |

## PostgreSQL + PG Admin

 * Web UI: http://localhost:50000
 * Database URL: `postgresql://admin:Postgres1234@localhost:5432/keycloak`
 * JDBC URL: `jdbc:postgresql://localhost:5432/keycloak?user=admin&password=Postgres1234`

## Mongo Cluster + Monog Express

Full 3-node cluster is started and initialised with the following command:

```
bash scripts/mongo_init.sh
```

 * Web UI: http://localhost:10000
 * Database url: `mongodb://admin:MongoAdmin12@localhost:10001/test`
 * Primary cluster: `localhost:10001`
 * Secondary clusters: `localhost:10002`,`localhost:10003`
 * Cluster Init script: [scripts/mongo_init.sh](scripts/mongo_init.sh) (Use option `-f` to start a fresh container)

## CockroachDB Cluster

Full 3-node cluster is started and initialised with the following command:

```
bash scripts/roach_init.sh
```

 * Web UI: http://localhost:20000
 * Database url: `postgresql://localhost:26257/defaultdb?sslmode=disable`
 * JDBC url: `jdbc:postgresql://localhost:26257/defaultdb?sslmode=disable`
 * Cluster Init script: [scripts/roach_init.sh](scripts/roach_init.sh)
 * CockroachDB uses postgres network driver. Hence the urls are similar postgresql url

## Redis + RedisInsight

 * Web UI: http://localhost:40000

## Keycloak

 * Web UI: https://localhost:50443
 * Key Store location: `/opt/keycloak/conf/server.keystore`
 * User certificates instead of key-store for production
 * Only works with PostgreSQL (Run `make postgres` to start postgres)

## Monitoring (Prometheus + Grafana)

 * Web UI: http://localhost:30000
 * Configuration file: [configs/prometheus.yml](configs/prometheus.yml)
 * The `node-exporter` is used as data sorce

## Other Scripts

 * `make up` or simply `make` will start all the containers
 * `make down` will take down all the containers
 * [Clean docker](scripts/clean_docker.sh) (Use option `+i` as argument to clean images as well)
   * `make clean` will clean all unsued volumes and networks
   * `make cleanall` will clean unsued images along with volumes and networks
 * [Localhost certificate](scripts/localhost_certs.sh)
   * `make cert` generate localhost certificates in `./certs` directory


