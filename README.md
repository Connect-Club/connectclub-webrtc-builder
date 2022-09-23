# webrtc-builder M92 Release

## Build command
 
``` sh
make ios-m92
```

# Custom webrtc repo

To download original repo first call build command.
WebRTC sources will be in `build/ios-m92/src` folder.

**WARNING!** To get custom repo version as used right now in Connect-Club, you must apply patch `patch/0001-Mute-Input-and-bypass-voice.patch`. Patch should be applied to repo at path `build/ios-m92/src`.

When you done editing webrtc sources do not forget to generate your own patch and commit it in `webrtc-builder` repo `patch` folder.

# Build Instructions

## Build iOS Framework

1. In `config/ios-m92/CONFIG` set **IOS_ARCH="x64"** for phones or **IOS_ARCH="arm64"** for simulator
2. Build
3. Copy output **WebRTC.framework** from `build` folder to your place

## Make iOS Xcframework

1. Build iOS Framework for **arm64**
2. Build iOS Framework for **x64**

Place these two frameworks in one folder and put in subfolders `ios_arm64` `ios_x64` (For example). And create subfolder `ios_xcframework`.

In this main folder call:

``` sh
xcodebuild -create-xcframework \
    -framework ios_arm64/WebRTC.framework \
    -framework ios_x64/WebRTC.framework \
    -output ios_xcframework/WebRTC.xcframework
```
        
Output WebRTC.xcframework ready to be replaced in project `connect-reactnative/ios/JitsiWebRTC/jitsi-webrtc/WebRTC`
