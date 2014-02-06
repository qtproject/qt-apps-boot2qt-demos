QT += quick

DESTPATH = /data/user/$$TARGET
target.path = $$DESTPATH

SOURCES += $$PWD/main.cpp \
           $$PWD/engine.cpp

HEADERS += $$PWD/engine.h

defineTest(b2qtdemo_deploy_defaults) {
    commonFiles.files = \
                        exclude.txt \
                        ../shared/loader.qml
    commonFiles.path = $$DESTPATH
    OTHER_FILES += $${commonFiles.files}
    INSTALLS += commonFiles
    export(commonFiles.files)
    export(commonFiles.path)
    export(OTHER_FILES)
    export(INSTALLS)
}
