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

        actions: [
            Action {
                text: "SCR"
                description: "Scroll Keys"
                onTriggered: keyboardLoader.source = "KeyboardRows/Layouts/ScrollKeysLayout.qml"
            },
            Action {
                text: "FN"
                description: "Functions Keys"
                onTriggered: keyboardLoader.source = "KeyboardRows/Layouts/FunctionKeysLayout.qml"
            },
            Action {
                text: "CMD"
                description: "Command Keys"
                onTriggered: keyboardLoader.source = "KeyboardRows/Layouts/SimpleCommandsLayout.qml"
            },
            Action {
                text: "CTRL"
                description: "Control Keys"
                onTriggered: keyboardLoader.source = "KeyboardRows/Layouts/ControlKeysLayout.qml"
            }
        ]
    }

    signal simulateCommand(string command);
    signal simulateKey(int key, int mod);

    onSimulateKey: pressFeedbackEffect.start();
    onSimulateCommand: pressFeedbackEffect.start();

    Loader {
        id: keyboardLoader
        anchors.left: keyboardSelector.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.top: parent.top
        source: "KeyboardRows/Layouts/ScrollKeysLayout.qml"

        onLoaded: {
            item.keyHeight = parent.height
            item.simulateKey.connect(simulateKey);
            item.simulateCommand.connect(simulateCommand);
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
