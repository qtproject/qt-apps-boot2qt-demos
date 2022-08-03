QT += quick quickcontrols2

SOURCES += \
        settingsmanager.cpp \
        main.cpp \
        qtbuttonimageprovider.cpp

HEADERS += \
        settingsmanager.h \
        qtbuttonimageprovider.h

RESOURCES += qml.qrc

OTHER_FILES += \
        *.qml \
        imports/StartupScreen/* \
        imports/StartupScreen/designer/* \
        assets/* \
        fonts/*

QML_IMPORT_PATH = imports

target.path = /usr/bin
INSTALLS += target
