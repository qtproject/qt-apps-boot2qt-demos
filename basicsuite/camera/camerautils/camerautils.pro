TEMPLATE = lib
CONFIG += plugin
QT += qml multimedia

TARGET  = camerautilsplugin

SOURCES += plugin.cpp \
           camerautils.cpp

HEADERS += camerautils.h

pluginfiles.files += \
    qmldir \

B2QT_DEPLOYPATH = /data/user/qt/qmlplugins/CameraUtils
target.path += $$B2QT_DEPLOYPATH
pluginfiles.path += $$B2QT_DEPLOYPATH

INSTALLS += target pluginfiles

