FROM google/cloud-sdk:alpine

RUN apk add --no-cache postgresql
COPY backup.sh entrypoint.sh /app/

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["crond", "-f"]
