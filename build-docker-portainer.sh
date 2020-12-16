#!/bin/bash -e

IMAGE="portainer/portainer-ce:latest"

docker pull $IMAGE
echo "Saving ${IMAGE} to docker/portainer.tar.gz"
docker save $IMAGE | gzip > docker/portainer.tar.gz
cp docker/portainer.tar.gz overlay/

deck -D build/root.sandbox
make clean
make

rm -rf overlay/portainer.tar.gz
