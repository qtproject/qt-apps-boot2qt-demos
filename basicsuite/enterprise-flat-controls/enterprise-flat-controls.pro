TARGET = enterprise-gallery

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    *.qml \
    qml \
    fonts \
    images
content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
