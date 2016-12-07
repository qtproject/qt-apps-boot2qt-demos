TARGET = enterprise-dashboard

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    main.qml \
    qml \
    images

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content

