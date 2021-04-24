#!/bin/bash

# Esse script foi homologado para funcionar no MasOS Bigsur utilizando o Kubernetes instalado em um Docker for Mac.

NAMESPACE="production"
REPLICAS="3"
NODE_APP_VERSION="1.0.0"
HTTP_PORT="80"
CANDIDATE_NAME="Bruno Silva"
HTTP_ADDRESS="prod-idwall.challenge.k8s"

echo "Building the challenge docker container image."
docker build -t challenge-app:${NODE_APP_VERSION} -f Dockerfile $(pwd)

echo "Installing de ingress-nginx controller."
# Instala o controlador do ingress do Nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.45.0/deploy/static/provider/cloud/deploy.yaml

echo "Installing Helm."
brew install helm

echo "Deploying the challenge application in to the Kubernetes."
helm install --create-namespace --namespace ${NAMESPACE} --set replicas={REPLICAS},deployment.version=${NODE_APP_VERSION},service.port=${HTTP_PORT},node_app.name=${CANDIDATE_NAME},node_app.address=${HTTP_ADDRESS} prod-challenge ./idwall-challenge

if [ $? != 0 ]; then
    helm upgrade --create-namespace --namespace ${NAMESPACE} --set replicas={REPLICAS},deployment.version=${NODE_APP_VERSION},service.port=${HTTP_PORT},node_app.name=${CANDIDATE_NAME},node_app.address=${HTTP_ADDRESS} prod-challenge ./idwall-challenge
fi

if [ $? != 0 ]; then
    echo "An error occurred when trying to create the deployment with Helm."
fi