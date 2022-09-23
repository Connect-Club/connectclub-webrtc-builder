#!/bin/bash

cd `dirname $0`
source VERSION
SCRIPT_DIR="`pwd`"

PACKAGE_NAME=ios
SOURCE_DIR="`pwd`/_source/$PACKAGE_NAME"

set -ex

 ./scripts/get_depot_tools.sh $SOURCE_DIR
export PATH="$SOURCE_DIR/depot_tools:$PATH"

./scripts/prepare_webrtc.sh $SOURCE_DIR $WEBRTC_COMMIT
echo "target_os = [ 'ios' ]" >> $SOURCE_DIR/webrtc/.gclient
pushd $SOURCE_DIR/webrtc
  gclient sync
popd


