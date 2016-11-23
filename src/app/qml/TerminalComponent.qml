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

QMLTermWidget {
    id: terminal
    width: parent.width
    height: parent.height

    colorScheme: settings.colorScheme
    font.family: settings.fontStyle
    font.pixelSize: FontUtils.sizeToPixels("medium") * settings.fontSize / 10

    signal sessionFinished(var session);

    session: QMLTermSession {
        id: terminalSession
        initialWorkingDirectory: workdir
        shellProgram: (terminalAppRoot.sshMode ? "sshpass" : "bash")
        shellProgramArgs: (terminalAppRoot.sshMode ?
            ["-p", terminalAppRoot.userPassword,
             "ssh", "-t",
             "-o", "UserKnownHostsFile=/dev/null",
             "-o", "StrictHostKeyChecking=no", "%1@localhost".arg(sshUser),
             "-o", "LogLevel=Error",
             "cd %1; bash".arg(workdir)]
            : [])
        onFinished: tabsModel.removeTabWithSession(terminalSession);
    }

    Keys.onPressed: {
        keyboardShortcutHandler.handle(event)
    }

    TerminalKeyboardShortcutHandler {
        id: keyboardShortcutHandler
    }

    property int totalLines: terminal.scrollbarMaximum - terminal.scrollbarMinimum + terminal.lines

    Component.onCompleted: {
        terminalSession.startShellProgram();
        forceActiveFocus();
    }
}
