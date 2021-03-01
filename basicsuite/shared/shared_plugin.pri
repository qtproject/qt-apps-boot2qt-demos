pluginfiles.files += qmldir

CONFIG(cross_compile) {
    message("Building for target")
    B2QT_DEPLOYPATH = /data/user/qt/qmlplugins/$$QML_MODULENAME
    target.path += $$B2QT_DEPLOYPATH
    pluginfiles.path += $$B2QT_DEPLOYPATH
} else {
    message("Building for Desktop")
    DESTDIR = $$top_builddir/qmlplugins/$$QML_MODULENAME
    target.path += $$DESTDIR
    pluginfiles.path += $$DESTDIR
    DEFINES += DESKTOP_BUILD
    COPIES += target pluginfiles
}

INSTALLS += target pluginfiles
