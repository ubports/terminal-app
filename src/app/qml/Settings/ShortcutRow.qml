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

FocusScope {
    id: shortcutRow

    implicitWidth: units.gu(30)
    implicitHeight: units.gu(4)

    property string actionLabel
    property string shortcutSetting
    property int index

    Rectangle {
        anchors.fill: parent
        color: index % 2 == 0 ? theme.palette.normal.overlay
                              : theme.palette.selected.overlay
    }

    MouseArea {
        anchors.fill: parent
        onClicked: shortcutEditor.start();
    }

    ShortcutEditor {
        id: shortcutEditor
        
        sequence: settings[shortcutRow.shortcutSetting]
        onFinished: settings[shortcutRow.shortcutSetting] = sequence
    }

    RowLayout {
        anchors {
            leftMargin: units.gu(4)
            fill: parent
        }
        spacing: units.gu(2)

        Label {
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            text: shortcutRow.actionLabel
            elide: Text.ElideRight
        }

        Rectangle {
            anchors {
                top: parent.top
                bottom: parent.bottom
            }
            width: units.dp(1)
            color: theme.palette.normal.base
        }

        Label {
            Layout.minimumWidth: units.gu(16)
            verticalAlignment: Text.AlignVCenter
            text: shortcutEditor.editing ? i18n.tr("Enter shortcut…")
                                         : (shortcutEditor.sequence ? shortcutEditor.label
                                                                    : i18n.tr("Disabled"))
            elide: Text.ElideRight
        }
    }
}
