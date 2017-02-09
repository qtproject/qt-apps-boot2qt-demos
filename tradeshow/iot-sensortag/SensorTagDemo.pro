TEMPLATE = app

QT += 3dcore 3drender 3dinput 3dquick 3dlogic core gui qml quick 3dquickextras widgets
QT += bluetooth network
CONFIG += c++11

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
    CONFIG += BLUETOOTH_LINUX_HOST
    isEmpty(DEVICE_TYPE) { DEVICE_TYPE = UI_SMALL }
} else:android {
    isEmpty(DEVICE_TYPE) { DEVICE_TYPE = UI_MEDIUM }
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android-sources
    QMAKE_CXX_FLAGS -= -DQT_OPENGL_FORCE_SHADER_DEFINES
} else:ios {
     isEmpty(DEVICE_TYPE) { DEVICE_TYPE = UI_MEDIUM }
}

win32 {
    # Obtained via NuGet
    isEmpty(WASTORAGE_LOCATION): WASTORAGE_LOCATION = "C:/Users/mauri/Documents/Visual Studio 2015/Projects/App1/packages/wastorage.v140.2.6.0"
    INCLUDEPATH += $$WASTORAGE_LOCATION/build/native/include \
                   $$WASTORAGE_LOCATION/build/native/include/was \
                   $$WASTORAGE_LOCATION/build/native/include/wascore
    LIBS += -L$$WASTORAGE_LOCATION/lib/native/v140/Win32/Release

    isEmpty(CPPRESTSDK_LOCATION): CPPRESTSDK_LOCATION = "C:/Users/mauri/Documents/Visual Studio 2015/Projects/App1/packages/cpprestsdk.v140.windesktop.msvcstl.dyn.rt-dyn.2.9.1"
    INCLUDEPATH += $$CPPRESTSDK_LOCATION/build/native/include
}

SOURCES += main.cpp \
    mockdataprovider.cpp \
    sensortagdataprovider.cpp \
    clouddataprovider.cpp \
    dataproviderpool.cpp \
    clouddataproviderpool.cpp \
    demodataproviderpool.cpp

HEADERS += \
    sensortagdataprovider.h \
    mockdataprovider.h \
    clouddataprovider.h \
    cloudservice.h \
    dataproviderpool.h \
    clouddataproviderpool.h \
    demodataproviderpool.h \
    bluetoothapiconstants.h

BLUETOOTH_LINUX_HOST {
    !winrt:CONFIG += UPDATE_TO_CLOUD
    DEFINES += RUNS_AS_HOST

    SOURCES += \
        sensortagdataproviderpool.cpp \
        bluetoothdataprovider.cpp \
        serviceinfo.cpp \
        bluetoothdevice.cpp \
        characteristicinfo.cpp

    HEADERS += \
        sensortagdataproviderpool.h \
        bluetoothdataprovider.h \
        serviceinfo.h \
        bluetoothdevice.h \
        characteristicinfo.h
}

UPDATE_TO_CLOUD {
    SOURCES += cloudupdate.cpp
    HEADERS += cloudupdate.h
    DEFINES += CLOUD_UPLOAD
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
