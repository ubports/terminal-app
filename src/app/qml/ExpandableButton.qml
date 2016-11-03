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

Item {
    id: container
    property Component childComponent
    property Component parentComponent: childComponent
    property list<Action> actions
    property Action mainAction

    // Set this boolean to change the direction of the expansion. True to right and false to left.
    property bool expandRight: true

    property real animationTime: 200
    property color textColor: "white"
    property color backgroundColor: "black"

    property bool expandable: true

    property int maxRows: 3
    property int _rows: Math.min(actions.length, maxRows)
    property int _columns: Math.ceil(actions.length / _rows)

    property int selectedIndex: -1
    property bool expanded: __expanded && expandable
    property bool __expanded: mainMouseArea.pressed && !clickTimer.running

    // Emit haptic feedback.
    onSelectedIndexChanged: pressFeedbackEffect.start();
    onExpandedChanged: pressFeedbackEffect.start();

    Loader {
        sourceComponent: parentComponent
        width: container.width
        height: parent.height
    }

    PressFeedback {
        id: pressFeedbackEffect
    }

    Component {
        id: repeaterDelegate
        Loader {
            id: delegateContainer
            sourceComponent: childComponent
            width: container.width
            height: container.height

            Rectangle {
                color: UbuntuColors.orange;
                anchors.fill: parent
                z: parent.z + 0.01
                opacity: index == selectedIndex ? 0.5 : 0.0

                Behavior on opacity {
                    UbuntuNumberAnimation { }
                }
            }

            Loader {
                z: parent.z + 0.01
                anchors.centerIn: parent
                active: actions[index].text
                sourceComponent: Label {
                    color: textColor
                    text: actions[index].text
                }
            }

            Loader {
                anchors.fill: parent
                scale: 0.5
                active: actions[index].iconName
                sourceComponent: Icon {
                    name: actions[index].iconName
                }
            }
        }
    }

    Timer {
        id: clickTimer
        interval: 400 // TODO This interval might need tweaking.
    }

    MouseArea {
        id: mainMouseArea
        property real __expandedWidth: container.width * _columns
        property real __expandedHeight: container.height * (_rows + 1)
        width: (expanded ? __expandedWidth : container.width)
        height: (expanded ? __expandedHeight : container.height)
        z: parent.z + 0.1
        y: -height + container.height
        x: expanded && !expandRight
           ? -container.width * (container._columns - 1)
           : 0

        enabled: expandable

        onPressed: {
            if (mainAction)
                clickTimer.start();
            selectedIndex = -1;
        }

        onPositionChanged: {
            if (containsMouse && expanded) {
                var i = Math.floor(mouse.x / container.width);
                var j = _rows - Math.floor(mouse.y / container.height) - 1;
                var newIndex = i * _rows + j;
                selectedIndex =
                        (i >= 0 && j >= 0 && newIndex >= 0 && newIndex < actions.length)
                            ? newIndex
                            : -1;
            }
        }

        onReleased: {
            if (clickTimer.running && mainAction)
                mainAction.trigger();
            else if (selectedIndex >= 0 && mainMouseArea.containsMouse)
                actions[selectedIndex].trigger();
        }
    }

    Rectangle {
        id: popupRectangle
        height: container.height * container._rows
        width: container.width * container._columns

        color: container.backgroundColor

        opacity: expanded ? 1.0 : 0.0

        y: -height
        x: !expandRight
           ? -container.width * (container._columns - 1)
           : 0

        GridView {
            id: repeater

            anchors.fill: parent

            model: actions
            cellHeight: container.height
            cellWidth: container.width
            interactive: false
            delegate: repeaterDelegate

            flow: GridView.TopToBottom
            verticalLayoutDirection: GridView.BottomToTop
        }
    }
}
