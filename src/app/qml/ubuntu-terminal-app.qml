import QtQuick 2.3
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 0.1

import QMLTermWidget 1.0

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    id: mview
    objectName: "terminal"
    applicationName: "com.ubuntu.terminal"
    automaticOrientation: true

    width: units.gu(50)
    height: units.gu(75)

    AuthenticationService {
        onDenied: Qt.quit()
    }

    AlternateActionPopover {
        id: alternateActionPopover
    }

    Page {
        id: terminalPage
        anchors.fill: parent

        QMLTermWidget {
            id: terminal
            anchors {
                left: parent.left;
                top: parent.top;
                right: parent.right;
                bottom: keyboardBar.top
            }
            colorScheme: "DarkPastels"

            session: QMLTermSession {
                id: terminalSession
                initialWorkingDirectory: "$HOME"
            }

            QMLTermScrollbar {
                terminal: terminal
                width: 20
                Rectangle {
                    anchors.fill: parent
                }
            }

            TerminalInputArea{
                id: inputArea
                anchors.fill: parent

                // Mouse actions
                onMouseMoveDetected: terminal.simulateMouseMove(x, y, button, buttons, modifiers);
                onDoubleClickDetected: terminal.simulateMouseDoubleClick(x, y, button, buttons, modifiers);
                onMousePressDetected: terminal.simulateMousePress(x, y, button, buttons, modifiers);
                onMouseReleaseDetected: terminal.simulateMouseRelease(x, y, button, buttons, modifiers);
                onMouseWheelDetected: terminal.simulateWheel(x, y, buttons, modifiers, angleDelta);

                // Touch actions
                onSwipeUpDetected: terminal.simulateKeyPress(Qt.Key_Up, Qt.NoModifier, true, 0, "");
                onSwipeDownDetected: terminal.simulateKeyPress(Qt.Key_Down, Qt.NoModifier, true, 0, "");
                onTouchPress: terminal.simulateKeyPress(Qt.Key_Tab, Qt.NoModifier, true, 0, "");

                // Semantic actions
                onAlternateAction: {
                    PopupUtils.open(alternateActionPopover, terminal);
                }
            }

            font.pointSize: 14
            font.family: "Ubuntu Mono"

            Component.onCompleted: {
                terminalSession.startShellProgram();
                forceActiveFocus();
            }
        }

        KeyboardBar {
            id: keyboardBar
            height: units.gu(5)
            anchors {left: parent.left; right: parent.right}

            y: parent.height - height - Qt.inputMethod.keyboardRectangle.height
            z: parent.z + 0.1

            onSimulateKey: terminal.simulateKeyPress(key, mod, true, 0, "");
        }

        // Floating Keyboard button
        Rectangle {
            anchors {
                bottom: parent.bottom;
                right: parent.right;
                margins: units.gu(2);
                bottomMargin: keyboardBar.height
            }
            color: "black"
            opacity: 0.3
            width: units.gu(7)
            height: width
            radius: width * 0.5
            border.color: "white"
            border.width: units.gu(1)
            z: 2

            Text {
                anchors.centerIn: parent
                color: "white"
                text: "VKB"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: {
                    Qt.inputMethod.show();
                    terminal.forceActiveFocus();
                }
            }
        }
    }
}
