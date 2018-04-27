TEMPLATE = lib
CONFIG += plugin
QT += qml quick positioning charts

TARGET  = ebikedatamodelplugin

SOURCES += plugin.cpp \
    $$PWD/../socketclient.cpp \
    $$PWD/../datastore.cpp \
    $$PWD/../navigation.cpp \
    $$PWD/../mapboxsuggestions.cpp \
    $$PWD/../suggestionsmodel.cpp \
    $$PWD/../mapbox.cpp \
    $$PWD/../brightnesscontroller.cpp \
    $$PWD/../fpscounter.cpp \
    $$PWD/../tripdatamodel.cpp

HEADERS += \
    $$PWD/../socketclient.h \
    $$PWD/../datastore.h \
    $$PWD/../navigation.h \
    $$PWD/../mapboxsuggestions.h \
    $$PWD/../suggestionsmodel.h \
    $$PWD/../mapbox.h \
    $$PWD/../brightnesscontroller.h \
    $$PWD/../fpscounter.h \
    $$PWD/../tripdatamodel.h

INCLUDEPATH += $$PWD/../

pluginfiles.files += \
    qmldir \

B2QT_DEPLOYPATH = /data/user/qt/qmlplugins/DataStore
target.path += $$B2QT_DEPLOYPATH
pluginfiles.path += $$B2QT_DEPLOYPATH

INSTALLS += target pluginfiles

