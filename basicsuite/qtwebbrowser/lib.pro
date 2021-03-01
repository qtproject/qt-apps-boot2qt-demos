TEMPLATE = lib
QT += qml quick
CONFIG += qt plugin

TARGET = webbrowser
QML_MODULENAME = WebBrowser

INCLUDEPATH += tqtc-qtwebbrowser/src

HEADERS += \
    tqtc-qtwebbrowser/src/appengine.h \
    tqtc-qtwebbrowser/src/touchtracker.h \
    tqtc-qtwebbrowser/src/navigationhistoryproxymodel.h

SOURCES += \
    plugin.cpp \
    tqtc-qtwebbrowser/src/appengine.cpp \
    tqtc-qtwebbrowser/src/touchtracker.cpp \
    tqtc-qtwebbrowser/src/navigationhistoryproxymodel.cpp

top_builddir=$$shadowed($$PWD)
include(../shared/shared_plugin.pri)

RESOURCES += tqtc-qtwebbrowser/src/resources.qrc
