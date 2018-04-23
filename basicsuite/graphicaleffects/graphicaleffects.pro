TARGET = graphicaleffects

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    Checkers.qml \
    effect_BrightnessContrast.qml \
    effect_Colorize.qml \
    effect_CustomDissolve.qml \
    effect_CustomWave.qml \
    effect_Displacement.qml \
    effect_DropShadow.qml \
    effect_GaussianBlur.qml \
    effect_Glow.qml \
    effect_HueSaturation.qml \
    effect_OpacityMask.qml \
    effect_ThresholdMask.qml \
    main.qml \
    images \
    ../shared/settings.js

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
