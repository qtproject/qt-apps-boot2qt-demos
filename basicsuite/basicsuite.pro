TEMPLATE = subdirs
SUBDIRS += \
    sensorexplorer

qtHaveModule(multimedia) {
    SUBDIRS += qt5-everywhere \
               camera
}
