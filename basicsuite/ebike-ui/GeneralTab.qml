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

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import DataStore 1.0

import "./BikeStyle"

Item {
    Column {
        anchors.left: parent.left
        anchors.right: parent.right

        Text {
            height: stackLayout.height * 0.225
            width: parent.width
            text: qsTr("GENERAL")
            font {
                family: "Montserrat, Medium"
                weight: Font.Medium
                pixelSize: height * 0.375
            }
            color: Colors.tabTitleColor
            verticalAlignment: Text.AlignVCenter
        }

        ColumnSpacer {
            color: Colors.tabItemBorder
        }

        ConfigurationItem {
            description: qsTr("Language")

            Text {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }
                text: qsTr("English")
                font {
                    family: "Montserrat, Medium"
                    weight: Font.Medium
                    pixelSize: height * 0.25
                }
                color: Colors.languageTextColor
                verticalAlignment: Text.AlignVCenter
            }
        }

        ColumnSpacer {
            color: Colors.tabItemBorder
        }

        ConfigurationItem {
            description: qsTr("Brightness")

            Text {
                anchors {
                    right: autoBrightness.left
                    rightMargin: UILayout.checkboxTextOffset
                    verticalCenter: autoBrightness.verticalCenter
                }
                text: qsTr("Auto")
                font {
                    family: "Montserrat, Medium"
                    weight: Font.Medium
                    pixelSize: parent.height * 0.225
                }
                color: Colors.checkboxCheckedText
            }

            CheckBox {
                id: autoBrightness
                width: UILayout.checkboxWidth
                anchors {
                    right: brightnessSlider.left
                    rightMargin: UILayout.checkboxSliderOffset
                    verticalCenter: brightnessSlider.verticalCenter
                }
                checked: brightness.automatic

                indicator: Rectangle {
                    implicitWidth: UILayout.checkboxWidth
                    implicitHeight: UILayout.checkboxHeight
                    y: parent.height / 2 - height / 2
                    radius: UILayout.checkboxRadius
                    color: Colors.checkboxUncheckedBackground
                    border.color: autoBrightness.checked ? Colors.checkboxBorderColorChecked : Colors.checkboxBorderColor
                    border.width: autoBrightness.checked ? 2 : 1

                    Image {
                        source: "images/checkmark.png"
                        anchors.centerIn: parent
                        visible: autoBrightness.checked
                    }
                }

                contentItem: Item {}

                onToggled: brightness.automatic = checked
            }

            Slider {
                id: brightnessSlider
                value: 4
                width: parent.width * 0.2
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }
                from: 6
                to: 1
                stepSize: -1
                snapMode: Slider.SnapAlways
                onMoved: brightness.brightness = value

                background: Rectangle {
                    x: brightnessSlider.leftPadding
                    y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                    implicitWidth: UILayout.sliderWidth
                    implicitHeight: UILayout.sliderHeight
                    width: brightnessSlider.availableWidth
                    height: implicitHeight
                    radius: UILayout.sliderHeight / 2
                    color: Colors.sliderBackground

                    Rectangle {
                        // Since gradient is only available vertically, we must draw and rotate
                        width: parent.height
                        height: brightnessSlider.visualPosition * parent.width
                        radius: UILayout.sliderHeight / 2
                        gradient: Gradient {
                            GradientStop { position: 0; color: Colors.sliderMinimumValue }
                            GradientStop { position: 1; color: Colors.sliderMaximumValue }
                        }

                        transform: Rotation { origin.x: 0; origin.y: UILayout.sliderHeight; angle: -90}
                    }
                }

                handle: Rectangle {
                    x: brightnessSlider.leftPadding + brightnessSlider.visualPosition * (brightnessSlider.availableWidth - width)
                    y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                    implicitWidth: 2 * UILayout.sliderHandleRadius
                    implicitHeight: 2 * UILayout.sliderHandleRadius
                    radius: UILayout.sliderHandleRadius
                    color: Colors.sliderMaximumValue

                    Rectangle {
                        anchors.centerIn: parent
                        implicitWidth: 2 * UILayout.sliderHandleRadiusInner
                        implicitHeight: 2 * UILayout.sliderHandleRadiusInner
                        radius: UILayout.sliderHandleRadiusInner
                        color: Colors.sliderInnerBackground
                    }
                }
            }
        }

        ColumnSpacer {
            color: Colors.tabItemBorder
        }

        ConfigurationItem {
            description: qsTr("Units")

            RoundButton {
                id: kmhButton
                height: parent.height * 0.6
                width: height + kmhText.implicitWidth
                radius: height / 2
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                }

                background: Rectangle {
                    width: parent.width
                    height: parent.height
                    radius: parent.radius
                    color: datastore.unit === DataStore.Kmh ? Colors.activeButtonBackground : Colors.inactiveButtonBackground
                    border.color: Colors.inactiveButtonBorder
                    border.width: datastore.unit === DataStore.Kmh ? 0 : 1
                }

                contentItem: Text {
                    id: kmhText
                    font {
                        family: "Montserrat, Medium"
                        weight: Font.Medium
                        pixelSize: UILayout.unitFontSize
                    }
                    text: "km/h"
                    color: datastore.unit === DataStore.Kmh ? Colors.activeButtonText : Colors.inactiveButtonText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: datastore.unit = DataStore.Kmh
            }

            RoundButton {
                id: mphButton
                height: parent.height * 0.6
                width: height + mphText.implicitWidth
                radius: height / 2
                anchors {
                    verticalCenter: parent.verticalCenter
                    right: kmhButton.left
                    rightMargin: UILayout.unitButtonSpacing
                }

                background: Rectangle {
                    width: parent.width
                    height: parent.height
                    radius: parent.radius
                    color: datastore.unit === DataStore.Mph ? Colors.activeButtonBackground : Colors.inactiveButtonBackground
                    border.color: Colors.inactiveButtonBorder
                    border.width: datastore.unit === DataStore.Mph ? 0 : 1
                }

                contentItem: Text {
                    id: mphText
                    text: "mph"
                    font {
                        family: "Montserrat, Medium"
                        weight: Font.Medium
                        pixelSize: UILayout.unitFontSize
                    }
                    color: datastore.unit === DataStore.Mph ? Colors.activeButtonText : Colors.inactiveButtonText
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: datastore.unit = DataStore.Mph
            }
        }

        ColumnSpacer {
            color: Colors.tabItemBorder
        }
    }
}
