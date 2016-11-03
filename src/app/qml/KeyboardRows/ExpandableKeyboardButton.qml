/*
 * Copyright (C) 2014 Canonical Ltd
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
 * Author: Filippo Scognamiglio <flscogna@gmail.com>
 */
import QtQuick 2.4
import Ubuntu.Components 1.3

import ".."

Item {
    id: expandableKeyboardButton
    property alias text: mainLabel.text
    property alias mainAction: expandableButton.mainAction
    property alias actions: expandableButton.actions
    property alias expandable: expandableButton.expandable
    property alias expandRight: expandableButton.expandRight
    property color backgroundColor
    property color textColor

    Rectangle {
        width: parent.width
        anchors.top: parent.top
        height: units.dp(3)
        color: UbuntuColors.orange;
        z: parent.z + 1
    }

    Label {
        id: mainLabel
        anchors.centerIn: parent
        z: parent.z + 0.02
        color: UbuntuColors.orange;
    }

    ExpandableButton {
        id: expandableButton
        anchors.fill: parent
        backgroundColor: expandableKeyboardButton.backgroundColor
        textColor: expandableKeyboardButton.textColor
        parentComponent: Rectangle {
            color: expandableKeyboardButton.backgroundColor
        }

        z: parent.z + 0.01
    }
}
