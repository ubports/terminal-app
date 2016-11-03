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
        width: tabsBar.width - (actions.width + actions.anchors.leftMargin + actions.anchors.rightMargin)

        Repeater {
            id: tabsRepeater
            model: tabsBar.model

            Item {
                id: tab
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
                implicitWidth: Math.min(tabs.width / tabsRepeater.count, units.gu(27))
                property bool isFocused: tabsBar.model.selectedIndex == index

                TabContour {
                    anchors.fill: parent
                    visible: tab.isFocused
                    backgroundColor: tabsBar.backgroundColor
                    contourColor: tabsBar.contourColor
                }

                Rectangle {
                    id: tabBottomContour
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                    }
                    visible: !tab.isFocused

                    height: units.dp(1)
                    color: tabsBar.contourColor
                }

                Rectangle {
                    id: tabSeparator
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }

                    width: units.dp(1)
                    height: units.gu(2)
                    color: tabsBar.contourColor
                    visible: !tab.isFocused && index != tabsBar.model.selectedIndex - 1
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: tabsBar.model.selectTab(index)
                }

                TabButton {
                    id: tabCloseButton
                    anchors.left: parent.left
                    iconName: "close"
                    onClicked: tabsBar.model.removeTab(index)
                    iconColor: tabsBar.actionColor
                    iconSize: units.gu(1)
                }

                Label {
                    textSize: Label.Small
                    anchors {
                        left: tabCloseButton.right
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: units.gu(0.5)
                    }
                    elide: Text.ElideRight
                    text: tabsBar.titleFromModelItem(modelData)
                    color: tabsBar.foregroundColor
                }
            }
        }
    }

    Rectangle {
        id: bottomContourLeft
        anchors {
            left: parent.left
            bottom: parent.bottom
        }
        width: tabs.anchors.leftMargin

        height: units.dp(1)
        color: tabsBar.contourColor
    }

    Rectangle {
        id: bottomContourRight
        anchors {
            right: parent.right
            bottom: parent.bottom
        }
        width: parent.width - tabs.childrenRect.width - bottomContourLeft.width
        height: units.dp(1)
        color: tabsBar.contourColor
    }

    Row {
        id: actions
        spacing: units.gu(1)

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: tabs.right
            leftMargin: units.gu(1)
            rightMargin: units.gu(1)
        }

        Repeater {
            model: tabsBar.actions
            TabButton {
                iconColor: tabsBar.actionColor
                iconSource: modelData.iconSource
                onClicked: modelData.trigger()
            }
        }
    }
}
