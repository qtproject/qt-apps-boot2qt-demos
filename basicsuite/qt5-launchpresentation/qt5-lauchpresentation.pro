TARGET = qt5-launchpresentation

include(../shared/shared.pri)

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