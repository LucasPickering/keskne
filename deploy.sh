#!/bin/bash

set -ex
env $(cat .env | grep ^[A-Z] | xargs) docker stack deploy -c docker-stack.yml keskne
