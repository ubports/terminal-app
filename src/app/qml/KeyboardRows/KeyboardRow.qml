import QtQuick 2.0
import Ubuntu.Components 1.1

Rectangle {
    id: container
    property list<QtObject> model
    property real keyWidth: units.gu(5)
    property real keyHeight: units.gu(5)

    // External signals.
    signal simulateKey(int key, int mod);
    signal simulateCommand(string command);

    color: "black"

    GridView {
        id: gridView
        model: parent.model
        anchors.fill: parent
        cellWidth: keyWidth
        cellHeight: keyHeight
        delegate: keyDelegate
        flow: GridView.TopToBottom
        snapMode: GridView.SnapToRow
    }

    Rectangle {
        id: topBar
        anchors.top: parent.top
        height: units.dp(2)
        color: UbuntuColors.orange;

        width: parent.width
    }

    Rectangle {
        id: scrollBar
        anchors.bottom: parent.bottom
        height: units.dp(2)
        color: UbuntuColors.orange;

        width: gridView.visibleArea.widthRatio * gridView.width
        x: gridView.visibleArea.xPosition * gridView.width
    }

    Component {
        id: keyDelegate
        Rectangle {
            id: delegateContainer
            property int modelIndex: index
            property string modelText: container.model[index].text
            property var modelActions: container.model[index].actions
            width: keyWidth
            height: keyHeight

            Loader {
                anchors.fill: parent
                sourceComponent: (delegateContainer.modelActions.length > 1) ? expandable : nonExpandable
            }
            Component {
                id: nonExpandable
                KeyboardButton {
                    anchors.fill: parent
                    text: delegateContainer.modelText
                    action: delegateContainer.modelActions[0]
                }
            }
            Component {
                id: expandable
                ExpandableKeyboardButton {
                    anchors.fill: parent
                    text: delegateContainer.modelText
                    actions: delegateContainer.modelActions
                    expandable: !gridView.movingHorizontally
                }
            }
        }
    }
}
