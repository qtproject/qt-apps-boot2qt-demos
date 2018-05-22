QT -= gui
QT += network

CONFIG += c++11 console
CONFIG -= app_bundle

QMAKE_CXXFLAGS += -Os

if(linux*imx7*g++) {
    message("Building for IMX7")

    #Use FLTO for better size, other for better speed
    #(both needs to be used with proper Qt libs)

    if(linux-ffopt-imx7-g++) {
    }
    else {
        DEFINES += USE_FLTO
    }

    contains(DEFINES,USE_FLTO) {
        message("Building with FLTO")
        QMAKE_CXXFLAGS += -flto
        QMAKE_LFLAGS += -flto
    } else {
        message("Building with Sections Optimization")
        QMAKE_CXXFLAGS += -ffunction-sections -fdata-sections
        QMAKE_LFLAGS += -Wl,--gc-sections
        #QMAKE_LFLAGS += -Wl,--print-gc-sections
    }
}

SOURCES += main.cpp \
    socketserver.cpp \
    socketclient.cpp \
    abstractdatasource.cpp \
    mockdatasource.cpp \
    tripdata.cpp \
    unixsignalhandler.cpp

HEADERS += \
    socketserver.h \
    socketclient.h \
    abstractdatasource.h \
    mockdatasource.h \
    tripdata.h \
    unixsignalhandler.h

target.path += /data/user/qt/$$TARGET
INSTALLS += target
