FROM node:16 AS build-env
COPY . /app
WORKDIR /app
RUN make install && make build

FROM node:16 AS prod
COPY --from=build-env /app /app
WORKDIR /app
CMD ["make", "run"]
