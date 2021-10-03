#!/bin/bash

bash ./setup_env.sh

WORKING_DIR="$(dirname $(readlink -f $0))"
export WORKING_DIR="${WORKING_DIR/\/Deployment*/}"
export CONF_FILE="${WORKING_DIR}/Deployment/scripts/variables.conf"

set -a
source ${CONF_FILE}
set +a

cd ${WORKING_DIR}/Deployment/terraform
REPO_URL="$(terraform output ecr_repo)"
AWS_ACCOUNT_ID="$(terraform output aws_account_id)"

cd ${WORKING_DIR}
# Set tag is the current date time in second format
IMAGE_TAG="$(date +%s)"

# Login to ECR
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

docker build . -t ${REPO_URL}/${IMAGE_NAME}:${IMAGE_TAG}
docker push ${REPO_URL}/${IMAGE_NAME}:${IMAGE_TAG}