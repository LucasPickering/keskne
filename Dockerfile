FROM nginx:alpine

ADD nginx.conf /etc/nginx/nginx.conf
ADD sites/* /etc/nginx/conf.d/
# This is populated with links to /dev/std(out|err) by default
RUN rm /var/log/nginx/*
