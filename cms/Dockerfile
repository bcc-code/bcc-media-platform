FROM gcr.io/cloudsql-docker/gce-proxy:1.30.1 AS sqlproxy

FROM node:16 AS build-env
COPY ./cms /app
WORKDIR /app
RUN make install && make build

FROM node:16 AS prod
COPY --from=build-env /app /app
COPY --from=sqlproxy /cloud_sql_proxy /cloud_sql_proxy
WORKDIR /app
CMD ["/bin/sh", "entrypoint.sh"]
