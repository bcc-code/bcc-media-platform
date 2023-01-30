FROM gcr.io/cloudsql-docker/gce-proxy:1.30.1 AS sqlproxy

FROM node:16 AS prod
COPY --from=sqlproxy /cloud_sql_proxy /cloud_sql_proxy
COPY . /app
WORKDIR /app
CMD ["/bin/sh", "entrypoint.sh"]
