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
import Ubuntu.Components 1.3

Page {
    id: settingsPage
    objectName: "settingsPage"

    implicitWidth: units.gu(60)
    implicitHeight: units.gu(80)
    property color windowColor: currentSection.windowColor


    header: PageHeader {
        title: i18n.tr("Preferences")
        flickable: currentSection && currentSection.flickableItem ?
                       currentSection.flickableItem : null
        StyleHints {
            backgroundColor: theme.palette.normal.overlay
        }

        property var selectedAction: sections.actions[sections.selectedIndex]
        sections {
            actions: [
                Action {
                    text: i18n.tr("Interface")
                    property string source: Qt.resolvedUrl("SettingsInterfaceSection.qml")
                },
                Action {
                    text: i18n.tr("Shortcuts")
                    property string source: Qt.resolvedUrl("SettingsShortcutsSection.qml")
                }
            ]
        }
    }

    property SettingsSection currentSection: sectionLoader.item ? sectionLoader.item : null
    Loader {
        id: sectionLoader
        anchors {
            top: currentSection.flickableItem ? parent.top : settingsPage.header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        source: settingsPage.header.selectedAction.source
        focus: true
    }
}
