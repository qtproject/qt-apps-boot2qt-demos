TARGET = qt5-cinematicdemo

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    main.qml \
    content

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
