# CockroachDB Cluster

Full 3-node cluster is started and initialised with the following command:

```
bash scripts/roach_init.sh
```

 * Web UI: https://localhost:20000
 * Database url: `postgresql://root@roach:26257/defaultdb?sslcert=certs%2Fclient.root.crt&sslkey=certs%2Fclient.root.key&sslmode=verify-full&sslrootcert=certs%2Fca.crt`
 * JDBC url: `jdbc:postgresql://roach:26257/defaultdb?sslcert=certs%2Fclient.root.crt&sslkey=certs%2Fclient.root.key&sslmode=verify-full&sslrootcert=certs%2Fca.crt&user=root`
 * Cluster Init script: [scripts/roach_init.sh](scripts/roach_init.sh)
   * Use option `-f` to start a fresh container
 * New user script: [scripts/roach_new_user.sh](scripts/roach_new_user.sh)
   * Usage: `scripts/roach_new_user.sh [SQL_USER] [-d|-p [PASSWORD]]`
   * `-d` option remove the user. Throws error is any database exists owned by this user.
   * `-p [PASSWORD]` options take password from user as argument. If not passed in argument, password is prompted.
 * CockroachDB uses postgres network driver. Hence the urls are similar postgresql url
 * Production ready
