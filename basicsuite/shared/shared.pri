QT += quickcontrols2

#Use only for desktop or if target Qt does not support fontconfg
DEFINES += FONTS_AS_RESOURCES

defineTest(b2qtdemo_deploy_defaults) {
    # Just backward compatibility do nothing
}

# copies the given files to the destination directory
defineTest(copyToDestDir) {
    files = $$1
    dir = $$2

    for(file, files) {
        QMAKE_POST_LINK += $$QMAKE_COPY_DIR $$shell_quote($$file) $$shell_quote($$dir) $$escape_expand(\\n\\t)
    }

    export(QMAKE_POST_LINK)
}

CONFIG(cross_compile) {
    message("Building for target")
    DESTPATH = /data/user/qt/$$TARGET
    target.path = $$DESTPATH
} else {
    message("Building for Desktop")
    DESTPATH = $$OUT_PWD
    target.path = $$DESTPATH
    COPIES += commonFiles content images style
}

# Common fonts if app does not explicitly add it's own
fonts.files += \
    $$PWD/fonts/TitilliumWeb-Black.ttf \
    $$PWD/fonts/TitilliumWeb-Bold.ttf \
    $$PWD/fonts/TitilliumWeb-ExtraLight.ttf \
    $$PWD/fonts/TitilliumWeb-Light.ttf \
    $$PWD/fonts/TitilliumWeb-Regular.ttf \
    $$PWD/fonts/TitilliumWeb-SemiBold.ttf

contains(DEFINES, FONTS_AS_RESOURCES) {
    !contains(DEFINES, USE_APP_FONTS) {
        # Common fonts
        RESOURCES += $$PWD/shared_fonts.qrc
    }

    # Application defined fonts
    APP_FONTS=$${_PRO_FILE_PWD_}/fonts.qrc
    exists($${APP_FONTS}) {
        RESOURCES += $${APP_FONTS}
    }
} else {
    fonts.path = $$DESTPATH/fonts
    INSTALLS += fonts

    CONFIG(cross_compile) {
        QT_FOR_CONFIG += gui-private

        qtConfig(fontconfig) {
            #use fontconfig to provide fonts on target
            fonts.path = /usr/share/fonts/truetype
        }
    } else {
        COPIES += fonts
    }
}

contains(DEFINES, STANDALONE) {
    message("Building as Standalone")
} else {
    message("Building for B2Qt Launcher")
    SOURCES += $$PWD/main.cpp \
               $$PWD/engine.cpp

    HEADERS += $$PWD/engine.h

    commonFiles.files = \
                        $$PWD/SharedMain.qml \
                        # Resides on each application own source directory
                        preview_l.jpg \
                        demo.xml

    commonFiles.path = $$DESTPATH
    OTHER_FILES += $${commonFiles.files}
    INSTALLS += commonFiles
}

# Common for all projects that include this file. Only redefine in your project file
# if different destination folder that default is preferred
content.path = $$DESTPATH
OTHER_FILES += $${content.files}

images.path = $$DESTPATH/images
OTHER_FILES += $${images.files}

style.path = $$DESTPATH/Style
OTHER_FILES += $${style.files}

INSTALLS += target content images style
