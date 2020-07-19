FROM python:3-alpine

ENV S3CMD_VERSION 2.0.2

RUN apk add --no-cache postgresql && \
    pip install s3cmd

COPY entrypoint.sh backup.sh /app/
COPY crontab /etc/crontab
COPY s3.cfg /root/.s3cfg
RUN crontab /etc/crontab

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["crond", "-f"]
