TARGET = webengine

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    content \
    ui \
    *.qml
content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
