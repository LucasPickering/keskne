FROM insh2102mbta/static:latest as mbta

FROM nginx:alpine

# This is populated with links to /dev/std(out|err) by default
RUN rm /var/log/nginx/*

# nginx config
COPY nginx.conf /etc/nginx/nginx.conf
COPY sites/* /etc/nginx/conf.d/

# Copy in static files for different sites
COPY --from=mbta /app/static /app/mbta
