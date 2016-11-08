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
import "." as LocalTabs

Rectangle {
    id: tabsBar

    implicitWidth: units.gu(60)
    implicitHeight: units.gu(3)

    property color backgroundColor: "white"
    property color foregroundColor: "black"
    property color contourColor: Qt.rgba(0.0, 0.0, 0.0, 0.2)
    property color actionColor: "black"
    /* 'model' needs to have the following members:
         property int selectedIndex
         function selectTab(int index)
         function removeTab(int index)
         function moveTab(int from, int to)
    */
    property var model
    property list<Action> actions

    function titleFromModelItem(modelItem) {
        return modelItem.title;
    }

    Row {
        id: tabs
        anchors {
            top: parent.top
            topMargin: units.dp(3)
            bottom: parent.bottom
            left: parent.left
            leftMargin: units.gu(1)
        }
        width: tabsBar.width - (actions.width
                                + tabs.anchors.leftMargin + tabs.anchors.rightMargin)
        move: Transition {
            UbuntuNumberAnimation { property: "x" }
        }

        Repeater {
            id: tabsRepeater
            model: tabsBar.model

            MouseArea {
                id: tabMouseArea

                width: tab.width
                height: tab.height
                drag {
                    target: tabsRepeater.count > 1 && tab.isFocused ? tab : null
                    axis: Drag.XAxis
                    minimumX: -tabMouseArea.x + tabs.anchors.leftMargin
                    maximumX: tabs.width - tabMouseArea.width + tabs.anchors.leftMargin
                }
                z: tab.isFocused ? 1 : 0
                Binding {
                    target: tabsBar
                    property: "selectedTabX"
                    value: tab.parent == tabsBar ? tab.x : tabs.x + tabMouseArea.x + tab.x
                    when: tab.isFocused
                }
                Binding {
                    target: tabsBar
                    property: "selectedTabWidth"
                    value: tabMouseArea.width
                    when: tab.isFocused
                }

                onPressed: tabsBar.model.selectTab(index)

                LocalTabs.Tab {
                    id: tab

                    anchors.left: tabMouseArea.left
                    width: Math.min(tabs.width / tabsRepeater.count, implicitWidth)
                    height: tabs.height

                    states: State {
                        name: "dragging"
                        when: tabMouseArea.drag.active
                        ParentChange { target: tab; parent: tabsBar }
                        AnchorChanges { target: tab; anchors.left: undefined }
                    }
                    transitions: Transition {
                        from: "dragging"
                        ParentAnimation {
                            NumberAnimation {
                                property: "x"
                                duration: UbuntuAnimation.FastDuration
                                easing: UbuntuAnimation.StandardEasing
                            }
                        }
                        AnchorAnimation {
                            duration: UbuntuAnimation.FastDuration
                            easing: UbuntuAnimation.StandardEasing
                        }
                    }

                    isFocused: tabsBar.model.selectedIndex == index
                    isBeforeFocusedTab: index == tabsBar.model.selectedIndex - 1
                    title: tabsBar.titleFromModelItem(modelData)
                    backgroundColor: tabsBar.backgroundColor
                    foregroundColor: tabsBar.foregroundColor
                    contourColor: tabsBar.contourColor
                    actionColor: tabsBar.actionColor
                    onClose: tabsBar.model.removeTab(index)

                    property real originalX
                    property bool isDragged: tabMouseArea.drag.active
                    onIsDraggedChanged: {
                        if (tab.isDragged) {
                            tab.originalX = tabMouseArea.x;
                        }
                    }

                    onXChanged: {
                        if (tab.isDragged) {
                            var middle = tab.x + tab.width / 2;
                            if (middle <= tab.originalX) {
                                if (tabsBar.model.moveTab(index, index - 1)) {
                                    tab.originalX = tab.originalX - tab.width;
                                }
                            } else if (middle >= tab.originalX + tab.width) {
                                if (tabsBar.model.moveTab(index, index + 1)) {
                                    tab.originalX = tab.originalX + tab.width;
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    property real selectedTabX
    property real selectedTabWidth

    Rectangle {
        id: bottomContourLeft
        anchors {
            left: parent.left
            bottom: parent.bottom
        }
        width: selectedTabX
        height: units.dp(1)
        color: tabsBar.contourColor
    }

    Rectangle {
        id: bottomContourRight
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        width: parent.width - selectedTabX - selectedTabWidth
        height: units.dp(1)
        color: tabsBar.contourColor
    }

    Row {
        id: actions

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: tabs.right
        }

        property real actionsSpacing: units.gu(1)
        property real sideMargins: units.gu(1)

        Repeater {
            id: actionsRepeater
            model: tabsBar.actions

            LocalTabs.TabButton {
                iconColor: tabsBar.actionColor
                iconSource: modelData.iconSource
                onClicked: modelData.trigger()
                leftMargin: index == 0 ? actions.sideMargins : actions.actionsSpacing / 2.0
                rightMargin: index == actionsRepeater.count - 1 ? actions.sideMargins : actions.actionsSpacing / 2.0
            }
        }
    }
}
