TEMPLATE = app

# Control KNX board with the demo
CONFIG += KNX_BOARD ALEXA_WEMO
#CONFIG += ALEXA_WEMO

KNX_BOARD {
    requires(qtHaveModule(knx))
    requires(qtHaveModule(network))
    DEFINES += KNX_BACKEND

    QT += knx
    CONFIG += c++11
}

QT += qml quick

target.path = $$[QT_INSTALL_EXAMPLES]/studio3d/$$TARGET
INSTALLS += target

SOURCES += main.cpp \
    housemodel.cpp

HEADERS += \
    housemodel.h

RESOURCES += HomeAutom.qrc

OTHER_FILES += qml/HomeAutom/*

RC_ICONS += HomeAutom.ico

KNX_BOARD {
    SOURCES += \
        qmlknxdemo.cpp \
        etsdevelopmentboard.cpp \
        demodatapoint.cpp

    HEADERS += \
        qmlknxdemo.h \
        demodatapoint.h \
        utils.h \
        etsdevelopmentboard.h
}

ALEXA_WEMO {
    SOURCES += \
        qupnpservice.cpp \
        qupnprootdevice.cpp \
        qvirtualbelkinwemo.cpp \
        qminimalhttpserver.cpp

    HEADERS += \
        qupnpservice.h \
        qupnprootdevice.h \
        qvirtualbelkinwemo.h \
        qminimalhttpserver.h

    QT += xml
}

QML_IMPORT_PATH = $$PWD/qml/imports

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

#ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
