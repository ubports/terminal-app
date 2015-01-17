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


    // TODO: This invisible button is used to position the popover where the
    // alternate action was called. Terrible terrible workaround!
    Button {
        id: hiddenButton
        width: 5
        height: 5
        visible: false
        enabled: false
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
        onTouchPressAndHold: alternateAction(x, y);

        // Semantic actions
        onAlternateAction: {
            // Force the hiddenButton in the event position.
            hiddenButton.x = x;
            hiddenButton.y = y;
            PopupUtils.open(alternateActionPopover, hiddenButton);
        }
    }

    KeyboardBar {
        id: keyboardBar
        height: units.gu(5)
        anchors {left: parent.left; right: parent.right}

        y: parent.height - height - Qt.inputMethod.keyboardRectangle.height
        z: parent.z + 0.1

        onSimulateKey: terminal.simulateKeyPress(key, mod, true, 0, "");
        onSimulateCommand: terminal.session.sendText(command);
    }

    Loader {
        id: bottomMessage
        anchors.fill: keyboardBar
        z: parent.z + 0.2
        active: false
        sourceComponent:  Rectangle {
            anchors.fill: parent
            color: "black"
            Text {
                anchors.centerIn: parent
                color: "white"
                text: i18n.tr("Selection Mode")
            }
        }
    }

    // Overlaying buttons.
    CircularTransparentButton {
        id: closeSelectionButton

        anchors {top: parent.top; right: parent.right; margins: units.gu(1)}

        visible: false
        innerOpacity: 0.6
        border {color: UbuntuColors.orange; width: units.dp(2)}
        action: Action {
            iconName: "close"
            onTriggered: {
                terminalPage.state = "DEFAULT";
                PopupUtils.open(alternateActionPopover, hiddenButton);
            }
        }
    }

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

    state: "DEFAULT"
    states: [
        State {
            name: "DEFAULT"
        },
        State {
            name: "SELECTION"
            PropertyChanges { target: closeSelectionButton; visible: true }
            PropertyChanges { target: settingsButton; visible: false }
            PropertyChanges { target: tabsButton; visible: false }
            PropertyChanges { target: keyboardButton; visible: false }
            PropertyChanges { target: bottomMessage; active: true }
            PropertyChanges { target: keyboardBar; enabled: false }
            PropertyChanges { target: inputArea; enabled: false }
        }
    ]
}
