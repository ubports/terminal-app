/*
 * Copyright (C) 2015 Canonical Ltd
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
 * Authored-by: Niklas Wenzel <nikwen.developer@gmail.com>
 */
import QtQuick 2.4

Item {
    function handle(event) {
        if (event.modifiers & Qt.ControlModifier) {
            if (event.modifiers & Qt.ShiftModifier) {
                event.accepted = true; // That way shortcuts will not be processed by the terminal widget (Ctrl + Shift is always interpreted as a shortcut)

                switch (event.key) {
                // Window/tab handling
                case Qt.Key_N: // Open new window
                    terminalAppRoot.createTerminalWindow();
                    break;
                case Qt.Key_T: // Open tab
                    tabsModel.addTab();
                    break;
                case Qt.Key_W: //Close tab
                    tabsModel.removeTabWithSession(terminalSession);
                    break;
                case Qt.Key_Q: //Close window
                    for (var i = tabsModel.count - 1; i >= 0; i--) {
                        tabsModel.removeTab(i);
                    }
                    break;

                // Clipboard
                case Qt.Key_C: // Copy
                    terminal.copyClipboard();
                    break;
                case Qt.Key_V: // Paste
                    terminal.pasteClipboard();
                    break;
                }
            }

            // The following may not reside in an else to the above if, as some keyboard layouts require
            // to press the shift key in order to type the plus character (and possibly others).
            // Do not automatically accept all keys here! Programs like nano may declare their own Ctrl-shortcuts.

            switch (event.key) {
            // Font size
            case Qt.Key_Plus: // Zoom in
                event.accepted = true;
                settings.fontSize = Math.min(settings.fontSize + 1, settings.maxFontSize);
                break;
            case Qt.Key_Minus: // Zoom out
                event.accepted = true;
                settings.fontSize = Math.max(settings.fontSize - 1, settings.minFontSize);
                break;
            case Qt.Key_0: // Normal size
                event.accepted = true;
                settings.fontSize = settings.defaultFontSize;
                break;

            // Tab switching
            case Qt.Key_PageUp: // Previous tab
                event.accepted = true;
                tabsModel.selectTab((tabsModel.selectedIndex - 1 + tabsModel.count) % tabsModel.count);
                break;
            case Qt.Key_PageDown: // Next tab
                event.accepted = true;
                tabsModel.selectTab((tabsModel.selectedIndex + 1) % tabsModel.count);
                break;
            }
        } else {
            switch (event.key) {
            case Qt.Key_F11: // Fullscreen
                event.accepted = true;
                terminalWindow.toggleFullscreen();
                break;
            }
        }
    }
}
