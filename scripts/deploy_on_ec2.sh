#!/usr/bin/env bash
set -e
EC2_HOST=$1
IMAGE=$2
SSH_KEY_PATH=$3

ssh -o StrictHostKeyChecking=no -i ${SSH_KEY_PATH} ubuntu@${EC2_HOST} <<EOF
  docker pull ${IMAGE}
  docker stop devops-demo || true
  docker rm devops-demo || true
  docker run -d --name devops-demo -p 80:5000 ${IMAGE}
EOF
