FROM node:22.23.4
RUN mkdir -p /root/.npm && chown -R 1001:1001 "/root/.npm"
WORKDIR /app
CMD ["make", "build"]
