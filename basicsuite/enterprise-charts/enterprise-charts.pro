TARGET = enterprise-charts

include(../shared/shared.pri)
b2qtdemo_deploy_defaults()

content.files = \
    BaseChart.qml \
    loader.qml \
    main.qml \
    View1.qml \
    View10.qml \
    View11.qml \
    View12.qml \
    View2.qml \
    View3.qml \
    View4.qml \
    View5.qml \
    View6.qml \
    View7.qml \
    View8.qml \
    View9.qml \
    ../shared/settings.js

content.path = $$DESTPATH

OTHER_FILES += $${content.files}

INSTALLS += target content
