/*
 * Copyright (C) 2014-2017 Canonical Ltd
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
 * Authored-by: Filippo Scognamiglio <flscogna@gmail.com>
 *              Florian Boucault <florian.boucault@canonical.com>
 */
import QtQuick 2.5
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

ActionSelectionPopover {
    id: popover

    contentWidth: units.gu(30)
    delegate: ListItem {
        divider.visible: action.divider ? true : false
        enabled: action.enabled

        Shortcut {
            id: shortcut
            enabled: false
            sequence: action.shortcut
        }

        Item {
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: units.gu(3)
                rightMargin: units.gu(2)
            }

            height: childrenRect.height
            anchors.verticalCenter: parent.verticalCenter
            Label {
                text: action.text
                textSize: Label.Small
                color: theme.palette.normal.overlayText
                opacity: action.enabled ? 1.0 : 0.4
            }
            Label {
                anchors.right: parent.right
                text: shortcut.portableText
                textSize: Label.Small
                color: theme.palette.normal.overlayText
                opacity: 0.4
            }
        }
        onClicked: popover.hide()
        visible: action.visible
        height: units.gu(4.5)
    }

    actions: ActionList {
        Action {
            text: i18n.tr("Select")
            onTriggered: terminalPage.state = "SELECTION";
            visible: !QuickUtils.keyboardAttached
        }
        Action {
            text: i18n.tr("Copy")
            enabled: !terminal.isSelectionEmpty()
            onTriggered: terminal.copyClipboard();
            shortcut: settings.shortcutCopy
        }
        Action {
            text: i18n.tr("Paste")
            enabled: !terminal.isClipboardEmpty()
            onTriggered: terminal.pasteClipboard();
            shortcut: settings.shortcutPaste
            property bool divider: true
        }
        Action {
            text: i18n.tr("Split horizontally")
            onTriggered: tiledTerminalView.splitTerminal(terminal, Qt.Vertical)
            shortcut: settings.shortcutSplitHorizontally
            enabled: terminal.height >= 2 * tiledTerminalView.minimumTileHeight
        }
        Action {
            text: i18n.tr("Split vertically")
            onTriggered: tiledTerminalView.splitTerminal(terminal, Qt.Horizontal)
            shortcut: settings.shortcutSplitVertically
            enabled: terminal.width >= 2 * tiledTerminalView.minimumTileWidth
            property bool divider: true
        }
        Action {
            text: i18n.tr("New tab")
            onTriggered: tabsModel.addTerminalTab()
            shortcut: settings.shortcutNewTab
        }
        Action {
            text: i18n.tr("New window")
            onTriggered: terminalAppRoot.createTerminalWindow()
            shortcut: settings.shortcutNewWindow
        }
        Action {
            text: i18n.tr("Close")
            onTriggered: terminal.finished()
            shortcut: settings.shortcutCloseTab
        }
    }
}
