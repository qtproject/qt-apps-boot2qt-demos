TARGET = qtquickcontrols2

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    $$PWD/preview_l.jpg \
    $$PWD/main.qml \
    $$PWD/qtquickcontrols2.conf \
    $$PWD/images \
    $$PWD/icons \
    $$PWD/pages

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
