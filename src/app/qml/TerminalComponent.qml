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
import Ubuntu.Components 1.3
import QMLTermWidget 1.0

Component {
    id: terminalComponent

    QMLTermWidget {
        id: terminal
        width: parent.width
        height: parent.height

        colorScheme: settings.colorScheme
        font.family: settings.fontStyle
        font.pixelSize: FontUtils.sizeToPixels("medium") * settings.fontSize / 10

        // WORKAROUND: Mir/QtMir does not support drag&drop yet, therefore we need
        // to disable this functionality (see lp:1488588).
        dragMode: QMLTermWidget.NoDrag

        signal sessionFinished(var session);

        session: QMLTermSession {
            id: terminalSession
            initialWorkingDirectory: workdir

            onFinished: tabsModel.removeTabWithSession(terminalSession);
        }

        Keys.onPressed: {
            keyboardShortcutHandler.handle(event)
        }

        TerminalKeyboardShortcutHandler {
            id: keyboardShortcutHandler
        }

        QMLTermScrollbar {
            z: parent.z + 2
            terminal: parent
            width: units.dp(2)
            Rectangle {
                anchors.fill: parent
                color: UbuntuColors.orange
            }
        }

        Component.onCompleted: {
            terminalSession.startShellProgram();
            forceActiveFocus();
        }
    }
}
