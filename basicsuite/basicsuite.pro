TEMPLATE = subdirs
SUBDIRS += \
    sensorexplorer

qtHaveModule(multimedia) {
    SUBDIRS += \
        camera
}

qtHaveModule(datavisualization) {
    SUBDIRS += enterprise-qtdatavis3d
}
