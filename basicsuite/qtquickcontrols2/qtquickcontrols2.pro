TARGET = gallery

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    main.qml \
    qtquickcontrols2.conf \
    icons/gallery/index.theme \
    $$files(icons/*.png, true) \
    $$files(images/*.png) \
    $$files(pages/*.qml)

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
