/*
 * Copyright (C) 2017 Canonical Ltd
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
import Ubuntu.Components 1.3
import QMLTermWidget 1.0

ColorSchemeEditor {
    id: backgroundOpacityEditor
    width: units.gu(31)
    title: i18n.tr("Background opacity:")

    property bool colorSchemeChanging: false
    property bool switchingToCustomizedScheme: false

    onColorSchemeChanged: {
        if (switchingToCustomizedScheme) return;

        colorSchemeChanging = true;
        slider.value = colorScheme.opacity() * slider.maximumValue;
        colorSchemeChanging = false;
    }

    Slider {
        id: slider
        anchors {
            left: parent.left
            right: parent.right
        }
        
        minimumValue: 0
        maximumValue: 100
        live: true

        onValueChanged: {
            if (colorSchemeChanging) return;

            switchingToCustomizedScheme = true;
            backgroundOpacityEditor.switchToCustomizedScheme();
            switchingToCustomizedScheme = false;
            backgroundOpacityEditor.colorScheme.setOpacity(value / maximumValue);
            backgroundOpacityEditor.saveCustomizedScheme();
        }
        
        function formatValue(v) {
            return "%1 %".arg(v.toFixed(1));
        }
    }
}
