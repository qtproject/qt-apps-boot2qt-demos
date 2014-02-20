TEMPLATE = lib
CONFIG += plugin

TARGET = sensorexplorer

QT += qml sensors

SOURCES = main.cpp \
          explorer.cpp \
          sensoritem.cpp \
          propertyinfo.cpp \

HEADERS = explorer.h \
          sensoritem.h \
          propertyinfo.h \

pluginfiles.files += \
    qmldir \

B2QT_DEPLOYPATH = /data/user/qt/qmlplugins/Explorer
target.path += $$B2QT_DEPLOYPATH
pluginfiles.path += $$B2QT_DEPLOYPATH

INSTALLS += target pluginfiles
