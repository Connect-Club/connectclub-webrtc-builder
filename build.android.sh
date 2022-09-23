#!/bin/bash

cd `dirname $0`
source VERSION
SCRIPT_DIR="`pwd`"

PACKAGE_NAME=android
BUILD_DIR="`pwd`/_build"

set -ex

mkdir -p $BUILD_DIR/android

SOURCE_IMAGE_NAME=webrtc/$PACKAGE_NAME:m${WEBRTC_VERSION}-source

IMAGE_NAME=webrtc/$PACKAGE_NAME:m${WEBRTC_VERSION}
docker build \
  -t $IMAGE_NAME \
  --build-arg SOURCE_IMAGE_NAME=$SOURCE_IMAGE_NAME \
  -f $PACKAGE_NAME/Dockerfile \
  .

CONTAINER_ID=`docker container create $IMAGE_NAME`
rm -R -f $BUILD_DIR/android
docker container cp $CONTAINER_ID:/root/_build/android $BUILD_DIR
docker container rm $CONTAINER_ID
docker image rm $IMAGE_NAME
