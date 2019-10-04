#!/bin/bash

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout privkey.key -out fullchain.pem
# Copy the certs into the keskne-certs volume
docker run -d --rm --name certs -v keskne_keskne-certs:/app/certs alpine tail -f /dev/null
docker cp privkey.key certs:/app/certs/
docker cp fullchain.pem certs:/app/certs/
docker stop certs
