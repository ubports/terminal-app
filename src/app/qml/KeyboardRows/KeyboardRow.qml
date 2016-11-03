/*
 * Copyright (C) 2014 Canonical Ltd
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
 * Author: Filippo Scognamiglio <flscogna@gmail.com>
 */
import QtQuick 2.4
import Ubuntu.Components 1.3

Rectangle {
    id: container

    property string name
    property string short_name

    property var model: []
    property real keyWidth: units.gu(5)
    property real keyHeight: units.gu(5)

    // External signals.
    signal simulateKey(int key, int mod);
    signal simulateCommand(string command);

    // Internal variables
    property int _firstVisibleIndex: gridView.contentX / keyWidth
    property int _lastVisibleIndex: _firstVisibleIndex + gridView.width / keyWidth
    property int _avgIndex: (_lastVisibleIndex + _firstVisibleIndex) / 2

    color: "black"
    property color textColor

    GridView {
        id: gridView
        model: parent.model
        anchors.fill: parent
        cellWidth: keyWidth
        cellHeight: keyHeight
        delegate: keyDelegate
        flow: GridView.TopToBottom
        snapMode: GridView.SnapToRow
    }

    Rectangle {
        id: scrollBar
        anchors.bottom: parent.bottom
        height: units.dp(2)
        // FIXME
        color: UbuntuColors.orange;

        width: gridView.visibleArea.widthRatio * gridView.width
        x: gridView.visibleArea.xPosition * gridView.width
        visible: gridView.visibleArea.widthRatio != 1.0
    }

    Component {
        id: keyDelegate
        Item {
            id: delegateContainer
            property int modelIndex: index
            property string modelText: container.model[index].text
            property var modelActions: container.model[index].actions
            property Action modelMainAction: container.model[index].mainAction
            width: keyWidth
            height: keyHeight

            Loader {
                anchors.fill: parent
                sourceComponent: (delegateContainer.modelActions.length > 0) ? expandable : nonExpandable
            }
            Component {
                id: nonExpandable
                KeyboardButton {
                    anchors.fill: parent
                    text: delegateContainer.modelText
                    mainAction: delegateContainer.modelMainAction
                    textColor: container.textColor
                }
            }
            Component {
                id: expandable
                ExpandableKeyboardButton {
                    anchors.fill: parent
                    text: delegateContainer.modelText
                    mainAction: delegateContainer.modelMainAction
                    actions: delegateContainer.modelActions
                    expandable: !gridView.movingHorizontally
                    expandRight: delegateContainer.modelIndex <= container._avgIndex
                    backgroundColor: container.color
                    textColor: container.textColor
                }
            }
        }
    }
}
