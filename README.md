# Ripples

## Services

- [PostgreSQL + PG Admin](/postgresql)
- [Mongo Cluster + Monog Express](/mongo)
- [CockroachDB Cluster](/cockroachdb)
- [MySQL](/mysql)
- [Redis Cluster + RedisInsight](/redis)
- [Keycloak](/keycloak)
- [Monitoring (Prometheus + Grafana)](/monitor)
- [Docker Registry](/registry)
- [Portainer](/portainer)
- [StepCA](/stepca)

## Makefile

Use command `make help` or simply `make` to display help

## Scripts

- [CA Check](scripts/ca_check.sh)
  - Check if Step CA service is healthy and running
- [Clean docker](scripts/clean_docker.sh)
  - Remove all unused volumes and networks
  - Use option `+i` as argument to remove unused images as well
- [Localhost certificate](scripts/localhost_certs.sh)
  - Create certificate for localhost
- [Htpasswd](scripts/htpasswd.sh)
  - Create htpasswd file
  - Use `-h` option to display usage
- [Create StepCA Certificate](scripts/step_certs.sh)
  - Change to repo directory before execution
- [Renew StepCA Certificate](scripts/step_certs_renew.sh)
  - Change to repo directory before execution
- [Utilities](scripts/utils.sh)
  - Containes small utilities functions required for other scripts
