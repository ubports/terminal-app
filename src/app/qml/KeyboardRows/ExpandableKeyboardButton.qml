import QtQuick 2.0
import Ubuntu.Components 1.1

import ".."

Item {
    property alias text: mainLabel.text
    property alias mainAction: expandableButton.mainAction
    property alias actions: expandableButton.actions
    property alias expandable: expandableButton.expandable

    Rectangle {
        width: parent.width
        anchors.top: parent.top
        height: units.dp(3)
        color: UbuntuColors.orange;
        z: parent.z + 1
    }

    Text {
        id: mainLabel
        anchors.centerIn: parent
        z: parent.z + 0.02
        color: UbuntuColors.orange;
    }

    ExpandableButton {
        id: expandableButton
        anchors.fill: parent

        z: parent.z + 0.01

        rotation: 3

        childComponent: Component {
            Rectangle {
                color: "black"
            }
        }
    }
}
