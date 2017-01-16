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
 * Authored by: Florian Boucault <florian.boucault@canonical.com>
 */

import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QMLTermWidget 1.0

ColorSchemeEditor {
    id: colorRow

    property int start
    property int count

    spacing: units.gu(1)

    Row {
        id: colors
        spacing: units.gu(1)
        Repeater {
            model: colorRow.count
            Rectangle {
                radius: units.dp(3)
                width: units.gu(3)
                height: width
                border.color: theme.palette.normal.base
                border.width: units.dp(1)
                color: colorScheme.getColor(start+index)

                function setColor(color) {
                    colorScheme.setColor(start+index, color);
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var colorPicker = PopupUtils.open(Qt.resolvedUrl("ColorPickerPopup.qml"),
                                               parent,
                                               {"originalColor": colorScheme.getColor(start+index),
                                                "setColor": setColor});
                        colorPicker.Component.onDestruction.connect(colorRow.saveCustomizedScheme);
                        colorRow.switchToCustomizedScheme();
                    }
                }
            }
        }
    }
}
