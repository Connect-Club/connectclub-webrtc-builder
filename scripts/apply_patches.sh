#!/bin/bash

if [ $# -lt 2 ]; then
  echo "$0 <source_dir> <script_dir>"
fi

SOURCE_DIR=$1
PATCHES_DIR=$2
PACKAGE_NAME=$3

pushd $SOURCE_DIR/webrtc/src
  git reset --hard
  git clean -xdf
  
  shopt -s nullglob

  for p in $PATCHES_DIR/common/*.patch; do git apply "$p"; done
  for p in $PATCHES_DIR/common/*.diff; do git apply "$p"; done
  for p in $PATCHES_DIR/$PACKAGE_NAME/*.patch; do git apply "$p"; done
  for p in $PATCHES_DIR/$PACKAGE_NAME/*.diff; do git apply "$p"; done

  shopt -u nullglob
popd