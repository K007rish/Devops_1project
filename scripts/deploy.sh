#!/bin/bash
set -e

IMAGE=krsh11/react-app-prod

docker stop react-app || true
docker rm react-app || true

docker run -d \
  --name react-app \
  -p 80:80 \
  $IMAGE:latest
