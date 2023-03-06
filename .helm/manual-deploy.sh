#!/bin/bash

# Deploys using helm

# This manual-deploy.sh is meant mainly for test-prod environment
#   for deployment in other environment you can deploy via identity-deployment
#   as usual.
#
# To deploy manually into test-prod:
#    .helm/manual-deploy.sh dummy-te dev latest
#

APPLICATION="db-homework"
TAG="latest"

SCRIPT_PATH=`dirname "$0"`


helm dep update .helm/chart
helm upgrade \
    ${APPLICATION} \
    ${SCRIPT_PATH}/chart \
    -f ${SCRIPT_PATH}/values.yaml \
    --set image.tag=${TAG} \
    --namespace default \
    --version ${TAG} \
    --install \
    --wait \
    --timeout 1200s
