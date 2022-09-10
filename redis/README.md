# Redis

| **Redis URL** | `redis://localhost:6379` |
|--|--|
| **Version** | `7.0.4` |
| **Hostname** | `redis` |
| **Username** | `default` |
| **Password** | `Redis@123456` |
| **Command** | `make redis` |

## Redis Insight

| **Web UI** | http://localhost:40000 |
|--|--|
| **Version** | `1.13.0` |
| **Hostname** | `redisinsight` |

## Troubleshoot

If your container might use more than the RAM given, use the following dockerfile:

```Dockerfile
FROM redis:7.0.4

WORKDIR /data

RUN sysctl vm.overcommit_memory=1

VOLUME ["/data"]

CMD ["redis-server", "/etc/redis/redis.conf"]

EXPOSE 6379
```
