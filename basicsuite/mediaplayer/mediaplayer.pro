TARGET = mediaplayer

include(../shared/shared.pri)

content.files = \
    *.qml \
    Effects \
    images
content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content