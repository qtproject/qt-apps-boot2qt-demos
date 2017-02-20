TEMPLATE = app

QT += 3dcore 3drender 3dinput 3dquick 3dlogic core gui qml quick 3dquickextras widgets
QT += bluetooth network charts
CONFIG += c++11
DEFINES += QT_NO_FOREACH

# To overcome the bug QTBUG-58648, uncomment this define
# Needed at least for RPi3 and iMX
#CONFIG += DEPLOY_TO_FS

# Uncomment DEVICE_TYPE and assign either UI_SMALL, UI_MEDIUM, UI_LARGE
# to force using that UI form factor. Otherwise
# the form factor is determined based on the platform
DEVICE_TYPE = UI_SMALL

# If DEVICE_TYPE is not set manually, try to determine
# the correct device type by the used operating system
win32|linux:!android:!qnx {
    CONFIG += BLUETOOTH_HOST
    isEmpty(DEVICE_TYPE) { DEVICE_TYPE = UI_SMALL }
} else:android {
    isEmpty(DEVICE_TYPE) { DEVICE_TYPE = UI_MEDIUM }
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources
    QMAKE_CXX_FLAGS -= -DQT_OPENGL_FORCE_SHADER_DEFINES
} else:ios {
     isEmpty(DEVICE_TYPE) { DEVICE_TYPE = UI_MEDIUM }
}

win32 {
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
    demodataproviderpool.cpp \
    seriesstorage.cpp

HEADERS += \
    sensortagdataprovider.h \
    mockdataprovider.h \
    clouddataprovider.h \
    cloudservice.h \
    dataproviderpool.h \
    clouddataproviderpool.h \
    demodataproviderpool.h \
    bluetoothapiconstants.h \
    seriesstorage.h

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
        serviceinfo.cpp \
        bluetoothdevice.cpp

    HEADERS += \
        sensortagdataproviderpool.h \
        bluetoothdataprovider.h \
        serviceinfo.h \
        bluetoothdevice.h
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

equals(DEVICE_TYPE, "UI_SMALL") {
    DEFINES += UI_SMALL
    !DEPLOY_TO_FS: RESOURCES += uismall.qrc
    uiVariant.files = resources/small
    uiVariant.path = /opt/$${TARGET}/resources
    message("Resource file for SMALL display picked")
}

equals(DEVICE_TYPE, "UI_MEDIUM") {
    DEFINES += UI_MEDIUM
    !DEPLOY_TO_FS: RESOURCES += uimedium.qrc
    uiVariant.files = resources/medium
    uiVariant.path = /opt/$${TARGET}/resources
    message("Resource file for MEDIUM display picked")
}

equals(DEVICE_TYPE, "UI_LARGE") {
    DEFINES += UI_LARGE
    !DEPLOY_TO_FS: RESOURCES += uilarge.qrc
    uiVariant.files = resources/large
    uiVariant.path = /opt/$${TARGET}/resources
    message("Resource file for LARGE display picked")
}

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
