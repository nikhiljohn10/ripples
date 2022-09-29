# PostgreSQL

| **PG URL**    | `postgresql://localhost:5432` |
| ------------- | ----------------------------- |
| **Version**   | 14.5                          |
| **Container** | postgres                      |
| **Hostname**  | postgres                      |
| **Username**  | `admin`                       |
| **Password**  | `Postgres1234`                |
| **Command**   | `make postgres`               |

## Details

Database URL:

```
postgresql://admin:Postgres1234@localhost:5432/keycloak
```

JDBC URL:

```
jdbc:postgresql://localhost:5432/keycloak?user=admin&password=Postgres1234
```

## PG Admin

| **Admin URL** | http://localhost:50000 |
| ------------- | ---------------------- |
| **Version**   | 6.14                   |
| **Container** | pgadmin                |
| **Hostname**  | pgadmin                |
| **Email**     | `admin@pgadmin.org`    |
| **Password**  | `PGAdmin@1234`         |

## Load Test

```
pgbench -U admin -h localhost -p 5432 -i -s 50 test
pgbench -U admin -h localhost -p 5432 -c 10 -j 2 -t 10000 test
```
