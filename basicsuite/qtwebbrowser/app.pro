TARGET = qtwebbrowser

qtHaveModule(webengine) {
    DEFINES += USE_QTWEBENGINE
    QT += webengine
}

include(../shared/shared.pri)

content.files = \
    main.qml
