# MySQL

| **MySQL URL** | `mysql://localhost:3306` |
| ------------- | ------------------------ |
| **Version**   | 8.0.28                   |
| **Container** | mysql                    |
| **Hostname**  | mysql                    |
| **Username**  | `root`                   |
| **Password**  | `MysqlRoot@12`           |
| **Command**   | `make mysql`             |

## Details

Database URL:

```
mysql://mysql:Mysql12345@localhost:3306/mydb
```

JDBC URL:

```
jdbc:mysql://localhost:3306/mydb?user=mysql&password=Mysql12345
```

## Adminer

| **Admin URL** | http://localhost:18000 |
| ------------- | ---------------------- |
| **Version**   | mysql                  |
| **Container** | adminer                |
| **Hostname**  | adminer                |
| **System**    | `MySQL`                |
| **Server**    | `dbMysql`              |
| **Database**  | `mydb`                 |
| **Username**  | `mysql`                |
| **Password**  | `Mysql12345`           |
