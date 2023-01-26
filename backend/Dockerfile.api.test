FROM golang:1.19-alpine AS builder
WORKDIR /app
COPY go.mod /app/
COPY go.sum /app/
RUN go mod download
COPY ./backend ./backend
RUN go build -v -o ./backend/bin ./backend/cmd/api

FROM alpine:3.16 AS runner
COPY --from=builder ./app/backend/bin /app
CMD ["/app"]