import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem
import Ubuntu.Components.Popups 1.0

Component {
    id: popoverComponent
    Popover {
        id: popover

        Column {
            id: containerLayout
            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
            }
            ListItem.Standard {
                text: i18n.tr("Copy")
                onClicked: {
                    terminal.copyClipboard();
                    popover.hide();
                }
            }
            ListItem.Standard {
                text: i18n.tr("Paste")
                onClicked: {
                    terminal.pasteClipboard();
                    popover.hide();
                }
            }
        }
    }
}
