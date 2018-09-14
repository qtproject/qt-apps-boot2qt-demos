# widget dependecy is required by QtCharts demo
QT += quick widgets quickcontrols2

qtHaveModule(webengine) {
    DEFINES += USE_QTWEBENGINE
    QT += webengine
}

DESTPATH = /data/user/qt/$$TARGET
target.path = $$DESTPATH

SOURCES += $$PWD/main.cpp \
           $$PWD/engine.cpp

HEADERS += $$PWD/engine.h

defineTest(b2qtdemo_deploy_defaults) {
    commonFiles.files = \
                        ../shared/SharedMain.qml
    commonFiles.path = $$DESTPATH
    OTHER_FILES += $${commonFiles.files}
    INSTALLS += commonFiles
    export(commonFiles.files)
    export(commonFiles.path)
    export(OTHER_FILES)
    export(INSTALLS)
}

DISTFILES += $$PWD/fonts/TitilliumWeb-Black.ttf \
             $$PWD/fonts/TitilliumWeb-Bold.ttf \
             $$PWD/fonts/TitilliumWeb-ExtraLight.ttf \
             $$PWD/fonts/TitilliumWeb-Light.ttf \
             $$PWD/fonts/TitilliumWeb-Regular.ttf \
             $$PWD/fonts/TitilliumWeb-SemiBold.ttf \
             $$PWD/fonts/ebike-fonts/fontawesome-webfont.ttf \
             $$PWD/fonts/ebike-fonts/Montserrat-Bold.ttf \
             $$PWD/fonts/ebike-fonts/Montserrat-Light.ttf \
             $$PWD/fonts/ebike-fonts/Montserrat-Medium.ttf \
             $$PWD/fonts/ebike-fonts/Montserrat-Regular.ttf \
             $$PWD/fonts/ebike-fonts/Teko-Bold.ttf \
             $$PWD/fonts/ebike-fonts/Teko-Light.ttf \
             $$PWD/fonts/ebike-fonts/Teko-Medium.ttf \
             $$PWD/fonts/ebike-fonts/Teko-Regular.ttf

RESOURCES += \
    $$PWD/fonts.qrc
