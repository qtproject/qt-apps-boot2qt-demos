TEMPLATE = lib
TARGET = webbrowser
QT += qml quick
CONFIG += qt plugin

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

pluginfiles.files += \
    qmldir

RESOURCES += tqtc-qtwebbrowser/src/resources.qrc

B2QT_DEPLOYPATH = /data/user/qt/qmlplugins/WebBrowser

target.path = $$B2QT_DEPLOYPATH
pluginfiles.path = $$B2QT_DEPLOYPATH

INSTALLS += target pluginfiles
