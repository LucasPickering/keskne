#!/bin/sh

# Make sure there's a docker host set
docker-machine active > /dev/null 2> /dev/null
if [ $? -ne 0 ]; then
    echo "No docker-machine set! Is this really what you meant to do?"
    exit 1
fi

set -ex

docker-compose -f docker-stack.yml pull $@
docker stack deploy -c docker-stack.yml keskne
