TARGET = mediaplayer

include(../shared/shared.pri)

content.files = \
    Content.qml \
    ContentVideo.qml \
    ControlBar.qml \
    EffectSelectionPanel.qml \
    FileBrowser.qml \
    ImageButton.qml \
    Intro.qml \
    main.qml \
    MetadataView.qml \
    ParameterPanel.qml \
    PlaybackControl.qml \
    PlayerSlider.qml \
    SeekControl.qml \
    UrlBar.qml \
    VolumeControl.qml

!contains(DEFINES, DESKTOP_BUILD) {
    content.files += \
        Effects \
        images
} else {
    copyToDestDir($$PWD/Effects, $$OUT_PWD)
    copyToDestDir($$PWD/images, $$OUT_PWD)
}
