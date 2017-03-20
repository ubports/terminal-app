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
 * Authored by: Florian Boucault <florian.boucault@canonical.com>
 */

import QtQuick 2.4
import QtQuick.Window 2.2

Window {
    id: settingsWindow

    visible: true
    title: i18n.tr("Terminal Preferences")
    color: settingsPage.windowColor
    contentOrientation: Screen.orientation

    width: settingsPage.implicitWidth
    height: settingsPage.implicitHeight
    minimumWidth: units.gu(40)
    minimumHeight: units.gu(30)

    SettingsPage {
        id: settingsPage
        anchors.fill: parent
    }
}
