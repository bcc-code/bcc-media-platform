FROM node:16
RUN chown -R 1001:1001 "/root/.npm"
WORKDIR /app
CMD ["make", "build"]
