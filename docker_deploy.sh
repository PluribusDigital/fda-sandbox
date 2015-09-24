#! /bin/bash
set -e

BUILD_TAG=$1
DOCKER_PROJECT=$2
ORG=${3-stsilabs}

# Deploy web image to Docker Hub
docker push $ORG/$DOCKER_PROJECT:$BUILD_TAG
