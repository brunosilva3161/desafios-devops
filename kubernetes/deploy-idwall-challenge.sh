#!/bin/bash

# Esse script foi homologado para funcionar no MasOS Bigsur utilizando o Kubernetes instalado em um Docker for Mac.

# Implementado cores nos avisos.

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

NAMESPACE="production"
REPLICAS="3"
NODE_APP_VERSION="1.0.0"
HTTP_PORT="80"
CANDIDATE_NAME="Uiatamara"
HTTP_ADDRESS="idwall.challenge.k8s"

echo "${GREEN}Deploying the challenge application into the Kubernetes.${RESET}"
helm install --create-namespace --namespace ${NAMESPACE} --set replicas=${REPLICAS},deployment.version=${NODE_APP_VERSION},service.port=${HTTP_PORT},node_app.name="${CANDIDATE_NAME}",node_app.address=${HTTP_ADDRESS} idwall-challenge $(pwd)/idwall-challenge

if [ $? != 0 ]; then
    echo "${YELLOW}Already exists a deployment running with the same name, we will upgrade the actual deployment.${RESET}"
    helm upgrade --create-namespace --namespace ${NAMESPACE} --set replicas=${REPLICAS},deployment.version=${NODE_APP_VERSION},service.port=${HTTP_PORT},node_app.name="${CANDIDATE_NAME}",node_app.address=${HTTP_ADDRESS} idwall-challenge $(pwd)/idwall-challenge
fi

if [ $? != 0 ]; then
    echo "${RED}An error occurred when trying to create the deployment with Helm.${RESET}"
else
    echo "${GREEN}Deployment completed.${RESET}"
fi
