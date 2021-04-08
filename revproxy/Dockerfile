FROM ghcr.io/lucaspickering/nginx-amplify

# /var/log/nginx is populated with links to /dev/std(out|err) by default
RUN rm /var/log/nginx/*; rm /etc/nginx/conf.d/*.conf

WORKDIR /app
COPY . .

ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD ["/app/cmd.sh"]
