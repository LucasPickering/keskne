# Bring in all the static assets we'll need
FROM lucaspickering/mbta-static:latest as mbta-static
FROM lucaspickering/rps-static:latest as rps-static
FROM lucaspickering/nginx-amplify:latest

# This is populated with links to /dev/std(out|err) by default
RUN rm /var/log/nginx/*

COPY entrypoint.sh /app/entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY sites/* /etc/nginx/conf.d/
COPY --from=mbta-static /app/static /app/mbta
COPY --from=rps-static /app/static /app/rps

ENTRYPOINT ["/app/entrypoint.sh"]
