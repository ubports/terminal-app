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
import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

ActionSelectionPopover {
    id: popover

    actions: ActionList {
        Action {
            text: i18n.tr("Select")
            onTriggered: terminalPage.state = "SELECTION";
        }
        Action {
            text: i18n.tr("Copy")
            enabled: !terminal.isSelectionEmpty()
            onTriggered: terminal.copyClipboard();
        }
        Action {
            text: i18n.tr("Paste")
            enabled: !terminal.isClipboardEmpty()
            onTriggered: terminal.pasteClipboard();
        }
        Action {
            text: i18n.tr("New tab")
            onTriggered: tabsModel.addTerminalTab()
        }
        Action {
            text: i18n.tr("New window")
            onTriggered: terminalAppRoot.createTerminalWindow()
        }
        Action {
            text: i18n.tr("Close")
            onTriggered: tabsModel.removeItem(tabsModel.indexOf(tabsModel.currentItem))
        }
    }
}
