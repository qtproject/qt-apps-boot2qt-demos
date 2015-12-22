TEMPLATE = subdirs
SUBDIRS += \
    sensorexplorer

qtHaveModule(webengine) {
    SUBDIRS += \
        qtwebbrowser
}

qtHaveModule(multimedia) {
    SUBDIRS += \
        camera
}
