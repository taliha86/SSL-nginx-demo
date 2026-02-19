FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY server.crt /etc/nginx/ssl/server.crt
COPY server.key /etc/nginx/ssl/server.key
