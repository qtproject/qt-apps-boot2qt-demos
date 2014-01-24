CXX_MODULE = qml
TARGET = sensorexplorer
TARGETPATH = Explorer
IMPORT_VERSION = 1.0

QT += qml sensors

SOURCES = main.cpp \
          explorer.cpp \
          sensoritem.cpp \
          propertyinfo.cpp \

HEADERS = explorer.h \
          sensoritem.h \
          propertyinfo.h \

load(qml_plugin)
