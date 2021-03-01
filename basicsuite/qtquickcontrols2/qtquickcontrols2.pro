TARGET = qtquickcontrols2

include(../shared/shared.pri)

!contains(DEFINES, DESKTOP_BUILD) {
    content.files += \
        qtquickcontrols2.conf \
        images \
        icons \
        pages
} else {
    # shared.pri uses COPIES on desktop which cannot copy
    # directories
    copyToDestDir($$PWD/qtquickcontrols2.conf, $$OUT_PWD)
    copyToDestDir($$PWD/images, $$OUT_PWD)
    copyToDestDir($$PWD/icons, $$OUT_PWD)
    copyToDestDir($$PWD/pages, $$OUT_PWD)
}
