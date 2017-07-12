QT += gui qml

SOURCES += \
    main.cpp \
    processlauncher.cpp

OTHER_FILES = \
    qml/main.qml \
    qml/Screen.qml \
    qml/Chrome.qml \
    qml/LaunchButton.qml \
    qml/MyButton.qml \
    qml/TimedButton.qml

RESOURCES += democompositor.qrc

HEADERS += \
    processlauncher.h

INSTALLS += target apps
target.path = /data/user/$$TARGET

# TODO. How does /data/user/$$TARGET map to QStandardPaths
apps.path = /data/user/$$TARGET/apps/
apps.files = apps/files/*.app
