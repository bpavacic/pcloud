#!/bin/bash

ROOT=$(pwd)
ROOT=${ROOT%/pcloud*}/pcloud

k3d cluster create pcloud-dev \
    --servers=1 \
    --k3s-server-arg="--disable=traefik" \
    --port="8080:80@loadbalancer" \
    --port="30500:30500@server[0]"
k3d kubeconfig merge pcloud-dev --switch-context

# Traefik
helm repo add traefik https://containous.github.io/traefik-helm-chart
helm repo update
helm --namespace=traefik install --create-namespace traefik traefik/traefik \
     --set additionalArguments="{--providers.kubernetesingress,--global.checknewversion=true}" \
     --set ports.traefik.expose=True

# Container Registry
## You ca build and push images from host machine to lcoal dev environment using:
##  docker build --tag=localhost:30500/foo/bar:latest .
##  docker push pcloud-localhost:30500/foo/bar:latest
kubectl apply -f $ROOT/apps/container-registry/install.yaml
echo "Waiting for Container Registry to start"
sleep 2
kubectl -n container-registry wait --timeout=-1s --for=condition=Ready pod/registry-0
