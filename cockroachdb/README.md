# CockroachDB 3-Node Cluster

| **Web UI** | https://localhost:20000 |
|--|--|
| **Version** | v22.1.6 |
| **Container** | roach |
| **Hostname** | roach |
| **Username** | `roach` |
| **Password** | `Cockroach123` |
| **DB URL** | `postgresql://localhost:26257/exampledb?sslmode=verify-full&options=--cluster%3Droach-intrusion` |
| **Command** | `make roach` |

## Details

| Node name | Cluster Type | Container |
|--|--|--|
| roach | Primary | roach |
| roach1 | Secondary | roach-1 |
| roach2 | Secondary | roach-2 |

 Database URL: 
 ```
 postgresql://root@roach:26257/defaultdb?sslcert=certs%2Fclient.root.crt&sslkey=certs%2Fclient.root.key&sslmode=verify-full&sslrootcert=certs%2Fca.crt
 ```
 
 JDBC URL: 
 ```
 jdbc:postgresql://roach:26257/defaultdb?sslcert=certs%2Fclient.root.crt&sslkey=certs%2Fclient.root.key&sslmode=verify-full&sslrootcert=certs%2Fca.crt&user=root
 ```
  * Cluster Init script: [scripts/roach_init.sh](scripts/roach_init.sh)
    * Use option `-f` to start a fresh container
  * New user script: [scripts/roach_new_user.sh](scripts/roach_new_user.sh)
    * Usage: `scripts/roach_new_user.sh [SQL_USER] [-d|-p [PASSWORD]]`
    * `-d` option remove the user. Throws error is any database exists owned by this user.
    * `-p [PASSWORD]` options take password from user as argument. If not passed in argument, password is prompted.
  * CockroachDB uses postgres network driver. Hence the urls are similar to postgresql url.
  * CockroachDB cluster have its own CA tools and certificates inside the built image.
