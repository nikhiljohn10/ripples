# Docker Registry

| **Registry URL** | localhost:21000 |
|--|--|
| **Version** | 2.8.1 |
| **Container** | registry |
| **Hostname** | registry |
| **Username** | `captain` |
| **Password** | `Registry@123` |
| **Command** | `make registry` |

## Docker commands

|  |  |
|--|--|
| Login | `docker login localhost:21000` |
| Logout | `docker logout localhost:21000` |

## Init Script

| Option | Description |
|--|--|
| `-f` | Remove old containers and volumes |
| `--oauth` | Uses keycloak oauth to authenticate user(Require extra steps) |
| `--prod` | (Under development) |

## Keycloak configuration

 1. Start keycloak by `make keycloak`
 2. Open https://localhost:60443
 3. Login as `admin` with password `Keycloak@123`
 4. Create new realm
 5. Create new client `registry-client` with client type `docker-v2`
 6. Create new user `captain` with password `Registry@123`
 7. Copy Realm signing certificate(RS256) value
 8. Paste it while running `make registry`
 9. To login to docker registry, run `make docker-login`

## Troubleshoot

### SSL realated error

Resolution: Remove `certs` folder and run `make registry` again

### Want to run without keycloak

Resolution: Edit `Makefile`'s `registry` command and remove `--oauth` option. Then it will use htpasswd to authenticate.
