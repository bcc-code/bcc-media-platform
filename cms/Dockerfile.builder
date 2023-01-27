FROM node:16
WORKDIR /app
RUN ls
RUN make build
