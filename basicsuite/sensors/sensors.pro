TARGET = sensors

include(../shared/shared.pri)

content.files = \
    *.qml \
    *.png
content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content