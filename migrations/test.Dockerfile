FROM alpine:3.16 AS prod
RUN apk add --no-cache bash postgresql12-client
ADD https://github.com/pressly/goose/releases/download/v3.7.0/goose_linux_x86_64 /bin/goose
RUN chmod +x /bin/goose
WORKDIR /migrations
RUN echo "OK"
COPY . .
