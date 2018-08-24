/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the E-Bike demo project.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

pragma Singleton
import QtQuick 2.9

QtObject {
    readonly property int clockBaselineMargin: 25
    readonly property int clockFontSize: 18

    readonly property int statsIconTop: 56
    readonly property int statsIconLeft: 50
    readonly property int statsIconSeparator: 20
    readonly property int statsIconWidth: 40
    readonly property int statsIconHeight: 40
    readonly property int statsTextSeparator: 15
    readonly property int statsTextSize: 20
    readonly property int statsTextTopOffset: 0
    readonly property int statsUnitBaselineOffset: 0

    readonly property int lightsIconBottom: 90
    readonly property int lightsIconLeft: 50
    readonly property int lightsIconWidth: 80
    readonly property int lightsIconHeight: 80

    readonly property int naviModeCenterMargin: 90

    readonly property int naviIconTop: 45
    readonly property int naviIconRight: 50
    readonly property int naviIconWidth: 80
    readonly property int naviIconHeight: 80
    readonly property int naviTextSize: 26
    readonly property int naviTextMargin: 30

    readonly property int modeBottomOffset: 84
    readonly property int modeDistance: 50
    readonly property int modeTextSize: 20

    readonly property int speedViewTop: 78
    readonly property int speedViewRadius: 150 /* Normal mode */
    readonly property int speedViewRadiusMinified: 90 /* Minified to corner mode */
    readonly property int speedViewRadiusEnlarged: 205 /* Enlarged to full screen mode */
    readonly property int speedViewDots: 96
    readonly property int speedViewDotsMinified: 48
    readonly property int speedViewDotsEnlarged: 128
    readonly property int speedViewCornerLeftMargin: 15
    readonly property int speedViewCornerBottomMargin: 15
    readonly property int speedViewInnerRadius: 125
    readonly property int speedViewInnerRadiusMinified: 65
    readonly property int speedViewInnerRadiusEnlarged: 185
    readonly property int speedViewInnerWidth: 12
    readonly property int speedViewInnerWidthMinified: 8
    readonly property double speedViewSpeedStart: Math.PI * 0.5 + Math.PI / 30
    readonly property double speedViewSpeedEnd: Math.PI * 1.5 - Math.PI / 30
    readonly property double speedViewBatteryStart: Math.PI * 0.5 - Math.PI / 30
    readonly property double speedViewBatteryEnd: -Math.PI * 0.5 + Math.PI / 30
    readonly property double speedViewAssistPowerStart: Math.PI * 0.5 + Math.PI / 34
    readonly property double speedViewAssistPowerEnd: Math.PI * 0.5 - Math.PI / 34
    readonly property int speedViewAssistPowerWidth: 6
    readonly property int speedViewAssistPowerRadius: 230
    readonly property int speedViewAssistPowerBottomOffset: 104
    readonly property int speedBaselineOffset: 137
    readonly property int speedBaselineOffsetMinified: 73
    readonly property int speedBaselineOffsetEnlarged: 155
    readonly property int speedTextSize: 108
    readonly property int speedTextSizeMinified: 80
    readonly property int speedTextSizeEnlarged: 190
    readonly property int speedUnitsSize: 14
    readonly property int speedUnitsSizeEnlarged: 18
    readonly property int speedTextUnitMargin: 24
    readonly property int speedTextUnitMarginMinified: 18
    readonly property int speedTextUnitMarginEnlarged: 30
    readonly property int speedIconsCenterOffset: 71
    readonly property int speedIconsCenterOffsetEnlarged: 111
    readonly property int speedInfoTextsOffsetEnlarged: -34
    readonly property int speedInfoTextsSize: 38
    readonly property int speedInfoTextsSizeEnlarged: 64
    readonly property int speedInfoUnitsOffset: 24
    readonly property int speedInfoUnitsOffsetEnlarged: 34
    readonly property int averageSpeedIconMargin: -5
    readonly property int averageSpeedIconWidth: 40
    readonly property int averageSpeedIconHeight: 40
    readonly property int assistDistanceIconMargin: -5
    readonly property int assistDistanceIconWidth: 40
    readonly property int assistDistanceIconHeight: 40
    readonly property int assistPowerIconOffset: 49
    readonly property int assistPowerIconOffsetEnlarged: 100
    readonly property int assistPowerIconWidth: 30
    readonly property int assistPowerIconHeight: 30
    readonly property int assistPowerCircleRadius: 6
    readonly property int assistPowerCircleOffset: 8
    readonly property int assistPowerCircleVerticalOffset: 5
    readonly property int assistPowerCircleTopMargin: 7
    readonly property int speedometerCornerArrowWidth: 40
    readonly property int speedometerCornerArrowHeight: 40
    readonly property int ringValueText: 14

    readonly property int musicPlayerWidth: 260
    readonly property int musicPlayerHeight: 75
    readonly property int musicPlayerCorner: 20
    readonly property int musicPlayerIconWidth: 40
    readonly property int musicPlayerIconHeight: 40
    readonly property int musicPlayerIconBottom: 5
    readonly property int musicPlayerIconSpacing: 50
    readonly property int musicPlayerTextBottom: 5
    readonly property int musicPlayerTextSize: 16

    readonly property int naviPageLocationWidth: 300
    readonly property int naviPageLocationHeight: 40
    readonly property int naviPageLocationRadius: 20
    readonly property int naviPageLocationTopMargin: 60
    readonly property int naviPageLocationLeftPadding: 20
    readonly property int naviPageIconBackgroundWidth: 50
    readonly property int naviPageIconBackgroundHeight: 50
    readonly property int naviPageIconBackgroundRadius: 25
    readonly property int naviPageIconWidth: 40
    readonly property int naviPageIconHeight: 40
    readonly property int naviPageIconTopMargin: 15
    readonly property int naviPageIconRightMargin: 15
    readonly property int naviPageIconSpacing: 15
    readonly property int naviPageSuggestionsOffset: 5
    readonly property int naviPageSuggestionHeight: 40
    readonly property int naviPageSuggestionTextSize: 16

    readonly property int naviPageSearchIconWidth: 40
    readonly property int naviPageSearchIconHeight: 40
    readonly property int naviPageSearchIconMargin: 5
    readonly property int naviPageSearchTextSize: 16

    readonly property int naviPageTripWidth: 220
    readonly property int naviPageTripHeight: 40
    readonly property int naviPageTripRadius: 20
    readonly property int naviPageTripDividerWidth: 2
    readonly property int naviPageTripDividerHeight: 20
    readonly property int naviPageTripBottomMargin: 15
    readonly property int naviPageTripSearchMargin: 15
    readonly property int naviPageTripTotalTextSize: 18
    readonly property int naviPageTripTotalUnitSize: 18

    readonly property int naviPageGuideRadius: 90
    readonly property int naviPageGuideRightMargin: 15
    readonly property int naviPageGuideBottomMargin: 15
    readonly property int naviPageGuideArrowTopMargin: 30
    readonly property int naviPageGuideArrowLeftMargin: 50
    readonly property int naviPageGuideArrowWidth: 80
    readonly property int naviPageGuideArrowHeight: 80
    readonly property int naviPageGuideAddressBaselineMargin: 20
    readonly property int naviPageGuideAddressRightMargin: 20
    readonly property int naviPageGuideAddressTextSize: 14
    readonly property int naviPageGuideDistanceBaselineMargin: 20
    readonly property int naviPageGuideDistanceTextSize: 26
    readonly property int naviPageGuideUnitTextSize: 26

    readonly property int tabBarTabHeight: 60
    readonly property int tabBarFontSize: 24
    readonly property int tabButtonTopMargin: 13
    readonly property int tabButtonIconWidth: 40
    readonly property int tabButtonIconHeight: 40
    readonly property int curtainMargin: 30
    readonly property int curtainCloseHeight: 30
    readonly property int configurationItemHeight: 59
    readonly property int configurationItemSeparator: 1
    readonly property int configurationTextSize: 18
    readonly property int configurationTitleSize: 18
    readonly property int languageTextSize: 18
    readonly property int checkboxWidth: 20
    readonly property int checkboxHeight: 20
    readonly property int checkboxRadius: 5
    readonly property int checkboxLabelSize: 16
    readonly property int checkboxTextOffset: 10
    readonly property int checkboxSliderOffset: 20
    readonly property int sliderHandleRadius: 10
    readonly property int sliderHandleRadiusInner: 6
    readonly property int sliderWidth: 256
    readonly property int sliderHeight: 4
    readonly property int switchWidth: 50
    readonly property int switchHeight: 20
    readonly property int switchIndicatorRadius: 15
    readonly property int unitButtonWidthMargin: 20
    readonly property int unitButtonHeight: 40
    readonly property int unitButtonSpacing: 10
    readonly property int unitFontSize: 16
    readonly property int bikeInfoComponentBaselineOffset: 30
    readonly property int bikeInfoComponentLineOffset: 14
    readonly property int bikeInfoLineWidth: 2
    readonly property int bikeInfoLineDetailsMargin: 24
    readonly property int bikeInfoDetailsValueMargin: 20
    readonly property int bikeInfoDetailsBaselineMargin: 30
    readonly property int bikeInfoComponentHeaderTextSize: 18
    readonly property int bikeInfoInfoHeaderTextSize: 18
    readonly property int bikeInfoCircleRadius: 17

    readonly property int statsTripButtonWidth: 40
    readonly property int statsTripButtonHeight: 40
    readonly property int statsTripButtonMarginSide: 30
    readonly property int statsTripButtonMarginTop: 60
    readonly property int statsEndtripWidth: 150
    readonly property int statsEndtripHeight: 40
    readonly property int statsEndtripMargin: 60
    readonly property int statsEndtripTextSize: 16
    readonly property int statsDescriptionTextSize: 18
    readonly property int statsValueTextSize: 18
    readonly property int statsOdometerMarginRight: 30
    readonly property int statsOdometerBaselineOffset: 40
    readonly property int statsTopMargin: 28
    readonly property int statsHeight: 39
    readonly property int statsCenterOffset: 30
    readonly property int chartWidth: 440
    readonly property int chartHeight: 200
    readonly property int chartBottomMargin: 0
    readonly property int chartRightMargin: 0
    readonly property int chartLegendTextSize: 14
    readonly property int chartTimeLabelSize: 14
    readonly property int chartSpeedLabelSize: 14
    readonly property int chartAssistpowerLabelSize: 14

    readonly property int topViewHeight: 229
    readonly property int bottomViewHeight: 251
    readonly property int horizontalViewSeparatorHeight: 1
    readonly property int horizontalViewSeparatorWidth: 170
    readonly property int verticalViewSeparatorHeightTop: 110
    readonly property int verticalViewSeparatorHeightBottom: 132
    readonly property int verticalViewSeparatorWidth: 1
}
