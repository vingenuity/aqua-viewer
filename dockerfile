# Stage 1: Build AngularJS app
FROM node:12.16.2-alpine as node
WORKDIR /usr/src/app

## Installing all dependencies before code to take advantage of caching
COPY package*.json ./
RUN npm install

## Then copy the remaining source files and build
COPY . .
RUN npm run build --prod



# Stage 2: Serve built webapp
FROM nginx:1.16.1-alpine
LABEL name = "Aqua Viewer"
LABEL description = "A WebUI for AQUA Server"
LABEL maintainer = "samnyan"
LABEL vcs-url = "https://github.com/samnyan/aqua-viewer"

COPY --from=node /usr/src/app/dist/aqua-viewer /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
