FROM gcr.io/cloudsql-docker/gce-proxy:1.38.4 AS sqlproxy

FROM directus/directus:12.5.1 AS prod
COPY --from=sqlproxy /cloud_sql_proxy /cloud_sql_proxy
WORKDIR /directus
ENV IP_TRUST_PROXY=true
COPY ./extensions /directus/extensions/
COPY ./entrypoint.sh .
CMD ["/bin/sh", "entrypoint.sh"]
