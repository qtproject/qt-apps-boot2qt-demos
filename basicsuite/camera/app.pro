QT += quick quickcontrols2
TARGET = camera

include(../shared/shared.pri)

content.files = \
    main.qml \
    CameraControlButton.qml \
    CameraSetting.qml \
    CaptureControl.qml \
    CapturePreview.qml \
    Controls.qml \
    FocusControl.qml \
    Picker.qml \
    RecordingTime.qml \
    Slider.qml \
    ZoomControl.qml
