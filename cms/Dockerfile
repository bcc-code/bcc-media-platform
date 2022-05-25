FROM node:16 AS build-env
COPY . /app
WORKDIR /app

RUN npm ci --omit=dev
RUN npm run build

FROM node:16 AS prod
COPY --from=build-env /app /app
WORKDIR /app
CMD ["/bin/sh", "entrypoint.sh"]
