TARGET = textinput

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    main.qml \
    ScrollBar.qml \
    TextArea.qml \
    TextBase.qml \
    TextField.qml

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
