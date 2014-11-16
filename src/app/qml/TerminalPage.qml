import QtQuick 2.0
import Ubuntu.Components 1.0
import QMLTermWidget 1.0

Page {
    id: terminalPage
    property alias terminalContainer: terminalContainer
    property Item terminal

    anchors.fill: parent

    Item {
        id: terminalContainer

        anchors {
            left: parent.left;
            top: parent.top;
            right: parent.right;
            bottom: keyboardBar.top
        }
    }

    TerminalInputArea{
        id: inputArea
        anchors.fill: parent
        enabled: terminal

        // Mouse actions
        onMouseMoveDetected: terminal.simulateMouseMove(x, y, button, buttons, modifiers);
        onDoubleClickDetected: terminal.simulateMouseDoubleClick(x, y, button, buttons, modifiers);
        onMousePressDetected: terminal.simulateMousePress(x, y, button, buttons, modifiers);
        onMouseReleaseDetected: terminal.simulateMouseRelease(x, y, button, buttons, modifiers);
        onMouseWheelDetected: terminal.simulateWheel(x, y, buttons, modifiers, angleDelta);

        // Touch actions
        onSwipeUpDetected: terminal.simulateKeyPress(Qt.Key_Up, Qt.NoModifier, true, 0, "");
        onSwipeDownDetected: terminal.simulateKeyPress(Qt.Key_Down, Qt.NoModifier, true, 0, "");
        onTouchPress: terminal.simulateKeyPress(Qt.Key_Tab, Qt.NoModifier, true, 0, "");

        // Semantic actions
        onAlternateAction: {
            PopupUtils.open(alternateActionPopover, terminal);
        }
    }

    KeyboardBar {
        id: keyboardBar
        height: units.gu(5)
        anchors {left: parent.left; right: parent.right}

        y: parent.height - height - Qt.inputMethod.keyboardRectangle.height
        z: parent.z + 0.1

        onSimulateKey: terminal.simulateKeyPress(key, mod, true, 0, "");
    }

    // TODO This is really really bad and has to improve.
    // Floating Keyboard button.
    Rectangle {
        anchors {
            bottom: parent.bottom;
            right: parent.right;
            margins: units.gu(2);
            bottomMargin: keyboardBar.height
        }
        color: "black"
        opacity: 0.3
        width: units.gu(7)
        height: width
        radius: width * 0.5
        border.color: "white"
        border.width: units.gu(1)
        z: 2

        Text {
            anchors.centerIn: parent
            color: "white"
            text: "VKB"
        }

        MouseArea{
            anchors.fill: parent
            onPressed: {
                Qt.inputMethod.show();
                terminal.forceActiveFocus();
            }
        }
    }
}
