FROM gcr.io/cloudsql-docker/gce-proxy:1.30.1 AS sqlproxy

FROM directus/directus:10.7.2 AS prod
COPY --from=sqlproxy /cloud_sql_proxy /cloud_sql_proxy
WORKDIR /directus
COPY ./extensions /directus/extensions/
COPY ./entrypoint.sh .
CMD ["/bin/sh", "entrypoint.sh"]
