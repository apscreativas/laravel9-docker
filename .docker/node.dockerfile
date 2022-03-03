FROM node:16.14.0

RUN npm install -g @vue/cli

WORKDIR /var/www/html

EXPOSE 8080