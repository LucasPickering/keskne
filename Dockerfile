FROM nginx:alpine

ADD nginx.conf /etc/nginx/nginx.conf
# This is populated with links to /dev/std(out|err) by default
RUN rm /var/log/nginx/*
