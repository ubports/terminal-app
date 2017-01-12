/*
 * Copyright (C) 2016-2017 Canonical Ltd
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

Item {
    id: separator

    property int orientation: Qt.Horizontal
    property var node
    property Component handleDelegate

    Loader {
        id: handleLoader
        sourceComponent: handleDelegate
        anchors.fill: parent
    }

    implicitWidth: handleLoader.implicitWidth
    implicitHeight: handleLoader.implicitHeight
    z: 1

    MouseArea {
        anchors.centerIn: parent
        width: orientation == Qt.Vertical ? units.gu(1) : parent.width
        height: orientation == Qt.Vertical ? parent.height : units.gu(1)
        cursorShape: orientation == Qt.Horizontal ? Qt.SizeVerCursor : Qt.SizeHorCursor
        drag {
            axis: orientation == Qt.Horizontal ? Drag.YAxis : Drag.XAxis
            target: resizer
            smoothed: false
        }
        onPressed: {
            resizer.initialRatio = node.leftRatio;
            resizer.x = 0;
            resizer.y = 0;
        }
        enabled: separator.visible
    }

    function clamp(value, min, max) {
        return Math.min(Math.max(min, value), max);
    }

    Item {
        id: resizer
        property real initialRatio
        property real minimumRatio: 0.1
        parent: null
        onXChanged: {
            var ratio = initialRatio + x / node.width;
            ratio = clamp(ratio, minimumRatio, 1.0-minimumRatio);
            node.setLeftRatio(ratio);
        }
        onYChanged: {
            var ratio = initialRatio + y / node.height;
            ratio = clamp(ratio, minimumRatio, 1.0-minimumRatio);
            node.setLeftRatio(ratio);
        }
    }
}
