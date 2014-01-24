TARGET = graphicaleffects

include(../shared/shared.pri)

content.files = \
    *.qml \
    images
content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content