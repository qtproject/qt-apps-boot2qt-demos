TARGET = qt5-particlesdemo

include(../shared/shared.pri)

content.files = \
    *.qml \
    content \
    images \
    shared
content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
