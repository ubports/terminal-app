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
    id: tabsModel

    // FIXME: compatibility layer for TabsBar
    property alias selectedIndex: tabsModel.currentIndex
    function selectTab(index) {
        if (index >= 0 && index < tabsModel.count) {
            currentIndex = index;
        }
    }
    function removeTab(index) {
        removeItem(index);
    }
    function moveTab(from, to) {
        moveItem(from, to);
    }

    property Component tiledViewComponent: TiledTerminalView {}

    function addTerminalTab(initialWorkingDirectory) {
        if (currentItem) {
            initialWorkingDirectory = currentItem.focusedTerminal.session.getWorkingDirectory();
        }

        var tiledView = tiledViewComponent.createObject(terminalPage.terminalContainer,
                                                        {"initialWorkingDirectory": initialWorkingDirectory,
                                                         "visible": Qt.binding(function () { return tabsModel.currentItem === tiledView})});
        tiledView.emptied.connect(function () {tabsModel.removeItem(tabsModel.indexOf(tiledView));})
        tabsModel.addItem(tiledView);
        currentIndex = tabsModel.count - 1;
    }


    function incrementCurrentIndex() {
        currentIndex = (tabsModel.currentIndex + 1) % tabsModel.count;
    }

    function decrementCurrentIndex() {
        currentIndex = (tabsModel.currentIndex - 1 + tabsModel.count) % tabsModel.count;
    }

    function removeAllItems() {
        for (var i = tabsModel.count - 1; i >= 0; i--) {
            tabsModel.removeItem(i);
        }
    }

    function indexOf(value) {
        for (var i = 0; i < count; i++) {
            if (itemAt(i) === value) {
                return i;
            }
        }
        return -1;
    }


    // QtQuick Controls 2 TabBar compatible API
    property int currentIndex: -1
    readonly property Item currentItem: itemAt(currentIndex)

    function addItem(item) {
        tabsModel.append({"item": item});
    }

    function itemAt(index) {
        if (index < 0 || index >= count)
            return null;

        return get(index)["item"];
    }

    function removeItem(index) {
        if (index < 0 || index >= count)
            return;

        itemAt(index).destroy();
        remove(index);

        // Decrease the selected index to keep the state consistent.
        if (index <= currentIndex)
            currentIndex = Math.max(currentIndex - 1, 0);
    }


    function moveItem(from, to) {
        if (from == to
            || from < 0 || from >= tabsModel.count
            || to < 0 || to >= tabsModel.count) {
            return;
        }

        tabsModel.move(from, to, 1);
        if (currentIndex == from) {
            currentIndex = to;
        }
    }
}
