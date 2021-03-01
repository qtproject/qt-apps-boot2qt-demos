TEMPLATE = lib
CONFIG += plugin
QT += qml multimedia

TARGET  = camerautilsplugin
QML_MODULENAME = CameraUtils

SOURCES += plugin.cpp \
           camerautils.cpp

HEADERS += camerautils.h

top_builddir=$$shadowed($$PWD/../)
include(../../shared/shared_plugin.pri)
