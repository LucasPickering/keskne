FROM postgres:10-alpine

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing s3cmd

COPY entrypoint.sh /entrypoint.sh
COPY create-dbs.sh /docker-entrypoint-initdb.d/
COPY crontab /etc/crontab
COPY backup.sh /var/lib/postgresql/
COPY s3.cfg /root/.s3cfg
RUN crontab /etc/crontab

ENTRYPOINT ["/entrypoint.sh"]
CMD ["postgres"]
