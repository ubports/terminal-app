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

            LocalTabs.Tab {
                id: tab
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                }
                implicitWidth: Math.min(tabs.width / tabsRepeater.count, units.gu(27))

                isFocused: tabsBar.model.selectedIndex == index
                isBeforeFocusedTab: index == tabsBar.model.selectedIndex - 1
                title: tabsBar.titleFromModelItem(modelData)
                backgroundColor: tabsBar.backgroundColor
                foregroundColor: tabsBar.foregroundColor
                contourColor: tabsBar.contourColor
                actionColor: tabsBar.actionColor
                onClose: tabsBar.model.removeTab(index)
                onClicked: tabsBar.model.selectTab(index)
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
            LocalTabs.TabButton {
                iconColor: tabsBar.actionColor
                iconSource: modelData.iconSource
                onClicked: modelData.trigger()
            }
        }
    }
}
