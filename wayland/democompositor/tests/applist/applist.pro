TARGET = tst_applistmodel
QT = testlib
CONFIG += testcase

INCLUDEPATH += ../../apps

HEADERS += \
    ../../apps/appentry.h \
    ../../apps/applistmodel.h

SOURCES += \
    ../../apps/appentry.cpp \
    ../../apps/appparser.cpp \
    ../../apps/applistmodel.cpp

SOURCES += tst_applistmodel.cpp
RESOURCES += applist.qrc
