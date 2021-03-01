TEMPLATE = lib
CONFIG += plugin
QT += quick positioning

TARGET  = ebikedatamodelplugin
QML_MODULENAME = DataStore

SOURCES += plugin.cpp \
    socketclient.cpp \
    datastore.cpp \
    navigation.cpp \
    mapboxsuggestions.cpp \
    suggestionsmodel.cpp \
    mapbox.cpp \
    brightnesscontroller.cpp \
    fpscounter.cpp \
    tripdatamodel.cpp

HEADERS += \
    socketclient.h \
    datastore.h \
    navigation.h \
    mapboxsuggestions.h \
    suggestionsmodel.h \
    mapbox.h \
    brightnesscontroller.h \
    fpscounter.h \
    tripdatamodel.h

top_builddir=$$shadowed($$PWD/../)
include(../../shared/shared_plugin.pri)
