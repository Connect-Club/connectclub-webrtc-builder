#!/bin/bash

cd `dirname $0`
source VERSION
SCRIPT_DIR="`pwd`"

PACKAGE_NAME=ios
SOURCE_DIR="`pwd`/_source/$PACKAGE_NAME"
BUILD_DIR="`pwd`/_build/$PACKAGE_NAME"
PACKAGE_DIR="`pwd`/_package/$PACKAGE_NAME"
PATCHES_DIR="`pwd`/patches"

set -ex

TARGET_ARCHS="arm64 x64"
TARGET_BUILD_CONFIGS="release"

export PATH="$SOURCE_DIR/depot_tools:$PATH"

./scripts/apply_patches.sh $SOURCE_DIR $PATCHES_DIR $PACKAGE_NAME

for build_config in $TARGET_BUILD_CONFIGS; do
  mkdir -p $BUILD_DIR/$build_config
done

pushd $SOURCE_DIR/webrtc/src
  pushd ./tools_webrtc/ios/
    IOS_DEPLOYMENT_TARGET=`python -c 'from build_ios_libs import IOS_DEPLOYMENT_TARGET; print(IOS_DEPLOYMENT_TARGET)'`
  popd

  for build_config in $TARGET_BUILD_CONFIGS; do
    if [ $build_config = "release" ]; then
      _is_debug="false"
    else
      _is_debug="true"
    fi

    for arch in $TARGET_ARCHS; do
      gn gen $BUILD_DIR/$build_config/${arch}_libs --args="
        target_os=\"ios\"
        target_cpu=\"$arch\"
        ios_enable_code_signing=false
        use_xcode_clang=true
        is_component_build=false
        ios_deployment_target=\"$IOS_DEPLOYMENT_TARGET\"
        rtc_libvpx_build_vp9=false
        rtc_enable_symbol_export=true
        rtc_enable_objc_symbol_export=false
        is_debug=$_is_debug
        enable_ios_bitcode=true
        enable_dsyms=true
        enable_stripping=true

        rtc_include_tests=false
        rtc_build_examples=false
        rtc_use_h264=false
        use_rtti=true
        libcxx_abi_unstable=false
      "
      ninja -C $BUILD_DIR/$build_config/${arch}_libs framework_objc
    done
  done
popd

