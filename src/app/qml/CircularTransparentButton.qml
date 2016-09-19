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
 * Authored-by: Filippo Scognamiglio <flscogna@gmail.com>
 */
import QtQuick 2.4
import Ubuntu.Components 1.3

Rectangle {
    property color backgroundColor: "black"
    property real innerOpacity: 1.0
    property color textColor: "white"
    property color iconColor: "white"
    property Action action
    radius: width * 0.5

    color: Qt.rgba(backgroundColor.r, backgroundColor.g, backgroundColor.b, innerOpacity)

    width: units.gu(5)
    height: units.gu(5)

    PressFeedback {
        id: pressFeedbackEffect
    }

    Loader {
        active: action.text
        z: parent.z + 0.1
        anchors.centerIn: parent
        sourceComponent: Label {
            opacity: innerOpacity
            text: action.text
            color: textColor
        }
    }

    Loader {
        active: action.iconName
        z: parent.z + 0.1
        scale: 0.5
        anchors.fill: parent
        sourceComponent: Icon {
            opacity: innerOpacity
            name: action.iconName
            color: iconColor
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            action.trigger();
            pressFeedbackEffect.start();
        }
    }
}
