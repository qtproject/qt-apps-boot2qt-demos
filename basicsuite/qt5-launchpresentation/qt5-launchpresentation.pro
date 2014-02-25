TARGET = qt5-launchpresentation

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    *.qml \
    calqlatr \
    maroon \
    particles \
    presentation \
    samegame \
    images
content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content