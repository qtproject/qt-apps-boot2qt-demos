TARGET = camera

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    CameraControlButton.qml \
    CameraSetting.qml \
    CaptureControl.qml \
    CapturePreview.qml \
    Controls.qml \
    FocusControl.qml \
    main.qml \
    Picker.qml \
    RecordingTime.qml \
    Slider.qml \
    ZoomControl.qml

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
