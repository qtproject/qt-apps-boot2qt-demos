# widget dependecy is required by QtCharts demo
QT += quick widgets

qtHaveModule(webengine) {
    DEFINES += USE_QTWEBENGINE
    QT += webengine
}

DESTPATH = /data/user/$$TARGET
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
             $$PWD/fonts/TitilliumWeb-BoldItalic.ttf \
             $$PWD/fonts/TitilliumWeb-ExtraLight.ttf \
             $$PWD/fonts/TitilliumWeb-ExtraLightItalic.ttf \
             $$PWD/fonts/TitilliumWeb-Italic.ttf \
             $$PWD/fonts/TitilliumWeb-Light.ttf \
             $$PWD/fonts/TitilliumWeb-LightItalic.ttf \
             $$PWD/fonts/TitilliumWeb-Regular.ttf \
             $$PWD/fonts/TitilliumWeb-SemiBold.ttf \
             $$PWD/fonts/TitilliumWeb-SemiBoldItalic.ttf

RESOURCES += \
    $$PWD/fonts.qrc
