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
import Ubuntu.Components.Popups 1.3
import QMLTermWidget 1.0
import Terminal 0.1

QMLTermWidget {
    id: terminal
    width: parent.width
    height: parent.height

    colorScheme: settings.colorScheme
    font.family: settings.fontStyle
    font.pixelSize: FontUtils.sizeToPixels("medium") * settings.fontSize / 10

    property bool isDarkBackground: ColorUtils.luminance(backgroundColor) <= 0.85
    property color contourColor: isDarkBackground ? Qt.rgba(1.0, 1.0, 1.0, 0.4) : Qt.rgba(0.0, 0.0, 0.0, 0.2)
    property string initialWorkingDirectory
    signal finished()

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
        onFinished: terminal.finished()
    }

    property int totalLines: terminal.scrollbarMaximum - terminal.scrollbarMinimum + terminal.lines

    Component.onCompleted: {
        terminalSession.startShellProgram();
        forceActiveFocus();
    }

    // TODO: This invisible button is used to position the popover where the
    // alternate action was called. Terrible terrible workaround!
    Item {
        id: hiddenButton
        width: 1
        height: 1
        visible: false
        enabled: false
    }

    TerminalInputArea {
        id: inputArea
        enabled: terminalPage.state != "SELECTION"
        anchors.fill: parent
        // FIXME: should anchor to the bottom of the window to cater for the case when the OSK is up

        // This is the minimum wheel event registered by the plugin (with the current settings).
        property real wheelValue: 40

        // This is needed to fake a "flickable" scrolling.
        swipeDelta: terminal.fontMetrics.height

        // Mouse actions
        onMouseMoveDetected: terminal.simulateMouseMove(x, y, button, buttons, modifiers);
        onDoubleClickDetected: terminal.simulateMouseDoubleClick(x, y, button, buttons, modifiers);
        onMousePressDetected: {
            terminal.forceActiveFocus();
            terminal.simulateMousePress(x, y, button, buttons, modifiers);
        }
        onMouseReleaseDetected: terminal.simulateMouseRelease(x, y, button, buttons, modifiers);
        onMouseWheelDetected: terminal.simulateWheel(x, y, buttons, modifiers, angleDelta);

        // Touch actions
        onTouchPress: terminal.forceActiveFocus()
        onTouchClick: terminal.simulateKeyPress(Qt.Key_Tab, Qt.NoModifier, true, 0, "");
        onTouchPressAndHold: alternateAction(x, y);

        // Swipe actions
        onSwipeYDetected: {
            if (steps > 0) {
                simulateSwipeDown(steps);
            } else {
                simulateSwipeUp(-steps);
            }
        }
        onSwipeXDetected: {
            if (steps > 0) {
                simulateSwipeRight(steps);
            } else {
                simulateSwipeLeft(-steps);
            }
        }
        onTwoFingerSwipeYDetected: {
            if (steps > 0) {
                simulateDualSwipeDown(steps);
            } else {
                simulateDualSwipeUp(-steps);
            }
        }

        function simulateSwipeUp(steps) {
            while(steps > 0) {
                terminal.simulateKeyPress(Qt.Key_Up, Qt.NoModifier, true, 0, "");
                steps--;
            }
        }
        function simulateSwipeDown(steps) {
            while(steps > 0) {
                terminal.simulateKeyPress(Qt.Key_Down, Qt.NoModifier, true, 0, "");
                steps--;
            }
        }
        function simulateSwipeLeft(steps) {
            while(steps > 0) {
                terminal.simulateKeyPress(Qt.Key_Left, Qt.NoModifier, true, 0, "");
                steps--;
            }
        }
        function simulateSwipeRight(steps) {
            while(steps > 0) {
                terminal.simulateKeyPress(Qt.Key_Right, Qt.NoModifier, true, 0, "");
                steps--;
            }
        }
        function simulateDualSwipeUp(steps) {
            while(steps > 0) {
                terminal.simulateWheel(width * 0.5, height * 0.5, Qt.NoButton, Qt.NoModifier, Qt.point(0, -wheelValue));
                steps--;
            }
        }
        function simulateDualSwipeDown(steps) {
            while(steps > 0) {
                terminal.simulateWheel(width * 0.5, height * 0.5, Qt.NoButton, Qt.NoModifier, Qt.point(0, wheelValue));
                steps--;
            }
        }

        // Semantic actions
        onAlternateAction: {
            // Force the hiddenButton in the event position.
            hiddenButton.x = x;
            hiddenButton.y = y;
            PopupUtils.open(Qt.resolvedUrl("AlternateActionPopover.qml"),
                            hiddenButton);
        }
    }

    QMLTermScrollbar {
        anchors.fill: parent
        terminal: terminal
    }
}
