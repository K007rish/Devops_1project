#!/bin/bash
# Move to the directory containing docker-compose.yml
cd /var/lib/jenkins/workspace/react-app-pipeline
docker-compose down || true
docker-compose pull
docker-compose up -d