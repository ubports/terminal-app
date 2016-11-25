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
 * Authored-by: Filippo Scognamiglio <flscogna@gmail.com>
 */
import QtQuick 2.4

ListModel {
    property int selectedIndex: -1
    property var selectedTerminal

    id: tabsModel

    property Component terminalComponent: TerminalComponent {}

    function addTab() {
        var initialWorkingDirectory;
        if (selectedTerminal) {
            initialWorkingDirectory = selectedTerminal.session.getWorkingDirectory();
        } else {
            initialWorkingDirectory = "$HOME";
        }

        var termObject = terminalComponent.createObject(terminalPage.terminalContainer,
                                                        {"initialWorkingDirectory": initialWorkingDirectory});
        tabsModel.append({terminal: termObject});
        if (selectedIndex == -1) {
            selectedIndex = 0;
        }

        termObject.visible = false;
        tabsModel.selectTab(tabsModel.count - 1);
    }

    function __disableTerminal(term) {
        term.visible = false;
        term.z = 0;
        term.focus = false;
        terminalPage.terminal = null;
    }

    function __enableTerminal(term) {
        term.visible = true;
        term.z = 1;
        term.forceActiveFocus();
        terminalPage.terminal = term;
    }

    function selectTab(index) {
        if (index < 0 || index >= tabsModel.count) return;

        __disableTerminal(get(selectedIndex).terminal);
        selectedTerminal = get(index).terminal;
        __enableTerminal(selectedTerminal);
        selectedIndex = index;
    }

    function removeTabWithSession(session) {
        for (var i = 0; i < count; i++) {
            if (session === get(i).terminal.session) {
                removeTab(i);
                return;
            }
        }
    }

    function removeTab(index) {
        if (count === 0 || index >= count)
            return;

        get(index).terminal.destroy();
        remove(index);

        // Decrease the selected index to keep the state consistent.
        if (index <= selectedIndex)
            selectedIndex = Math.max(selectedIndex - 1, 0);
        selectTab(selectedIndex);
    }

    function moveTab(from, to) {
        if (from == to
            || from < 0 || from >= tabsModel.count
            || to < 0 || to >= tabsModel.count) {
            return false;
        }

        tabsModel.move(from, to, 1);
        if (selectedIndex == from) {
            selectedIndex = to;
        }
        return true;
    }
}
