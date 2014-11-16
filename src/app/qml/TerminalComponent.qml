import QtQuick 2.0
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
            terminal: terminal
            width: units.gu(1)
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
