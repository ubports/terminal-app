import QtQuick 2.0
import Ubuntu.Components 1.1
import "KeyboardRows"

Rectangle {
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
                radius: width * 0.5
            }
        }

        parentComponent:  Component {
            Rectangle {
                z: parent.z + 0.001
                color: UbuntuColors.coolGrey
                anchors.fill: parent
                Rectangle {
                    anchors.fill: parent
                    color: "black"
                    radius: 0.5 * width
                }
            }
        }

        actions: [
            Action {text: "K1"; onTriggered: keyboardLoader.source = "KeyboardRows/ScrollKeyboardRow.qml"},
            Action {text: "K2"; onTriggered: keyboardLoader.source = "KeyboardRows/FunctionsKeyboardRows.qml"},
            Action {text: "K3"; onTriggered: keyboardLoader.source = "KeyboardRows/CtrlKeyboardRow.qml"}
        ]
    }

    signal simulateKey(int key, int mod);

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
    }
}
