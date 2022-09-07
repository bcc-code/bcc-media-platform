FROM gcr.io/cloudsql-docker/gce-proxy:1.30.1 AS sqlproxy

FROM alpine:3.16 AS prod
RUN apk add --no-cache bash
COPY --from=sqlproxy /cloud_sql_proxy /cloud_sql_proxy
ADD https://github.com/pressly/goose/releases/download/v2.6.0/goose-linux64 /bin/goose
COPY . /migrations
ENTRYPOINT ["/migrations/migrate.sh"]
