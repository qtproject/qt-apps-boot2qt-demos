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

    readonly property int speedViewDots: 96
    readonly property int speedViewDotsMinified: 48
    readonly property int speedViewDotsEnlarged: 128

    readonly property double speedViewSpeedStart: Math.PI * 0.5 + Math.PI / 30
    readonly property double speedViewSpeedEnd: Math.PI * 1.5 - Math.PI / 30
    readonly property double speedViewBatteryStart: Math.PI * 0.5 - Math.PI / 30
    readonly property double speedViewBatteryEnd: -Math.PI * 0.5 + Math.PI / 30

    readonly property int speedBaselineOffset: 137

    readonly property int speedInfoTextsOffsetEnlarged: -34

    readonly property int assistPowerCircleOffset: 8
    readonly property int assistPowerCircleVerticalOffset: 5

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

    readonly property int configurationItemSeparator: 1

    readonly property int checkboxWidth: 20
    readonly property int checkboxHeight: 20
    readonly property int checkboxRadius: 5
    readonly property int checkboxTextOffset: 10
    readonly property int checkboxSliderOffset: 20
    readonly property int sliderHandleRadius: 10
    readonly property int sliderHandleRadiusInner: 6
    readonly property int sliderWidth: 256
    readonly property int sliderHeight: 4
    readonly property int switchWidth: 50
    readonly property int switchHeight: 20
    readonly property int switchIndicatorRadius: 15
    readonly property int unitButtonSpacing: 10
    readonly property int unitFontSize: 16
    readonly property int bikeInfoLineWidth: 2
    readonly property int bikeInfoCircleRadius: 17

    readonly property int statsTripButtonWidth: 40
    readonly property int statsTripButtonHeight: 40
    readonly property int statsTripButtonMarginSide: 30
    readonly property int statsEndtripWidth: 150
    readonly property int statsEndtripHeight: 40
    readonly property int statsEndtripMargin: 60
    readonly property int statsEndtripTextSize: 16

    readonly property int statsOdometerMarginRight: 30
    readonly property int statsOdometerBaselineOffset: 40
    readonly property int statsTopMargin: 28

    readonly property int horizontalViewSeparatorHeight: 1
    readonly property int verticalViewSeparatorWidth: 1
}
