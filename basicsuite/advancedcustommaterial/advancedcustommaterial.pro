TARGET = custommaterial

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    main.qml \
    SceneRoot.qml \
    ControlSlider.qml \
    Water.qml \
    WaterMaterial.qml \
    models \
    shaders \
    textures

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
