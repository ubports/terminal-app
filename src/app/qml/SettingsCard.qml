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

Rectangle {
    id: settingsCard
    
    property string title
    property real margins: units.gu(2)
    default property alias contentItem: content.children
    
    width: parent.width
    height: content.height
            + content.anchors.topMargin + content.anchors.bottomMargin
    color: theme.palette.normal.overlay
    
    Label {
        id: titleLabel
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: settingsCard.margins
            leftMargin: settingsCard.margins
            rightMargin: settingsCard.margins
        }
        text: settingsCard.title
        textSize: Label.Large
        elide: Text.ElideRight
    }
    
    Item {
        id: content
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            leftMargin: settingsCard.margins
            rightMargin: settingsCard.margins
            topMargin: settingsCard.margins + titleLabel.height + units.gu(1)
            bottomMargin: settingsCard.margins
        }
        
        height: childrenRect.height
    }
}
