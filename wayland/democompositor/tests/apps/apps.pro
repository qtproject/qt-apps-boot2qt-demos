TARGET = tst_apps
QT = testlib
CONFIG += testcase

INCLUDEPATH += ../../apps

HEADERS += \
    ../../apps/appentry.h

SOURCES += \
    ../../apps/appentry.cpp \
    ../../apps/appparser.cpp

SOURCES += tst_appparser.cpp
RESOURCES += apps.qrc
