#!/usr/bin/env sh

docker exec roach ./cockroach init --insecure
cat << EOF

Web UI:       http://localhost:20000
SQL URL:      postgresql://root@localhost:26257/defaultdb?sslmode=disable
SQL (JDBC):   jdbc:postgresql://localhost:26257/defaultdb?sslmode=disable&user=root

EOF
