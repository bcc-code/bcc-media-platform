FROM gcr.io/cloudsql-docker/gce-proxy:1.30.1 AS sqlproxy

FROM node:16 AS build-env
COPY . /app
WORKDIR /app
RUN npm ci
RUN npm run build

FROM node:16 AS prod
COPY --from=sqlproxy /cloud_sql_proxy /cloud_sql_proxy
COPY --from=build-env /app /app
WORKDIR /app
CMD ["/bin/sh", "entrypoint.sh"]
