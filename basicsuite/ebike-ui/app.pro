QT += quick widgets quickcontrols2
CONFIG += c++11
TARGET = ebike

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# Uncomment to build ebike demo as separate which does not rely on shared functionality of B2qt launcher
DEFINES += STANDALONE

# Uncomment to use only app provided fonts and not common shared fonts
# When providing own fonts use fonts.files and fonts.qrc file to provide those
DEFINES += USE_APP_FONTS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

contains(DEFINES, STANDALONE) {
    SOURCES += \
        main.cpp \
        applicationsettings.cpp

    HEADERS += \
        applicationsettings.h

    content.files = \
        StandaloneMain.qml

    RESOURCES += qc2conf.qrc
} else {
    content.files += \
        qtquickcontrols2.conf
}

include(../shared/shared.pri)


content.files += \
    main.qml \
    NaviPage.qml \
    StatsPage.qml \
    MainPage.qml \
    SpeedView.qml \
    StatsBox.qml \
    NaviBox.qml \
    LightsBox.qml \
    ModeBox.qml \
    ClockView.qml \
    MusicPlayer.qml \
    ConfigurationDrawer.qml \
    IconifiedTabButton.qml \
    GeneralTab.qml \
    ColumnSpacer.qml \
    BikeInfoTab.qml \
    TripChart.qml \
    FpsItem.qml \
    NaviGuide.qml \
    NaviTripInfo.qml \
    ViewTab.qml \
    StatsRow.qml \
    ConfigurationItem.qml \
    NaviButton.qml \
    ToggleSwitch.qml \
    moment.js \
    mostrecent.bson

images.files = \
    images/lights_off.png \
    images/lights_on.png \
    images/map-marker.png \
    images/trip.png \
    images/calories.png \
    images/nextsong.png \
    images/nextsong_pressed.png \
    images/play.png \
    images/play_pressed.png \
    images/prevsong.png \
    images/prevsong_pressed.png \
    images/speed.png \
    images/battery.png \
    images/assist.png \
    images/arrow_left.png \
    images/top_curtain_drag.png \
    images/spinner.png \
    images/checkmark.png \
    images/nav_left.png \
    images/nav_right.png \
    images/nav_straight.png \
    images/small_speedometer_arrow.png \
    images/map_locate.png \
    images/map_zoomin.png \
    images/map_zoomout.png \
    images/info.png \
    images/info_selected.png \
    images/list.png \
    images/list_selected.png \
    images/settings.png \
    images/settings_selected.png \
    images/curtain_up_arrow.png \
    images/search.png \
    images/search_cancel.png \
    images/fps_icon.png \
    images/arrow_right.png \
    images/curtain_shadow_handle.png \
    images/map_btn_shadow.png \
    images/map_destination.png \
    images/map_location_arrow.png \
    images/small_speedometer_shadow.png \
    images/navigation_widget_shadow.png \
    images/small_input_box_shadow.png \
    images/nav_bear_l.png \
    images/nav_bear_r.png \
    images/nav_hard_l.png \
    images/nav_hard_r.png \
    images/nav_light_left.png \
    images/nav_light_right.png \
    images/nav_nodir.png \
    images/nav_uturn_l.png \
    images/nav_uturn_r.png \
    images/pause.png \
    images/pause_pressed.png \
    images/ok.png \
    images/warning.png \
    images/bike-battery.png \
    images/bike-brakes.png \
    images/bike-chain.png \
    images/bike-frontwheel.png \
    images/bike-gears.png \
    images/bike-rearwheel.png \
    images/bike-light.png \
    images/blue_circle_gps_area.png

style.files = \
    BikeStyle/Colors.qml \
    BikeStyle/qmldir \
    BikeStyle/UILayout.qml

style.path = $$DESTPATH/BikeStyle

fonts.files = \
    fonts/Montserrat-BlackItalic.ttf \
    fonts/Montserrat-Bold.ttf \
    fonts/Montserrat-ExtraLightItalic.ttf \
    fonts/Montserrat-LightItalic.ttf \
    fonts/Montserrat-Medium.ttf \
    fonts/Montserrat-SemiBold.ttf \
    fonts/Montserrat-Black.ttf \
    fonts/Montserrat-ExtraBoldItalic.ttf \
    fonts/Montserrat-ExtraLight.ttf \
    fonts/Montserrat-Light.ttf \
    fonts/Montserrat-Regular.ttf \
    fonts/Montserrat-ThinItalic.ttf \
    fonts/Montserrat-BoldItalic.ttf \
    fonts/Montserrat-ExtraBold.ttf \
    fonts/Montserrat-Italic.ttf \
    fonts/Montserrat-MediumItalic.ttf \
    fonts/Montserrat-SemiBoldItalic.ttf \
    fonts/Montserrat-Thin.ttf \
    fonts/Teko-Bold.ttf \
    fonts/Teko-Regular.ttf \
    fonts/Teko-Medium.ttf \
    fonts/Teko-Light.ttf \
    fonts/Teko-SemiBold.ttf
