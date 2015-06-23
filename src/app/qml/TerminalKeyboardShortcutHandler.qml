import QtQuick 2.0

Item {

    function handle(event) {
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

            // Tab switching
            case Qt.Key_PageUp: // Previous tab
                event.accepted = true;
                tabsModel.selectTab((tabsModel.selectedIndex - 1 + tabsModel.count) % tabsModel.count);
                break;
            case Qt.Key_PageDown: // Next tab
                event.accepted = true;
                tabsModel.selectTab((tabsModel.selectedIndex + 1) % tabsModel.count);
                break;
            }
        }
    }
}
