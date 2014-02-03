TARGET = qt5-particlesdemo

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    *.qml \
    content \
    images \
    shared
content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
