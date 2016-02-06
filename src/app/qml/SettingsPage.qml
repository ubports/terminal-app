/*
 * Copyright (C) 2013, 2014, 2016 Canonical Ltd
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
 * Authored by: Filippo Scognamiglio <flscogna@gmail.com>
 */

import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: settingsPage
    objectName: "settingsPage"

    title: i18n.tr("Settings")
    flickable: null

    Flickable {
        anchors.fill: parent
        interactive: contentHeight + units.gu(6) > height
        contentHeight: mainColumn.height

        Column {
            id: mainColumn
            anchors { left: parent.left; right: parent.right }

            ListItem {
                ListItemLayout {
                    anchors.verticalCenter: parent.verticalCenter
                    title.text: i18n.tr("Layouts")

                    Icon {
                        SlotsLayout.position: SlotsLayout.Trailing
                        width: units.gu(2)
                        height: width
                        name: "go-next"
                    }
                }

                onClicked: pageStack.push(layoutsPage);
            }

            ListItem {
                ListItemLayout {
                    anchors.fill: parent
                    title.text: i18n.tr("Show Keyboard Bar")

                    Switch {
                        id: keybBarSwitch
                        SlotsLayout.position: SlotsLayout.Trailing
                        onCheckedChanged: settings.showKeyboardBar = checked;
                        Component.onCompleted: checked = settings.showKeyboardBar;
                    }
                }

                onClicked: keybBarSwitch.trigger()
            }

            ListItem {
                ListItemLayout {
                    anchors.fill: parent
                    title.text: i18n.tr("Show Keyboard Button")

                    Switch {
                        id: keybButtonSwitch
                        SlotsLayout.position: SlotsLayout.Trailing
                        onCheckedChanged: settings.showKeyboardButton = checked;
                        Component.onCompleted: checked = settings.showKeyboardButton;
                    }
                }

                onClicked: keybButtonSwitch.trigger()
            }

            ListItem {
                height: units.gu(13)

                Label {
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: units.gu(2)
                    }
                    text: i18n.tr("Font Size:")
                }

                Slider {
                    id: slFont
                    objectName: "slFont"
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        margins: units.gu(2)
                    }
                    minimumValue: settings.minFontSize;
                    maximumValue: settings.maxFontSize;
                    onValueChanged: {
                        settings.fontSize = value;
                    }
                    Component.onCompleted: {
                        value = settings.fontSize;
                    }

                    Connections {
                        target: settings
                        onFontSizeChanged: {
                            slFont.value = settings.fontSize
                        }
                    }
                }
            }

            ListItem {
                ListItemLayout {
                    anchors.fill: parent
                    title.text: i18n.tr("Color Scheme")

                    Label {
                        SlotsLayout.position: SlotsLayout.Trailing
                        text: settings.colorScheme
                    }

                    Icon {
                        SlotsLayout.position: SlotsLayout.Last
                        width: units.gu(2); height: width
                        name: "go-next"
                    }
                }

                onClicked: pageStack.push(colorSchemePage);
            }
        }
    }
}
