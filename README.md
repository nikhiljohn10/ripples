# Ripples

## Services

 * [PostgreSQL + PG Admin](/postgresql)
 * [Mongo Cluster + Monog Express](/mongodb)
 * [CockroachDB Cluster](/cockroachdb)
 * [Redis + RedisInsight](/redis)
 * [Keycloak](/keycloak)
 * [Monitoring (Prometheus + Grafana)](/monitor)
 * [Docker Registry](/registry)

## Summary

| Container        | PostgreSQL                      | MongoDB                         | CockroachDB                     | Redis                           | Keycloak                         | Monitoring(Grafana)             |
|------------------|---------------------------------|---------------------------------|---------------------------------|---------------------------------|----------------------------------|---------------------------------|
| Extra Tool       | PG-Admin:6.13                   | Mongo-Express                   | None                            | RedisInsight:1.13.0             | None                             | Node Express:v1.3.1             |
| Version          | 14.5                            | 5.0.11                          | v22.1.6                         | 7.0.4                           | 19.0.1                           | 9.1.2                           |
| Dependency       | None                            | Init Script                     | Init Script                     | None                            | PostgreSQL                       | Prometheus:v2.38.0              |
| Make command     | `make postgres`                 | `make mongo`                    | `make roach`                    | `make redis`                    | `make keycloak`                  | `make monitor`                  |
| WebUI Port       | [50000](http://localhost:50000) | [10000](http://localhost:10000) | [20000](https://localhost:20000) | [40000](http://localhost:40000) | [50443](https://localhost:50443) | [30000](http://localhost:30000) |
| WebUI User/Email | admin@pgadmin.org               | express                         | roach                            | None                            | admin                            | admin                           |
| WebUI Password   | PGAdmin@1234                    | MongoDB@1234                    | Cockroach123                            | None                            | Keycloak@123                     | Grafana@1234                    |
| Admin User       | admin                           | admin                           | root                            | default                         | server.keystore                  | None                            |
| Admin Password   | Postgres1234                    | MongoAdmin12                    | None                            | Redis@123456                    | KeyCloakPassW0rd                 | None                            |

## Scripts

 * `make up` or simply `make` will start all the containers
 * `make down` will take down all the containers
 * [Clean docker](scripts/clean_docker.sh) (Use option `+i` as argument to clean images as well)
   * `make clean` will clean all unsued volumes and networks
   * `make cleanall` will clean unsued images along with volumes and networks
 * [Localhost certificate](scripts/localhost_certs.sh)
   * `make cert` generate localhost certificates in `./certs` directory
