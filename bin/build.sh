#!/bin/bash
git checkout master
git pull --rebase
docker build -f Dockerfile.production -t casecommons/intake_api_prototype:$(git rev-parse --short HEAD) .
docker push casecommons/intake_api_prototype:$(git rev-parse --short HEAD)
