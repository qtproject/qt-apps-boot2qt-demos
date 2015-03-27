TEMPLATE = subdirs
SUBDIRS += \
    sensorexplorer

qtHaveModule(multimedia) {
    SUBDIRS += \
        camera
}
