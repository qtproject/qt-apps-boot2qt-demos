TARGET = enterprise-charts

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    *.qml
content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content