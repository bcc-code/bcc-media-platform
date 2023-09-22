FROM gcr.io/cloudsql-docker/gce-proxy:1.30.1 AS sqlproxy

FROM directus/directus:latest AS prod
COPY --from=sqlproxy /cloud_sql_proxy /cloud_sql_proxy
WORKDIR /directus
COPY ./extensions .
COPY .env .
COPY ./entrypoint.sh .
CMD ["/bin/sh", "entrypoint.sh"]
