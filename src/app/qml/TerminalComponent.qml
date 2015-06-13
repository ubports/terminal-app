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

            onFinished: tabsModel.removeTabWithSession(terminalSession);
        }

        Keys.onPressed: { // Keyboard shortcuts
            if (event.modifiers & Qt.ControlModifier) {
                if (event.modifiers & Qt.ShiftModifier) {
                    event.accepted = true; // That way shortcuts will not be processed by the terminal widget (Ctrl + Shift is always interpreted as a shortcut)

                    switch (event.key) {
                    // Window/tab handling
                    case Qt.Key_T: // Open tab
                        tabsModel.addTab();
                        tabsModel.selectTab(tabsModel.count - 1);
                        break;
                    case Qt.Key_W: //Close tab
                        tabsModel.removeTabWithSession(terminalSession);
                        break;
                    case Qt.Key_Q: //Close window
                        for (var i = tabsModel.count - 1; i >= 0; i--) {
                            tabsModel.removeTab(i); // This will also call Qt.quit()
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
