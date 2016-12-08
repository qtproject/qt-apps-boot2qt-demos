TARGET = enterprise-qtdatavis3d

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

QT += datavisualization

content.files = \
    main.qml \
    layer_1.png \
    layer_2.png \
    layer_3.png \

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
