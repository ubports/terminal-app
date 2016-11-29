/*
 * Copyright (C) 2016 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored-by: Florian Boucault <florian.boucault@canonical.com>
 */
import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.Controls 1.4 as QtQuickControls
import QtQuick.Controls.Styles 1.4

QtQuickControls.ComboBox {
    id: comboBox

    style: ComboBoxStyle {
        id: comboBoxStyle

        padding {
            top: 0
            left: units.gu(2)
            right: units.gu(5)
            bottom: 0
        }

        background: Rectangle {
            implicitWidth: units.gu(27)
            implicitHeight: units.gu(4)

            color: theme.palette.normal.field
            border.color: theme.palette.normal.base
            border.width: units.dp(1)
            radius: units.dp(3)

            Icon {
                anchors {
                    right: parent.right
                    rightMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: -units.gu(0.5)
                }

                width: units.gu(1)
                height: units.gu(1)
                asynchronous: true
                name: "up"
            }

            Icon {
                anchors {
                    right: parent.right
                    rightMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                    verticalCenterOffset: units.gu(0.5)
                }

                width: units.gu(1)
                height: units.gu(1)
                asynchronous: true
                name: "down"
            }
        }
        label: Label {
            text: control.currentText
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            color: comboBoxStyle.textColor
        }

        selectionColor: theme.palette.selected.overlay
        textColor: theme.palette.normal.overlayText
        selectedTextColor: theme.palette.selected.overlayText

       __dropDownStyle: MenuStyle {
            id: menuStyle

            font: comboBoxStyle.font
            __labelColor: comboBoxStyle.textColor
            __selectedLabelColor: comboBoxStyle.selectedTextColor
            __maxPopupHeight: units.gu(30)
            __backgroundColor: theme.palette.normal.overlay
             __selectedBackgroundColor: comboBoxStyle.selectionColor

            frame: Rectangle {
                color: menuStyle.__backgroundColor
            }

            __leftLabelMargin: units.gu(2)
            __rightLabelMargin: units.gu(2)
            itemDelegate.label: Label {
                width: units.gu(27) - menuStyle.__leftLabelMargin - menuStyle.__rightLabelMargin
                height: units.gu(4)
                text: formatMnemonic(styleData.text, styleData.underlineMnemonic)
                elide: Text.ElideRight
                verticalAlignment: Text.AlignVCenter
                color: __currentTextColor
            }
            itemDelegate.checkmarkIndicator: Rectangle {
                visible: styleData.checked
                x: menuStyle.__leftLabelMargin / 2 - width / 2 + (__mirrored ? 4 : -4)
                width: units.gu(0.5)
                height: width
                color: __labelColor
                antialiasing: true
                radius: width/2
            }
            itemDelegate.background: Rectangle {
                visible: styleData.selected && styleData.enabled
                color: __selectedBackgroundColor
                border.width: units.dp(1)
                border.color: Qt.darker(__selectedBackgroundColor, 1.02)
                antialiasing: true
            }
            __scrollerStyle: ScrollViewStyle {
                transientScrollBars: true
            }
        }
    }
}
