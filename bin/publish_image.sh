#!/bin/bash

DOCKER_ORGANIZATION="casecommons"
DOCKER_REPO="intake_api_prototype"
SHA=$(git rev-parse --short HEAD)

git checkout master
git pull --rebase
docker build -f Dockerfile.production -t "$DOCKER_ORGANIZATION"/"$DOCKER_REPO:$SHA" .

docker login --username="$DOCKER_USER" --password="$DOCKER_PASSWORD"
docker push casecommons/intake_api_prototype:"$SHA"
docker logout
