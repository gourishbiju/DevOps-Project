#!/usr/bin/env bash
set -e
IMAGE=${1:-your_dockerhub_username/devops-demo}
TAG=${2:-latest}
docker build -t ${IMAGE}:${TAG} .
docker push ${IMAGE}:${TAG}
echo "Pushed ${IMAGE}:${TAG}"
