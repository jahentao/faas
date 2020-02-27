#!/bin/sh
set -e

export dockerfile="Dockerfile"
export arch=$(uname -m)

export eTAG="latest-dev"

if [ "$arch" = "armv7l" ] ; then
   dockerfile="Dockerfile.armhf"
   eTAG="latest-armhf-dev"
fi

echo "$1"
if [ "$1" ] ; then
  eTAG=$1
  if [ "$arch" = "armv7l" ] ; then
    eTAG="$1-armhf"
  fi
fi

NS=jahentao

echo Building $NS/gateway:$eTAG

GIT_COMMIT_MESSAGE=$(git log -1 --pretty=%B 2>&1 | head -n 1)
GIT_COMMIT_SHA=$(git rev-list -1 HEAD)
VERSION=$(git describe --all --exact-match `git rev-parse HEAD` | grep tags | sed 's/tags\///' || echo dev)

docker build --build-arg https_proxy=$https_proxy --build-arg http_proxy=$http_proxy \
  -t $NS/gateway:$eTAG . -f $dockerfile --no-cache
