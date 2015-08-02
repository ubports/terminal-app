import QtQuick 2.4
import Ubuntu.Components 1.2
import Ubuntu.Components.Popups 1.0

Component {
    id: popoverComponent

    ActionSelectionPopover {
        id: popover

        actions: ActionList {
            Action {
                text: i18n.tr("Select")
                onTriggered: terminalPage.state = "SELECTION";
            }
            Action {
                text: i18n.tr("Copy")
                onTriggered: terminal.copyClipboard();
            }
            Action {
                text: i18n.tr("Paste")
                onTriggered: terminal.pasteClipboard();
            }
        }
    }
}
