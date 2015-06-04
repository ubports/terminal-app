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
    id: rootItem
    objectName: "layoutsPage"

    title: i18n.tr("Layouts")

    onVisibleChanged: {
        if (visible === false)
            settings.profilesChanged();
    }

    ListView {
        anchors.fill: parent
        model: settings.profilesList
        delegate: ListItem.Standard {
            control: Switch {
                checked: profileVisible
                onCheckedChanged: {
                    settings.profilesList.setProperty(index, "profileVisible", checked);
                }
            }
            text: name
        }
    }
}
