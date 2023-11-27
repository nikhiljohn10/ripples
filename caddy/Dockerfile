FROM caddy:2.5.2

WORKDIR /caddy

RUN apk update && apk upgrade && apk add curl nss-tools wget step-cli bind-tools

COPY ./certs /certs
RUN step certificate install --all /certs/root_ca.crt

ENTRYPOINT [ "caddy", "run", "--watch" ]
