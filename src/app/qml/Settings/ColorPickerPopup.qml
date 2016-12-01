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
import Ubuntu.Components.Popups 1.3

Popover {
    id: colorPickerPopup

    contentWidth: units.gu(38)
    grabDismissAreaEvents: false

    property color originalColor
    property var setColor
    property color currentColor: Qt.rgba(redComponent.value / 255,
                                         greenComponent.value / 255,
                                         blueComponent.value / 255,
                                         1.0)
    onCurrentColorChanged: setColor(currentColor)

    property bool square: true

    function setCurrentColor(color) {
        redComponent.value = color.r * 255;
        greenComponent.value = color.g * 255;
        blueComponent.value = color.b * 255;
    }

    Component.onCompleted: setCurrentColor(originalColor)


    Rectangle {
        anchors {
            left: parent.left
            right: parent.right
        }
        height: childrenRect.height + 2*units.gu(2)

        // This adds a contour to the Popover
        function newColorWithAlpha(color, alpha) {
            return Qt.rgba(color.r, color.g, color.b, alpha);
        }
        color: "transparent"
        radius: units.dp(5)
        border.color: newColorWithAlpha(theme.palette.normal.base, 0.2)
        border.width: units.dp(1)

        Column {
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                margins: units.gu(2)
            }
            spacing: units.gu(1)

            ColorComponentSlider {
                id: redComponent
                anchors {
                    left: parent.left
                    right: parent.right
                }
                label: i18n.tr("R:")
            }
            ColorComponentSlider {
                id: greenComponent
                anchors {
                    left: parent.left
                    right: parent.right
                }
                label: i18n.tr("G:")
            }
            ColorComponentSlider {
                id: blueComponent
                anchors {
                    left: parent.left
                    right: parent.right
                }
                label: i18n.tr("B:")
            }

            Button {
                text: i18n.tr("Undo")
                color: theme.palette.selected.overlay
                onClicked: setCurrentColor(originalColor)
            }
        }
    }
}
