/*
 * Copyright (C) 2013, 2014 Canonical Ltd
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

    Column {
        id: mainColumn

        spacing: units.gu(1)
        anchors.fill: parent

        ListItem {
            ListItemLayout {
                anchors.fill: parent
                title.text: i18n.tr("Layouts")

                Icon {
                    SlotsLayout.position: SlotsLayout.Trailing
                    width: units.gu(2); height: width
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
                    SlotsLayout.position: SlotsLayout.Trailing
                    onCheckedChanged: settings.showKeyboardBar = checked;
                    Component.onCompleted: checked = settings.showKeyboardBar;
                }
            }
        }

        ListItem {
            height: units.gu(10)

            Label {
                anchors { left: parent.left; margins: units.gu(2) }
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

        OptionSelector {
            id: colorsSchemeSelector
            objectName: "colorsSchemeSelector"
            text: i18n.tr("Color Scheme")
            width: parent.width - units.gu(4)
            x: units.gu(2)

            // TODO Hackish, but works quite well.
            containerHeight: parent.height - y - units.gu(6)

            // TODO This is a workaround at the moment.
            // The application should get them from the c++.
            model: ["GreenOnBlack","WhiteOnBlack","BlackOnWhite","BlackOnRandomLight","Linux","cool-retro-term","DarkPastels","BlackOnLightYellow", "Ubuntu"]

            onSelectedIndexChanged: {
                settings.colorScheme = model[selectedIndex];
            }

            Component.onCompleted: {
                selectedIndex = model.indexOf(settings.colorScheme);
            }
        }
    }
}
