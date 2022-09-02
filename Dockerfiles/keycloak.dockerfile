FROM quay.io/keycloak/keycloak:latest as builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_FEATURES=token-exchange
ENV KC_DB=postgres

# Install custom providers
RUN curl -sL https://github.com/aerogear/keycloak-metrics-spi/releases/download/2.5.3/keycloak-metrics-spi-2.5.3.jar -o /opt/keycloak/providers/keycloak-metrics-spi-2.5.3.jar
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak

# for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass KeyCloakPassW0rd -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore

ENV KC_DB_USERNAME=admin
ENV KC_DB_PASSWORD=Postgres1234
ENV KC_DB_URL=jdbc:postgresql://postgres:5432/keycloak
ENV KC_HOSTNAME=localhost
ENV KC_HTTPS_KEY_STORE_FILE=/opt/keycloak/conf/server.keystore
ENV KC_HTTPS_KEY_STORE_PASSWORD=KeyCloakPassW0rd

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
