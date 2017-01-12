/*
 * Copyright (C) 2016-2017 Canonical Ltd
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
 * Authored-by: Florian Boucault <florian.boucault@canonical.com>
 */
import QtQuick 2.5
import Ubuntu.Components 1.3

TiledView {
    id: tiledTerminalView
    anchors.fill: parent

    property string initialWorkingDirectory
    property Terminal focusedTerminal
    signal emptied
    onCountChanged: if (count == 0) emptied()

    function splitTerminal(terminal, orientation) {
        var initialWorkingDirectory = focusedTerminal.session.getWorkingDirectory();
        var newTerminal = terminalComponent.createObject(tiledTerminalView,
                                                         {"initialWorkingDirectory": initialWorkingDirectory});
        tiledTerminalView.setOrientation(terminal, orientation);
        tiledTerminalView.add(terminal, newTerminal, Qt.AlignTrailing);
    }

    handleDelegate: Rectangle {
        implicitWidth: units.dp(1)
        implicitHeight: units.dp(1)
        color: focusedTerminal ? focusedTerminal.contourColor : ""
    }

    Component.onCompleted: {
        var newTerminal = terminalComponent.createObject(tiledTerminalView,
                                                         {"initialWorkingDirectory": initialWorkingDirectory});
        setRootItem(newTerminal);
    }

    function moveFocus(direction) {
        var terminal = tiledTerminalView.closestTileInDirection(focusedTerminal, direction);
        if (terminal) {
            terminal.focus = true;
        }
    }

    Shortcut {
        sequence: settings.shortcutMoveToTileRight
        enabled: tiledTerminalView.focus
        onActivated: moveFocus(Qt.AlignRight)
    }

    Shortcut {
        sequence: settings.shortcutMoveToTileLeft
        enabled: tiledTerminalView.focus
        onActivated: moveFocus(Qt.AlignLeft)
    }

    Shortcut {
        sequence: settings.shortcutMoveToTileAbove
        enabled: tiledTerminalView.focus
        onActivated: moveFocus(Qt.AlignTop)
    }

    Shortcut {
        sequence: settings.shortcutMoveToTileBelow
        enabled: tiledTerminalView.focus
        onActivated: moveFocus(Qt.AlignBottom)
    }

    property real minimumTileWidth: units.gu(10)
    property real minimumTileHeight: units.gu(10)
    property Component terminalComponent: Terminal {
        id: terminal
        Component.onCompleted: if (focus) tiledTerminalView.focusedTerminal = terminal
        onFocusChanged: if (focus) tiledTerminalView.focusedTerminal = terminal
        onFinished: {
            if (terminal.focus) {
                var nextTerminal = tiledTerminalView.closestTile(terminal);
                if (nextTerminal) nextTerminal.focus = true;
            }
            tiledTerminalView.remove(terminal);
            terminal.destroy();
        }
    }
}
