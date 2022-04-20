FROM nginx:alpine

# /var/log/nginx is populated with links to /dev/std(out|err) by default
RUN rm /var/log/nginx/*; rm /etc/nginx/conf.d/*.conf

WORKDIR /app
COPY . .
