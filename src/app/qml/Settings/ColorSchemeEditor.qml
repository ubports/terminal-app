/*
 * Copyright (C) 2016-2017 Canonical Ltd
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

Column {
    id: colorSchemeEditor

    property string title
    property var colorScheme

    function saveCustomizedScheme() {
        colorScheme.write(terminalAppRoot.customizedSchemeFile)
    }

    function switchToCustomizedScheme() {
        if (settings.colorScheme != terminalAppRoot.customizedSchemeName) {
            colorScheme.write(terminalAppRoot.customizedSchemeFile);
            ColorSchemeManager.loadCustomColorScheme(terminalAppRoot.customizedSchemeFile);
            settings.colorScheme = terminalAppRoot.customizedSchemeName;
        }
    }

    width: childrenRect.width

    Label {
        anchors {
            left: parent.left
            right: parent.right
        }
        elide: Text.ElideRight
        text: colorSchemeEditor.title
    }
}
