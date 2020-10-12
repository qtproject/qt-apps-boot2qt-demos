QT += quick

SOURCES += \
        main.cpp

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
