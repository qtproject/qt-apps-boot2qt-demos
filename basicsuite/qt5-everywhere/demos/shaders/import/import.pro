CXX_MODULE = qml
TARGET = shaderreader
TARGETPATH = ShaderReader
IMPORT_VERSION = 1.0

QT += quick

SOURCES = main.cpp \
          shaderfilereader.cpp \

HEADERS = shaderfilereader.h \

load(qml_plugin)
