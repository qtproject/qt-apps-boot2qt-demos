TEMPLATE = lib
CONFIG += plugin
QT += qml multimedia

TARGET  = camerautilsplugin

SOURCES += plugin.cpp \
           camerautils.cpp

HEADERS += camerautils.h

pluginfiles.files += \
    qmldir \

target.path += $$[QT_INSTALL_QML]/CameraUtils
pluginfiles.path += $$[QT_INSTALL_QML]/CameraUtils

INSTALLS += target pluginfiles

