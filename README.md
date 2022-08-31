# Ripples

## Docker compose files

 * [Monitoring (Prometheus + Grafana)](docker-compose.monitor.yml)
 * [New Relic](docker-compose.newrelic.yml)
 * [PostgreSQL + PG Admin](docker-compose.postgres.yml)
 * [CockroachDB Cluster](docker-compose.roach.yml)
 * [Mongo Cluster + Monog Express](docker-compose.mongo.yml)
 * [Redis + RedisInsight](docker-compose.redis.yml)

 ## Scripts

 * [CockroachDB cluster initialization](scripts/roach_init.sh)
 * [Mongo cluster initialization](scripts/mongo_init.sh)
 * [Clean docker](scripts/clean_docker.sh) (Use option `+i` as argument to clean images as well)

 ## Configurations

  * [Prometheus configuration](configs/prometheus.yml)