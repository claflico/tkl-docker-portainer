#!/bin/bash -e
# Loads portainer image and starts portainer

IMAGE="portainer/portainer-ce"
IMGTAR="portainer.tar"
VOL="portainer_data"
HUB_TEST=$(curl -k -sS -m 5 -L https://hub.docker.com/v2/repositories/${IMAGE}/tags/latest | grep digest | wc -l)
IMG_TEST=$(docker images | grep portainer/portainer-ce | wc -l)
PS_TEST=$(docker ps -a | grep $IMAGE | wc -l)
VOL_TEST=$(docker volume list | grep ${VOL} | wc -l)

function load_image() {
  if [[ $HUB_TEST -eq 1 ]]; then
    echo "Pulling latest Portainer image from the internet"
    docker pull $IMAGE:latest
  else
    echo "Loading included Portainer image"
    gunzip /$IMGTAR.gz
    docker load -i /$IMGTAR
  fi
}

function create_volume() {
  if [[ $VOL_TEST -eq 0 ]]; then
    echo "Creating docker volume for portainer data"
    docker volume create portainer_data
  fi
}

function docker_run() {
  echo "Starting Portainer container"
  docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v $VOL:/data $IMAGE
}

if [[ $IMG_TEST -eq 0 ]]; then
  load_image
fi
create_volume
if [[ $PS_TEST -eq 0 ]]; then
  docker_run
fi
