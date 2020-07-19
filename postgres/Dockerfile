FROM postgres:12-alpine

COPY entrypoint.sh /app/entrypoint.sh
COPY ./init.d/ /docker-entrypoint-initdb.d/

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["postgres"]
