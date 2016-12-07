TARGET = canvas3d-planets

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    ControlEventSource.qml \
    FpsDisplay.qml \
    InfoSheet.qml \
    main.qml \
    PlanetButton.qml \
    planets.qml\
    StyledSlider.qml\
    gl-matrix.js \
    planets.js \
    three.js \
    ThreeJSLoader.js \
    threex.planets.js \
    images

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
