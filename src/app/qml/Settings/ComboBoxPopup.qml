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
    id: comboBoxPopup

    implicitHeight: 5.5 * itemHeight
    contentHeight: Math.min(implicitHeight, listView.count * itemHeight)
    callerMargin: -units.gu(1)

    property var model
    property real itemHeight
    property real itemMargins
    property string textRole
    property ComboBox comboBox

    property bool square: true
    property real selectedItemY: currentIndex * itemHeight

    ScrollView {
        width: comboBoxPopup.contentWidth
        height: comboBoxPopup.contentHeight

        ListView {
            id: listView
            width: comboBoxPopup.contentWidth
            height: comboBoxPopup.contentHeight
            model: comboBoxPopup.model
            clip: true
            currentIndex: comboBoxPopup.comboBox.currentIndex
            delegate: MouseArea {
                id: mouseArea
                anchors {
                    left: parent.left
                    right: parent.right
                }
                height: comboBoxPopup.itemHeight
                onClicked: {
                    comboBoxPopup.comboBox.currentIndex = index;
                    PopupUtils.close(comboBoxPopup);
                }

                hoverEnabled: true

                Rectangle {
                    visible: mouseArea.containsMouse
                    anchors.fill: parent
                    color: theme.palette.selected.overlay
                    border.width: units.dp(1)
                    border.color: Qt.darker(color, 1.02)
                    antialiasing: true
                }

                Rectangle {
                    visible: index == currentIndex
                    x: comboBoxPopup.itemMargins / 2 - width / 2
                    anchors.verticalCenter: parent.verticalCenter
                    width: units.gu(0.5)
                    height: width
                    color: theme.palette.selected.overlayText
                    antialiasing: true
                    radius: width/2
                }

                Label {
                    id: label
                    anchors {
                        fill: parent
                        leftMargin: comboBoxPopup.itemMargins
                        rightMargin: comboBoxPopup.itemMargins
                    }
                    text: textRole != "" ? (model[textRole] ? model[textRole] : modelData[textRole]) : modelData
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    color: index == currentIndex ?
                               theme.palette.selected.overlayText
                             : theme.palette.normal.overlayText

                    Binding {
                        target: label
                        property: "font.family"
                        value: comboBox.fontFamilyFromModel ? comboBox.fontFamilyFromModel(label.text) : undefined
                        when: typeof comboBox.fontFamilyFromModel !== "undefined"
                    }
                }
            }
        }
    }
}
