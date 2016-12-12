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
import Terminal 0.1

QMLTermWidget {
    id: terminal
    width: parent.width
    height: parent.height

    colorScheme: settings.colorScheme
    font.family: settings.fontStyle
    font.pixelSize: FontUtils.sizeToPixels("medium") * settings.fontSize / 10

    property string initialWorkingDirectory
    signal sessionFinished(var session);

    session: QMLTermSession {
        id: terminalSession
        initialWorkingDirectory: terminal.initialWorkingDirectory

        /* FIXME: this is a workaround to retrieve the current working directory
           of the shell executed by ssh.
           When opening an ssh session we write the PID of the shell process
           in a temporary file (sshShellPidFile) which is then used when needed
           to query its current working directory.
         */
        property string sshShellPidFile: "%1/%2_sshpid_%3".arg(StandardPaths.writableLocation(StandardPaths.AppDataLocation))
                                                          .arg(applicationPid)
                                                          .arg(sessionId)
        Component.onDestruction: FileIO.remove(sshShellPidFile);

        function getWorkingDirectory() {
            if (terminalAppRoot.sshMode) {
                var pid = FileIO.read(sshShellPidFile);
                // actual shell process is the first of the children of the process
                // executed by ssh
                pid = FileIO.read("/proc/%1/task/%1/children".arg(pid)).split(' ')[0];
                return FileIO.symLinkTarget("/proc/%1/cwd".arg(pid));
            } else {
                return workingDirectory;
            }
        }

        shellProgram: (terminalAppRoot.sshMode ? "sshpass" : "$SHELL")
        shellProgramArgs: (terminalAppRoot.sshMode ?
            ["-p", terminalAppRoot.userPassword,
             "ssh", "-t",
             "-o", "UserKnownHostsFile=/dev/null",
             "-o", "StrictHostKeyChecking=no", "%1@localhost".arg(sshUser),
             "-o", "LogLevel=Error",
             "mkdir -p `dirname %1`; echo -n $$ > %1; cd %2; bash".arg(sshShellPidFile).arg(initialWorkingDirectory)]
            : [])
        onFinished: tabsModel.removeItem(tabsModel.indexOf(terminal))
    }

    property int totalLines: terminal.scrollbarMaximum - terminal.scrollbarMinimum + terminal.lines

    Component.onCompleted: {
        terminalSession.startShellProgram();
        forceActiveFocus();
    }
}
