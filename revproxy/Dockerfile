FROM lucaspickering/nginx-amplify:latest

# This is populated with links to /dev/std(out|err) by default
RUN rm /var/log/nginx/*

COPY entrypoint.sh /app/entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY sites/* /etc/nginx/conf.d/

ENTRYPOINT ["/app/entrypoint.sh"]
