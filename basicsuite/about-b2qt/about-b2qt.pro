TARGET = about-b2qt

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    AboutBoot2Qt.qml \
    Box.qml \
    ContentText.qml \
    main.qml \
    Title.qml \
    codeless.png \
    particle_star2.png

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
