FROM node:8

LABEL maintainer="Thomas Talbot <thomas.talbot@zephyr-web.fr>"

COPY entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

WORKDIR /app

EXPOSE 8080
ENTRYPOINT ["entrypoint"]
CMD ["/app/node_modules/.bin/webpack-dev-server", "--hot", "--env.dev"]
