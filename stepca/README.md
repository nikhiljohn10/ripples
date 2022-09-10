# Step Certificate Authority

| **CA URL** | https://localhost:19000 |
|--|--|
| **Version** | 2.8.1 |
| **Container** | stepca |
| **Hostname** | ca |
| **Command** | `make ca` |

## Commands

To install step-cli in host: 
```
./stepca/install.sh
```

To uninstall step-cli from host:
```
./stepca/uninstall.sh
```

To renew certificate: 
```
make <service_name>
```

The renewal will only run if certificates are already created inside service directory.
