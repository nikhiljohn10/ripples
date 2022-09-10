# Ripples

## Services

  * [PostgreSQL + PG Admin](/postgresql)
  * [Mongo Cluster + Monog Express](/mongodb)
  * [CockroachDB Cluster](/cockroachdb)
  * [Redis + RedisInsight](/redis)
  * [Keycloak](/keycloak)
  * [Monitoring (Prometheus + Grafana)](/monitor)
  * [Docker Registry](/registry)

## Makefile

Use command `make help` or simply `make` to display help

## Scripts

  * [Clean docker](scripts/clean_docker.sh)
    * Remove all unused volumes and networks
    * Use option `+i` as argument to remove unused images as well
  * [Localhost certificate](scripts/localhost_certs.sh)
    * Create certificate for localhost
  * [Htpasswd](scripts/htpasswd.sh)
    * Create htpasswd file
    * Use `-h` option to display usage
