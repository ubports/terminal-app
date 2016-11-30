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

import QtQuick 2.6
import Terminal 0.1

Item {
    id: shortcutEditor

    property bool editing: false
    property alias sequence: shortcut.sequence
    property string label: shortcut.nativeText

    signal finished()

    function start() {
        editing = true;
        forceActiveFocus();
    }

    function finish() {
        editing = false;
        finished();
    }

    onActiveFocusChanged: if (!activeFocus) finish();

    Shortcut {
        id: shortcut
    }

    function readShortcut(event) {
        if (event.key != Qt.Key_Shift
                && event.key != Qt.Key_Alt
                && event.key != Qt.Key_Control
                && event.key != Qt.Key_Meta) {
            return Shortcuts.keycodeToString(event.modifiers | event.key);
        }
        return "";
    }

    Keys.onPressed: {
        event.accepted = true;

        if (event.modifiers == Qt.NoModifier) {
            if (event.key == Qt.Key_Escape) {
                shortcutEditor.finish();
                return;
            } else if (event.key == Qt.Key_Backspace) {
                shortcutEditor.sequence = "";
                shortcutEditor.finish();
                return;
            }
        }

        var pressedSequence = readShortcut(event);
        if (pressedSequence) {
            shortcutEditor.sequence = pressedSequence;
            shortcutEditor.finish();
        }
    }
}
