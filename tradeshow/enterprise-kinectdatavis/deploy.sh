#!/bin/sh

B2QT_DEPLOYPATH=/data/user/qt/enterprise-kinectdatavis
B2QT_PLUGINDEPLOYPATH=/data/user/qt/qmlplugins/Freenect

adb push Freenect $B2QT_PLUGINDEPLOYPATH

adb shell mkdir -p $B2QT_DEPLOYPATH
find -name "*.qml" -exec adb push {} $B2QT_DEPLOYPATH/ \;
find -name "*.js" -exec adb push {} $B2QT_DEPLOYPATH/ \;
adb push title.txt $B2QT_DEPLOYPATH/
adb push description.txt $B2QT_DEPLOYPATH/
adb push preview_l.jpg $B2QT_DEPLOYPATH/
adb push handle.png $B2QT_DEPLOYPATH/

adb push src/libfreenect/platform/linux/udev/51-kinect.rules /etc/udev/rules.d/51-demo-kinect.rules
