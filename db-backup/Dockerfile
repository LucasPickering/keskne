# TODO get a much smaller docker image
FROM google/cloud-sdk:alpine

RUN apk add --no-cache mongodb-tools postgresql-client
COPY backup.sh /app/

CMD ["/app/backup.sh"]
