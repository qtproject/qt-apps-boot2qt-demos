TEMPLATE = subdirs

qtHaveModule(webengine) {
    SUBDIRS += \
        qtwebbrowser
}

qtHaveModule(multimedia) {
    SUBDIRS += \
        camera
}

qtHaveModule(charts) {
    SUBDIRS += \
        ebike-ui \
        datacollector
}
