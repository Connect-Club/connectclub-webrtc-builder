# syntax = docker/dockerfile:experimental
ARG SOURCE_IMAGE_NAME
FROM $SOURCE_IMAGE_NAME

ARG PACKAGE_NAME=android

ENV SOURCE_DIR "/root/_source/$PACKAGE_NAME"
ENV BUILD_DIR "/root/_build/$PACKAGE_NAME/release"
ENV PACKAGE_DIR "/root/_package/$PACKAGE_NAME"
ENV PATCHES_DIR "/root/_patches"

COPY scripts/apply_patches.sh /root/scripts/
COPY patches/ $PATCHES_DIR/
RUN /root/scripts/apply_patches.sh $SOURCE_DIR $PATCHES_DIR $PACKAGE_NAME

COPY _build/android/ /root/_build/android

# x86
RUN cd $SOURCE_DIR/webrtc/src \
  && gn gen $BUILD_DIR/webrtc_x86 --args=' \
    target_os="android" \
    target_cpu="x86" \
    is_debug=false \
    rtc_use_h264=false \
    rtc_include_tests=false \
    rtc_build_json=true \
    use_rtti=true \
    rtc_build_examples=false \
  ' \
  && ninja -C $BUILD_DIR/webrtc_x86 \
  && mkdir -p $PACKAGE_DIR/jni/x86 \
  && cp sdk/android/AndroidManifest.xml $PACKAGE_DIR \
  && cd $BUILD_DIR/webrtc_x86 \
  && cp libjingle_peerconnection_so.so $PACKAGE_DIR/jni/x86/ \
  && cp lib.java/sdk/android/libwebrtc.jar $PACKAGE_DIR/classes.jar

# x86_64
RUN cd $SOURCE_DIR/webrtc/src \
  && gn gen $BUILD_DIR/webrtc_x86_64 --args=' \
    target_os="android" \
    target_cpu="x64" \
    is_debug=false \
    rtc_use_h264=false \
    rtc_include_tests=false \
    rtc_build_json=true \
    use_rtti=true \
    rtc_build_examples=false \
  ' \
  && ninja -C $BUILD_DIR/webrtc_x86_64 \
  && mkdir -p $PACKAGE_DIR/jni/x86_64 \
  && cp sdk/android/AndroidManifest.xml $PACKAGE_DIR \
  && cd $BUILD_DIR/webrtc_x86_64 \
  && cp libjingle_peerconnection_so.so $PACKAGE_DIR/jni/x86_64/ \
  && cp lib.java/sdk/android/libwebrtc.jar $PACKAGE_DIR/classes.jar

# # armeabi-v7a
# RUN cd $SOURCE_DIR/webrtc/src \
#   && gn gen $BUILD_DIR/webrtc_armeabi-v7a --args=' \
#     target_os="android" \
#     target_cpu="arm" \
#     is_debug=false \
#     rtc_use_h264=false \
#     rtc_include_tests=false \
#     rtc_build_json=true \
#     use_rtti=true \
#     rtc_build_examples=false \
#   ' \
#   && ninja -C $BUILD_DIR/webrtc_armeabi-v7a \
#   && mkdir -p $PACKAGE_DIR/jni/armeabi-v7a \
#   && cp sdk/android/AndroidManifest.xml $PACKAGE_DIR \
#   && cd $BUILD_DIR/webrtc_armeabi-v7a \
#   && cp libjingle_peerconnection_so.so $PACKAGE_DIR/jni/armeabi-v7a/ \
#   && cp lib.java/sdk/android/libwebrtc.jar $PACKAGE_DIR/classes.jar

# # arm64-v8a
# RUN cd $SOURCE_DIR/webrtc/src \
#   && gn gen $BUILD_DIR/webrtc_arm64-v8a --args=' \
#     target_os="android" \
#     target_cpu="arm64" \
#     is_debug=false \
#     rtc_use_h264=false \
#     rtc_include_tests=false \
#     rtc_build_json=true \
#     use_rtti=true \
#     rtc_build_examples=false \
#   ' \
#   && ninja -C $BUILD_DIR/webrtc_arm64-v8a \
#   && mkdir -p $PACKAGE_DIR/jni/arm64-v8a \
#   && cp sdk/android/AndroidManifest.xml $PACKAGE_DIR \
#   && cd $BUILD_DIR/webrtc_arm64-v8a \
#   && cp libjingle_peerconnection_so.so $PACKAGE_DIR/jni/arm64-v8a/ \
#   && cp lib.java/sdk/android/libwebrtc.jar $PACKAGE_DIR/classes.jar
