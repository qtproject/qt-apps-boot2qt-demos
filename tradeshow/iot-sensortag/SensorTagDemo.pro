TEMPLATE = app

QT += \
      bluetooth \
      core \
      charts \
      gui \
      network \
      qml \
      quick \
      widgets

CONFIG += c++11
DEFINES += QT_NO_FOREACH

# To overcome the bug QTBUG-58648, uncomment this define
# Needed at least for RPi3 and iMX
#CONFIG += DEPLOY_TO_FS

win32|linux|android:!qnx {
    CONFIG += BLUETOOTH_HOST
} else {
    message(Unsupported target platform)
}

# For using MQTT upload enable this config.
# This enables both, host and client mode
# CONFIG += UPDATE_TO_MQTT_BROKER

win32:!contains(CONFIG, UPDATE_TO_MQTT_BROKER) {
    WASTORAGE_PATH = $$(WASTORAGE_LOCATION)
    isEmpty(WASTORAGE_PATH): message("Location for Azure Storage libs unknown. Please specify WASTORAGE_LOCATION")
    CPPRESTSDK_PATH = $$(CPPRESTSDK_LOCATION)
    isEmpty(CPPRESTSDK_PATH): message("Location for CppRest library unknown. Please specify CPPREST_LOCATION")

    INCLUDEPATH += $$WASTORAGE_PATH/build/native/include \
                   $$WASTORAGE_PATH/build/native/include/was \
                   $$WASTORAGE_PATH/build/native/include/wascore \
                   $$CPPRESTSDK_PATH/build/native/include
    LIBS += -L$$WASTORAGE_PATH/lib/native/v140/Win32/Release
}

SOURCES += main.cpp \
    mockdataprovider.cpp \
    sensortagdataprovider.cpp \
    clouddataprovider.cpp \
    dataproviderpool.cpp \
    clouddataproviderpool.cpp \
    seriesstorage.cpp \
    mockdataproviderpool.cpp

HEADERS += \
    sensortagdataprovider.h \
    mockdataprovider.h \
    clouddataprovider.h \
    cloudservice.h \
    dataproviderpool.h \
    clouddataproviderpool.h \
    bluetoothapiconstants.h \
    seriesstorage.h \
    mockdataproviderpool.h

BLUETOOTH_HOST {
    win32 {
        !isEmpty(WASTORAGE_PATH):!isEmpty(CPPRESTSDK_LOCATION): CONFIG += UPDATE_TO_AZURE
    } else {
        CONFIG += UPDATE_TO_AZURE
    }
    DEFINES += RUNS_AS_HOST

    SOURCES += \
        sensortagdataproviderpool.cpp \
        bluetoothdataprovider.cpp \
        demodataproviderpool.cpp \
        serviceinfo.cpp \
        bluetoothdevice.cpp

    HEADERS += \
        sensortagdataproviderpool.h \
        bluetoothdataprovider.h \
        demodataproviderpool.h \
        serviceinfo.h \
        bluetoothdevice.h
}

UPDATE_TO_MQTT_BROKER {
    CONFIG -= UPDATE_TO_AZURE

    !qtHaveModule(mqtt): error("Could not find MQTT module for Qt version")
    QT += mqtt
    DEFINES += MQTT_UPLOAD

    SOURCES += mqttupdate.cpp \
               mqttdataproviderpool.cpp \
               mqttdataprovider.cpp
    HEADERS += mqttupdate.h \
               mqttdataproviderpool.h \
               mqttdataprovider.h
}

UPDATE_TO_AZURE {
    SOURCES += cloudupdate.cpp
    HEADERS += cloudupdate.h
    DEFINES += AZURE_UPLOAD
    # For Azure libs
    win32 {
        LIBS += -lwastorage
    } else {
        LIBS += -lboost_system -lcrypto -lssl -lcpprest -lazurestorage
        QMAKE_CXXFLAGS += -fpermissive
        QMAKE_CXXFLAGS += -fexceptions
    }
    QMAKE_CXXFLAGS_EXCEPTIONS_OFF =
}

RESOURCES += base.qrc

!DEPLOY_TO_FS: RESOURCES += uismall.qrc
uiVariant.files = resources/small
uiVariant.path = /opt/$${TARGET}/resources

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android-sources/AndroidManifest.xml

DEPLOY_TO_FS {
    message("Files will be deployed to the file system")
    DEFINES += DEPLOY_TO_FS

    baseFiles.files = resources/base
    baseFiles.path = /opt/$${TARGET}/resources
    INSTALLS += baseFiles uiVariant
}
