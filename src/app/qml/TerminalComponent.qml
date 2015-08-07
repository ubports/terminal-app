import QtQuick 2.4
import Ubuntu.Components 1.2
import QMLTermWidget 1.0

Component {
    id: terminalComponent

    QMLTermWidget {
        id: terminal
        width: parent.width
        height: parent.height

        colorScheme: settings.colorScheme
        font.family: settings.fontStyle
        font.pointSize: settings.fontSize

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
