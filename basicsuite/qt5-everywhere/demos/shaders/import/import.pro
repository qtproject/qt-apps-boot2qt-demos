TEMPLATE = lib
CONFIG += plugin

TARGET = shaderreader

QT += qml quick

SOURCES = main.cpp \
          shaderfilereader.cpp \

HEADERS = shaderfilereader.h \

pluginfiles.files += \
    qmldir \

B2QT_DEPLOYPATH = /data/user/qt/qmlplugins/ShaderReader
target.path += $$B2QT_DEPLOYPATH
pluginfiles.path += $$B2QT_DEPLOYPATH

INSTALLS += target pluginfiles
