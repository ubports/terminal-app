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

    CircularTransparentButton {
        id: settingsButton

        anchors {right: parent.right; margins: units.gu(1)}

        y: parent.height - height - units.gu(1) - keyboardBar.height

        opacity: 0.7
        color: "#99000000"
        border {color: UbuntuColors.orange; width: units.dp(2)}
        action: Action {
            text: "VKB"
            onTriggered: {
                Qt.inputMethod.show();
                terminal.forceActiveFocus();
            }
        }
    }
}
