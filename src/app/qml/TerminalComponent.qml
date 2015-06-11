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

        signal sessionFinished(var session);

        session: QMLTermSession {
            id: terminalSession
            initialWorkingDirectory: workdir

            onFinished: terminal.sessionFinished(terminalSession);
        }

        Keys.onPressed: {
            if ((event.modifiers & Qt.ShiftModifier) && (event.modifiers & Qt.ControlModifier)) {
                event.accepted = true; //That way shortcuts will not be processed by the terminal widget

                switch (event.key) {
                case Qt.Key_T:
                    tabsModel.addTab();
                    tabsModel.selectTab(tabsModel.count - 1);
                    break;
                case Qt.Key_W:
                    tabsModel.removeTabWithSession(terminalSession);
                    break;
                case Qt.Key_Q:
                    for (var i = tabsModel.count - 1; i >= 0; i--) {
                        tabsModel.removeTab(i); //This will also call Qt.quit()
                    }
                    break;
                }
            }
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
