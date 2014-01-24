TARGET = qt5-cinematicdemo

include(../shared/shared.pri)

content.files = \
    *.qml \
    *.png \
    content
content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content