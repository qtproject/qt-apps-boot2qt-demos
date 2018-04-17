TARGET = mediaplayer

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

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
    SeekControl.qml \
    UrlBar.qml \
    VolumeControl.qml \
    Effects \
    images

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
