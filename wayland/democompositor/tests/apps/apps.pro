TARGET = tst_apps
QT = testlib
CONFIG += testcase

INCLUDEPATH += ../../apps

SOURCES += \
    ../../apps/appentry.cpp \
    ../../apps/appparser.cpp

SOURCES += tst_appparser.cpp
RESOURCES += apps.qrc
