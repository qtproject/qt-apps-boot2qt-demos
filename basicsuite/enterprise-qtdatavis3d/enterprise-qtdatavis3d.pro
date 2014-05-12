TARGET = enterprise-qtdatavis3d

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

QT += datavisualization

content.files = \
    *.qml \
    *.png

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
