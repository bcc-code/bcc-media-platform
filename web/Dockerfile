FROM node:22-alpine AS builder

WORKDIR /app

RUN npm install -g pnpm

COPY package.json .
COPY pnpm-lock.yaml .

RUN pnpm i --frozen-lockfile

COPY . .

RUN pnpm run build

FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/configfile.template

WORKDIR /usr/share/nginx/html
RUN rm -rf *
COPY --from=builder /app/build .

ENV PORT=8080
ENV HOST=0.0.0.0
EXPOSE 8080

CMD ["sh","-c","envsubst '$PORT' < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"]
