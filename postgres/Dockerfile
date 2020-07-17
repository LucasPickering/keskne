FROM postgres:12-alpine

ENV S3CMD_VERSION 2.0.2

RUN apk add --no-cache supervisor \
    && mkdir /etc/supervisor.d/ \
    # Install s3cmd
    && wget https://github.com/s3tools/s3cmd/releases/download/v${S3CMD_VERSION}/s3cmd-${S3CMD_VERSION}.tar.gz \
    && tar xzvf s3cmd-${S3CMD_VERSION}.tar.gz \
    && rm s3cmd-${S3CMD_VERSION}.tar.gz \
    && cd s3cmd-${S3CMD_VERSION} \
    && python3 setup.py install \
    && ln -s s3cmd /usr/local/bin/

COPY entrypoint.sh /entrypoint.sh
COPY ./init.d/ /docker-entrypoint-initdb.d/
COPY postgres_cron.ini /etc/supervisor.d/
COPY crontab /etc/crontab
COPY backup.sh /var/lib/postgresql/
COPY s3.cfg /root/.s3cfg
RUN crontab /etc/crontab

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
