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
import QtQuick.Layouts 1.3
import QtQml.Models 2.2
import Ubuntu.Components 1.3

SettingsSection {
    id: section
    margins: units.gu(4)

    ColumnLayout {
        anchors {
            right: parent.right
            left: parent.left
            top: parent.top
            margins: section.margins
        }
        height: Math.min(parent.height - section.margins * 2, units.gu(60))
        spacing: units.gu(2)

        RowLayout {
            height: searchField.height
            anchors {
                right: parent.right
                left: parent.left
            }
            spacing: units.gu(2)

            TextFieldStyled {
                id: searchField
                primaryItem: Icon {
                    height: parent.height / 2
                    width: height
                    name: "find"
                    asynchronous: true
                    color: theme.palette.normal.baseText
                }
            }

            Label {
                Layout.fillWidth: true
                verticalAlignment: Text.AlignVCenter
                text: i18n.tr("Showing %1 of %2").arg(shortcutsList.count)
                                                 .arg(allShortcutsModel.count)
                elide: Text.ElideRight
                color: theme.palette.normal.base
                visible: searchField.text
            }
        }

        ListView {
            id: shortcutsList
            Layout.fillHeight: true
            anchors {
                right: parent.right
                left: parent.left
            }

            Rectangle {
                anchors.fill: parent
                radius: units.dp(3)
                border.color: theme.palette.normal.base
                border.width: units.dp(1)
                color: "transparent"
            }
            clip: true

            Scrollbar {
                flickableItem: shortcutsList
                align: Qt.AlignTrailing
            }

            focus: true
            section {
                property: "section"
                delegate: Item {
                    width: parent.width
                    implicitHeight: units.gu(4)
                    Label {
                        anchors {
                            fill: parent
                            leftMargin: units.gu(2)
                        }
                        verticalAlignment: Text.AlignVCenter
                        text: i18n.tr(section)
                        elide: Text.ElideRight
                    }
                    Rectangle {
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                        height: units.dp(1)
                        color: theme.palette.normal.base
                    }
                }
            }

            model: DelegateModel {
                filterOnGroup: filteringGroup.criteria ? "filtered" : ""
                groups: [
                    DelegateModelGroup {
                        id: filteringGroup
                        includeByDefault: true
                        name: "filtered"
                        property string criteria: searchField.text
                        onCriteriaChanged: update()

                        function update() {
                            if (count != 0) {
                                remove(0, count);
                            }
                            for ( var i=0; i<allShortcutsModel.count; i++ ) {
                                var item = allShortcutsModel.get(i);
                                var label = i18n.tr(item.actionLabel).toLowerCase();
                                if(label.indexOf(criteria.toLowerCase()) !== -1) {
                                    insert(item);
                                }
                            }
                        }
                    }
                ]

                model: ListModel {
                    id: allShortcutsModel
                    ListElement {
                        section: QT_TR_NOOP("File")
                        actionLabel: QT_TR_NOOP("New window")
                        shortcutSetting: "shortcutNewWindow"
                    }
                    ListElement {
                        section: QT_TR_NOOP("File")
                        actionLabel: QT_TR_NOOP("New tab")
                        shortcutSetting: "shortcutNewTab"
                    }
                    ListElement {
                        section: QT_TR_NOOP("File")
                        actionLabel: QT_TR_NOOP("Close terminal")
                        shortcutSetting: "shortcutCloseTab"
                    }
                    ListElement {
                        section: QT_TR_NOOP("File")
                        actionLabel: QT_TR_NOOP("Close all terminals")
                        shortcutSetting: "shortcutCloseAllTabs"
                    }
                    ListElement {
                        section: QT_TR_NOOP("File")
                        actionLabel: QT_TR_NOOP("Previous tab")
                        shortcutSetting: "shortcutPreviousTab"
                    }
                    ListElement {
                        section: QT_TR_NOOP("File")
                        actionLabel: QT_TR_NOOP("Next tab")
                        shortcutSetting: "shortcutNextTab"
                    }
                    ListElement {
                        section: QT_TR_NOOP("Edit")
                        actionLabel: QT_TR_NOOP("Copy")
                        shortcutSetting: "shortcutCopy"
                    }
                    ListElement {
                        section: QT_TR_NOOP("Edit")
                        actionLabel: QT_TR_NOOP("Paste")
                        shortcutSetting: "shortcutPaste"
                    }
                    ListElement {
                        section: QT_TR_NOOP("View")
                        actionLabel: QT_TR_NOOP("Toggle fullscreen")
                        shortcutSetting: "shortcutFullscreen"
                    }
                    ListElement {
                        section: QT_TR_NOOP("View")
                        actionLabel: QT_TR_NOOP("Split terminal horizontally")
                        shortcutSetting: "shortcutSplitHorizontally"
                    }
                    ListElement {
                        section: QT_TR_NOOP("View")
                        actionLabel: QT_TR_NOOP("Split terminal vertically")
                        shortcutSetting: "shortcutSplitVertically"
                    }
                    ListElement {
                        section: QT_TR_NOOP("View")
                        actionLabel: QT_TR_NOOP("Navigate to terminal above")
                        shortcutSetting: "shortcutMoveToTileAbove"
                    }
                    ListElement {
                        section: QT_TR_NOOP("View")
                        actionLabel: QT_TR_NOOP("Navigate to terminal below")
                        shortcutSetting: "shortcutMoveToTileBelow"
                    }
                    ListElement {
                        section: QT_TR_NOOP("View")
                        actionLabel: QT_TR_NOOP("Navigate to terminal on the left")
                        shortcutSetting: "shortcutMoveToTileLeft"
                    }
                    ListElement {
                        section: QT_TR_NOOP("View")
                        actionLabel: QT_TR_NOOP("Navigate to terminal on the right")
                        shortcutSetting: "shortcutMoveToTileRight"
                    }
                }

                delegate: ShortcutRow {
                    width: parent.width
                    actionLabel: i18n.tr(model.actionLabel)
                    shortcutSetting: model.shortcutSetting
                    index: filteringGroup.criteria ? DelegateModel.filteredIndex : model.index

                    Rectangle {
                        id: sectionBottomLine
                        anchors {
                            left: parent.left
                            right: parent.right
                            bottom: parent.bottom
                        }
                        height: units.dp(1)
                        color: theme.palette.normal.base
                        visible: index == shortcutsList.count-1 || parent.ListView.nextSection
                                 && parent.ListView.nextSection != parent.ListView.section
                    }
                }
            }
        }
    }
}
