FROM cockroachdb/cockroach:v22.1.6

WORKDIR /cockroach/

COPY entrypoint.sh /cockroach/entrypoint.sh

RUN mkdir -p certs/ && \
cockroach cert create-ca \
--certs-dir=certs/ \
--ca-key=certs/ca.key && \
cockroach cert create-client root \
--certs-dir=certs/ \
--ca-key=certs/ca.key

ENTRYPOINT [ "/cockroach/entrypoint.sh" ]