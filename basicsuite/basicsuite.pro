TEMPLATE = subdirs

qtHaveModule(webengine) {
    SUBDIRS += \
        qtwebbrowser
}

qtHaveModule(multimedia) {
    SUBDIRS += \
        camera
}
