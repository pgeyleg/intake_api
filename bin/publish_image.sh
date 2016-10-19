#!/bin/bash

DOCKER_ORGANIZATION="casecommons"
DOCKER_REPO="intake_api_prototype"
SHA=$(git rev-parse --short HEAD)

if [ "$FROM_JENKINS" != "yes" ]; then
  echo "FROM_JENKINS = '" "$FROM_JENKINS" "'"
  git checkout master
  git pull --rebase
fi

docker build -f Dockerfile.production -t "$DOCKER_ORGANIZATION"/"$DOCKER_REPO:$SHA" .

docker login --username="$DOCKER_USER" --password="$DOCKER_PASSWORD"
docker push cwds/intake_api_prototype:"$SHA"
docker logout
