#!/bin/bash
set -e

ENV=$1   # dev or prod

if [ "$ENV" == "dev" ]; then
  IMAGE=krsh11/react-app-dev
else
  IMAGE=krsh11/react-app-prod
fi

docker build -t $IMAGE:latest .
docker push $IMAGE:latest
