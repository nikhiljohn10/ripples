# Monitoring
    
## Grafana

| **Web UI** | http://localhost:30000 |
|--|--|
| **Version** | 9.1.2 (oss) |
| **Hostname** | grafana |
| **Username** | `admin` |
| **Password** | `Grafana@1234` |
| **Command** | `make monitor` |

## Prometheus

Configuration file: [configs/prometheus.yml](configs/prometheus.yml)

| Name | Host | Version |
|--|--|--|
| Prometheus | prometheus:9090 | v2.38.0 |
| Node Exporter | node-exporter:9100 | v1.3.1 |

The `node-exporter` is used as data sorce
