import QtQuick 2.0
import Ubuntu.Components 1.1
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

        session: QMLTermSession {
            id: terminalSession
            initialWorkingDirectory: "$HOME"
        }

        QMLTermScrollbar {
            z: parent.z + 2
            terminal: parent
            width: units.dp(4)
            Rectangle {
                // TODO Customize the appearence of the scrollbar.
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
