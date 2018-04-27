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
    readonly property color clockText: "#d7dbe4"
    readonly property color clockBackground: "#020611"
    readonly property color mainBackground: "#1b1f2a"
    readonly property color separator: "#040809"
    readonly property color dottedRing: "#52576b"
    readonly property color distanceText: "#ffffff"
    readonly property color distanceUnit: "#acafbc"
    readonly property color speedViewBackgroundCornered: "#020611"
    readonly property color speedText: "#ffffff"
    readonly property color speedUnit: "#acafbc"
    readonly property color averageSpeedText: "#ffffff"
    readonly property color averageSpeedUnit: "#acafbc"
    readonly property color assistDistanceText: "#ffffff"
    readonly property color assistDistanceUnit: "#acafbc"
    readonly property color modeSelected: "#a0e63e"
    readonly property color modeUnselected: "#acafbc"
    readonly property color speedGradientStart: "#fcff2a"
    readonly property color speedGradientEnd: "#41cd52"
    readonly property color batteryGradientStart: "#34daea"
    readonly property color batteryGradientEnd: "#3aeb95"
    readonly property color assistPowerGradientStart: "#ffd200"
    readonly property color assistPowerGradientEnd: "#f7971e"
    readonly property color assistPowerEmpty: "#52576b"
    readonly property color musicPlayerBackground: "#020611"
    readonly property color musicPlayerSongText: "#d7dbe4"
    readonly property color musicPlayerTimeText: "#989ba8"
    readonly property color naviPageSuggestionBorder: "#a0e63e"
    readonly property color naviPageSuggestionText: "#1b1f2a"
    readonly property color naviPageSuggestionsDivider: "#989ba8"
    readonly property color naviPageIconBackground: "#1b1f2a"
    readonly property color naviPageIconPressedBackground: "#a0e63e"
    readonly property color naviPageTripBackground: "#1b1f2a"
    readonly property color naviPageTripDivider: "#acafbc"
    readonly property color naviPageGuideBackground: "#1b1f2a"
    readonly property color naviPageGuideTextColor: "#ffffff"
    readonly property color naviPageGuideUnitColor: "#acafbc"
    readonly property color naviPageGuideAddressColor: "#ffffff"
    readonly property color curtainBackground: "#020611"
    readonly property color tabBackground: "#020611"
    readonly property color activeTabBorder: "#a0e63e"
    readonly property color activeTabIcon: "#ffffff"
    readonly property color tabIcon: "#989ba8"
    readonly property color tabTitleColor: "#ffffff"
    readonly property color tabItemColor: "#989ba8"
    readonly property color tabItemBorder: "#1b1f2a"
    readonly property color languageTextColor: "#acafbc"
    readonly property color checkboxBorderColorChecked: "#a0e63e"
    readonly property color checkboxBorderColor: "#acafbc"
    readonly property color checkboxCheckedText: "#ffffff"
    readonly property color checkboxUncheckedBackground: "#020611"
    readonly property color sliderBackground: "#52576b"
    readonly property color sliderInnerBackground: "#000000"
    readonly property color sliderMinimumValue: "#fcff2a"
    readonly property color sliderMaximumValue: "#41cd52"
    readonly property color activeButtonBackground: "#a0e63e"
    readonly property color inactiveButtonBackground: "#020611"
    readonly property color activeButtonText: "#020611"
    readonly property color inactiveButtonText: "#acafbc"
    readonly property color inactiveButtonBorder: "#acafbc"
    readonly property color switchOn: "#a0e63e"
    readonly property color switchOff: "#ffffff"
    readonly property color switchBackgroundOn: "#4da0e63e"
    readonly property color switchBackgroundOff: "#52576b"
    readonly property color bikeInfoDeselected: "#ffffff"
    readonly property color bikeInfoLineOk: "#a0e63e"
    readonly property color bikeInfoLineWarning: "#d4145a"
    readonly property color bikeInfoComponentHeader: "#ffffff"
    readonly property color bikeInfoComponentText: "#acafbc"
    readonly property color bikeInfoComponentOk: "#ffffff"
    readonly property color bikeInfoComponentWarning: "#d4145a"
    readonly property color chartSpeed: "#a0e63e"
    readonly property color chartAssistpower: "#34daea"
    readonly property color chartLegend: "#ffffff"
    readonly property color chartLabel: "#989ba8"
    readonly property color chartTimeLabel: "#acafbc"
    readonly property color chartGridLine: "#111520"
    readonly property color statsButtonPressed: "#a0e63e"
    readonly property color statsButtonInactive: "#52576b"
    readonly property color statsButtonActive: "#848794"
    readonly property color statsButtonInactiveText: "#52576b"
    readonly property color statsButtonActiveText: "#ffffff"
    readonly property color statsDescriptionText: "#989ba8"
    readonly property color statsValueText: "#ffffff"
    readonly property color statsSeparator: "#111520"
}
