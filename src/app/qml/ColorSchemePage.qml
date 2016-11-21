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
    objectName: "colorSchemePage"

    header: PageHeader {
        title: i18n.tr("Color Scheme")
        flickable: listView
    }

    property alias model: listView.model
    property var namesModel

    readonly property string currentName: namesModel[listView.currentIndex]

    ScrollView {
        anchors.fill: parent
        ListView {
            id: listView
            anchors.fill: parent
            model: settings.profilesList
            currentIndex: model.indexOf(settings.colorScheme)
            delegate: ListItem {
                ListItemLayout {
                    anchors.verticalCenter: parent.verticalCenter
                    title.text: namesModel[model.index]

                    Icon {
                        SlotsLayout.position: SlotsLayout.Last
                        width: units.gu(2); height: units.gu(2)
                        color: UbuntuColors.green
                        name: "tick"

                        visible: model.index === listView.currentIndex
                    }
                }

                onClicked: listView.currentIndex = model.index
            }

            onCurrentIndexChanged: {
                settings.colorScheme = model[currentIndex];
            }
        }
    }
}
