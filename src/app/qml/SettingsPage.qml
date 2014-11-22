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

import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

Page {
    id: settingsPage
    objectName: "settingsPage"

    title: i18n.tr("Settings")

    Column {
        id: mainColumn

        spacing: units.gu(1)
        anchors { margins: units.gu(2); fill: parent }

        Label {
            text: i18n.tr("Font Size:")
        }

        Slider {
            id: slFont
            objectName: "slFont"
            anchors { left: parent.left; right: parent.right }
            minimumValue: 8;
            maximumValue: 32;
            onValueChanged: {
                settings.fontSize = value;
            }
            Component.onCompleted: {
                value = settings.fontSize;
            }
        }

        ListItem.ThinDivider { }

        OptionSelector {
            id: colorsSchemeSelector
            objectName: "colorsSchemeSelector"
            text: i18n.tr("Color Scheme")

            // TODO Hackish, but works quite well.
            containerHeight: parent.height - y - units.gu(4)

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
