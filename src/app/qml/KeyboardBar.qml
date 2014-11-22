import QtQuick 2.0
import Ubuntu.Components 1.1
import "KeyboardRows"

Rectangle {
    color: "black"

    PressFeedback {
        id: pressFeedbackEffect
    }

    // TODO: What do we do with this control from a design perspective?
    ExpandableButton {
        id: keyboardSelector
        height: parent.height
        width: parent.height
        size: parent.height
        z: parent.z + 0.01

        rotation: 3

        childComponent: Component {
            Rectangle {
                color: "black"
            }
        }

        Rectangle {
            anchors.fill: parent
            color: UbuntuColors.orange

            Icon {
                scale: 0.5
                anchors.fill: parent
                name: "keypad"
                color: "black"
            }
        }

        // TODO: We need way to show the users descriptions of key rows.
        actions: [
            Action {
                text: "SCR"
                description: "Scroll Keys"
                onTriggered: keyboardLoader.source = "KeyboardRows/ScrollKeyboardRow.qml"
            },
            Action {
                text: "FN"
                description: "Functions Keys"
                onTriggered: keyboardLoader.source = "KeyboardRows/FunctionsKeyboardRows.qml"
            },
            Action {
                text: "CTRL"
                description: "Control Keys"
                onTriggered: keyboardLoader.source = "KeyboardRows/CtrlKeyboardRow.qml"
            }
        ]
    }

    signal simulateKey(int key, int mod);
    onSimulateKey: pressFeedbackEffect.start();

    Loader {
        id: keyboardLoader
        anchors.left: keyboardSelector.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.top: parent.top
        source: "KeyboardRows/ScrollKeyboardRow.qml"

        onLoaded: {
            item.keyHeight = parent.height
            item.simulateKey.connect(simulateKey);
        }

        Rectangle {
            property string defaultString: qsTr("Change Keyboard");

            id: toolTip

            Connections {
                property alias index: keyboardSelector.selectedIndex
                property alias text: tooltipLabel.text

                target: keyboardSelector
                onSelectedIndexChanged: {
                    text = index >= 0
                                   ? keyboardSelector.actions[index].description
                                   : toolTip.defaultString
                }
            }

            visible: keyboardSelector.expanded

            anchors.fill: parent
            color: "Black"
            opacity: 0.8
            z: parent.z + 0.1

            Label {
                z: parent.z + 0.1
                id: tooltipLabel
                text: toolTip.defaultString
                anchors.centerIn: parent
                color: "white"
            }
        }
    }
}
