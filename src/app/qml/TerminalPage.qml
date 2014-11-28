import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 0.1
import QMLTermWidget 1.0

Page {
    id: terminalPage
    property alias terminalContainer: terminalContainer
    property Item terminal

    anchors.fill: parent

    AlternateActionPopover {
        id: alternateActionPopover
    }

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

        // This is the minimum wheel event registered by the plugin (with the current settings).
        property real wheelValue: 40

        // This is needed to fake a "flickable" scrolling.
        swipeDelta: terminal.fontMetrics.height

        // Mouse actions
        onMouseMoveDetected: terminal.simulateMouseMove(x, y, button, buttons, modifiers);
        onDoubleClickDetected: terminal.simulateMouseDoubleClick(x, y, button, buttons, modifiers);
        onMousePressDetected: terminal.simulateMousePress(x, y, button, buttons, modifiers);
        onMouseReleaseDetected: terminal.simulateMouseRelease(x, y, button, buttons, modifiers);
        onMouseWheelDetected: terminal.simulateWheel(x, y, buttons, modifiers, angleDelta);

        // Touch actions
        onSwipeUpDetected: terminal.simulateWheel(width * 0.5, height * 0.5, Qt.NoButton, Qt.NoModifier, Qt.point(0, -wheelValue));
        onSwipeDownDetected: terminal.simulateWheel(width * 0.5, height * 0.5, Qt.NoButton, Qt.NoModifier, Qt.point(0, wheelValue));
        onTouchClick: terminal.simulateKeyPress(Qt.Key_Tab, Qt.NoModifier, true, 0, "");
        onTwoFingerSwipeUp: terminal.simulateKeyPress(Qt.Key_Up, Qt.NoModifier, true, 0, "");
        onTwoFingerSwipeDown: terminal.simulateKeyPress(Qt.Key_Down, Qt.NoModifier, true, 0, "");

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

    // Overlaying buttons.

    CircularTransparentButton {
        id: settingsButton

        anchors {top: parent.top; right: parent.right; margins: units.gu(1)}

        innerOpacity: 0.6
        border {color: UbuntuColors.orange; width: units.dp(2)}
        action: Action {
            iconName: "settings"
            onTriggered: pageStack.push(settingsPage);
        }
    }

    CircularTransparentButton {
        id: tabsButton

        anchors {top: settingsButton.bottom; right: parent.right; margins: units.gu(1)}

        innerOpacity: 0.6
        border {color: UbuntuColors.orange; width: units.dp(2)}
        action: Action {
            iconName: "browser-tabs"
            onTriggered: pageStack.push(tabsPage);
        }
    }

    CircularTransparentButton {
        id: keyboardButton

        anchors {right: parent.right; margins: units.gu(1)}

        y: parent.height - height - units.gu(1) - keyboardBar.height

        innerOpacity: 0.6
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
