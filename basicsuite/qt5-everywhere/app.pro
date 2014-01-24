TARGET = qt5-everywhere

include(../shared/shared.pri)

content.files = \
    *.qml \
    *.js \
    fonts \
    images \
    demos
content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
