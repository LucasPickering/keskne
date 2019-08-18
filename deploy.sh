#!/bin/sh

set -e

# Make sure there's a docker host set
docker-machine active
if [ $? -ne 0 ]; then
    echo "No docker-machine set! Is this really what you meant to do?"
    exit 1
fi

docker-compose pull $@
docker-compose down
# Delete old static files
docker volume ls -q | grep '^keskne_.*-static$' | xargs docker volume rm
docker-compose up -d
