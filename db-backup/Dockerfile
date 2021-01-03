FROM google/cloud-sdk:alpine

RUN apk add --no-cache mongodb-tools postgresql
COPY backup.sh entrypoint.sh /app/

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["crond", "-f"]
