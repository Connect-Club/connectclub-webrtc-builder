#!/bin/bash

cd `dirname $0`
source VERSION
SCRIPT_DIR="`pwd`"

PACKAGE_NAME=android

set -ex

SOURCE_IMAGE_NAME=webrtc/$PACKAGE_NAME:m${WEBRTC_VERSION}-source
if [[ "$(docker images -q $SOURCE_IMAGE_NAME 2> /dev/null)" == "" ]]; then
  _name=WebrtcBuildVersion
  _branch="M`echo $WEBRTC_VERSION | cut -d'.' -f1`"
  _commit="`echo $WEBRTC_VERSION | cut -d'.' -f3`"
  _revision=$WEBRTC_COMMIT
  _maint="`echo $WEBRTC_BUILD_VERSION | cut -d'.' -f4`"
  ./scripts/generate_version_android.sh "$_name" "$_branch" "$_commit" "$_revision" "$_maint" > android/$_name.java
  cat android/$_name.java

  docker build \
    -t $SOURCE_IMAGE_NAME \
    --build-arg WEBRTC_COMMIT=$WEBRTC_COMMIT \
    -f $PACKAGE_NAME/Dockerfile.source \
    .
  
  rm android/$_name.java
fi
