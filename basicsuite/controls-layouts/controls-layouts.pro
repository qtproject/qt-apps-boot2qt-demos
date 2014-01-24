TARGET = controls-layouts

include(../shared/shared.pri)

content.files = *.qml
content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content