TEMPLATE = lib

# Make it easier to run the UI with qmlscene
DESTDIR = ../../Freenect

QT += quick datavisualization
CONFIG += c++11 link_pkgconfig plugin
PKGCONFIG = libusb-1.0

INCLUDEPATH += ../libfreenect/include
LIBS += -L ../libfreenect/lib -lfreenect

SOURCES += \
    plugin.cpp \
    qquickfreenectbackend.cpp \
    qquickfreenectdepthdataproxy.cpp \
    qquickfreenectvideooutput.cpp

HEADERS += \
    qquickfreenectbackend.h \
    qquickfreenectdepthdataproxy.h \
    qquickfreenectstate.h \
    qquickfreenectvideooutput.h
