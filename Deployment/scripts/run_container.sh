#!/bin/bash

bash ./setup_env.sh

WORKING_DIR="$(dirname $(readlink -f $0))"
export WORKING_DIR="${WORKING_DIR/\/Deployment*/}"
export CONF_FILE="${WORKING_DIR}/Deployment/scripts/variables.conf"

set -a
source ${CONF_FILE}
set +a

cd ${WORKING_DIR}

ID_IMAGE="$(docker images | awk "/${IMAGE_NAME}/ { getline; print \$3 }")"

docker run --rm --name $CONTAINER_NAME -p ${CONTAINER_PORT}:${CONTAINER_PORT} -h localhost $ID_IMAGE