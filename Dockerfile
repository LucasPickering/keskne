FROM insh2102mbta/static:latest as mbta

FROM nginx:alpine

COPY nginx.conf /etc/nginx/nginx.conf
COPY sites/* /etc/nginx/conf.d/
# This is populated with links to /dev/std(out|err) by default
RUN rm /var/log/nginx/*

# Copy in static files for different sites
COPY --from=mbta /app/static /app/mbta
