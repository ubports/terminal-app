import QtQuick 2.4
import Ubuntu.Components 1.2

Rectangle {
    id: container

    property string name
    property string short_name

    property var model: []
    property real keyWidth: units.gu(5)
    property real keyHeight: units.gu(5)

    // External signals.
    signal simulateKey(int key, int mod);
    signal simulateCommand(string command);

    // Internal variables
    property int _firstVisibleIndex: gridView.contentX / keyWidth
    property int _lastVisibleIndex: _firstVisibleIndex + gridView.width / keyWidth
    property int _avgIndex: (_lastVisibleIndex + _firstVisibleIndex) / 2

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
            property Action modelMainAction: container.model[index].mainAction
            width: keyWidth
            height: keyHeight

            Loader {
                anchors.fill: parent
                sourceComponent: (delegateContainer.modelActions.length > 0) ? expandable : nonExpandable
            }
            Component {
                id: nonExpandable
                KeyboardButton {
                    anchors.fill: parent
                    text: delegateContainer.modelText
                    mainAction: delegateContainer.modelMainAction
                }
            }
            Component {
                id: expandable
                ExpandableKeyboardButton {
                    anchors.fill: parent
                    text: delegateContainer.modelText
                    mainAction: delegateContainer.modelMainAction
                    actions: delegateContainer.modelActions
                    expandable: !gridView.movingHorizontally
                    expandRight: delegateContainer.modelIndex <= container._avgIndex
                }
            }
        }
    }
}
