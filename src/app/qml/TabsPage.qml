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

Page {
    id: tabsPage
    objectName: "tabsPage"

    header: PageHeader {
        title: i18n.tr("Tabs")
        flickable: tabsGrid

        trailingActionBar.actions: Action {
            objectName: "newTabAcion"
            iconName: "add"
            text: i18n.tr("New tab")
            onTriggered: {
                tabsModel.addTerminalTab();
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        GridView {
            id: tabsGrid
            anchors.fill: parent
            model: tabsModel
            anchors.margins: units.gu(1)
            cellWidth: (parent.width - units.gu(2)) * 0.5
            cellHeight: cellWidth * (terminalPage.terminalContainer.height / terminalPage.terminalContainer.width)

            //      add: Transition {
            //          NumberAnimation { properties: "x,y"; duration: 200 }
            //      }

            removeDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 200 }
            }

            delegate: Item{
                id: tabDelegate
                width: tabsGrid.cellWidth
                height: tabsGrid.cellHeight

                property bool canClose: tabsModel.count > 1

                ShaderEffectSource {
                    id: thumb
                    sourceItem: tabsModel.itemAt(index)

                    live: tabsPage.visible

                    anchors.margins: units.gu(1)
                    anchors.fill: parent

                    CircularTransparentButton {
                        id: settingsButton
                        width: units.gu(4)
                        height: units.gu(4)

                        z: parent.z + 0.1

                        opacity: ( tabDelegate.canClose ? 1.0 : 0.0)
                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }

                        anchors {top: parent.top; left: parent.left; margins: units.gu(1)}

                        innerOpacity: 0.6
                        border {color: UbuntuColors.orange; width: units.dp(1)}
                        action: Action {
                            iconName: "close"
                            onTriggered: tabsModel.removeItem(index);
                        }
                    }

                    Rectangle {
                        id: blackRect
                        height: parent.height * 0.3
                        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                        color: "black"
                        opacity: 0.5
                    }

                    Label {
                        anchors { fill: blackRect; margins: units.dp(2) }
                        property var tab: tabsModel.itemAt(index)
                        text: tab && tab.focusedTerminal ? tab.focusedTerminal.session.title : ""
                        wrapMode: Text.Wrap
                        color: "white"
                    }

                    Rectangle {
                        id: highlightArea
                        anchors.fill: parent
                        color: "white"
                        opacity: tabsModel.currentIndex == index ? 0.2 : 0
                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            tabsModel.currentIndex = index;
                            pageStack.pop();
                        }
                    }
                }
            }
        }
    }
}
