/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored-by: Filippo Scognamiglio <flscogna@gmail.com>
 */
import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QMLTermWidget 1.0
import "Tabs"

// For FastBlur
import QtGraphicalEffects 1.0

Page {
    id: terminalPage
    property alias terminalContainer: terminalContainer
    property Item terminal
    property var tabsModel
    property bool narrowLayout

    anchors.fill: parent

    header: PageHeader {
        // WORKAROUND: This way we disable the 'hide' animation when
        // closing the settings page.
        visible: false
    }

    AlternateActionPopover {
        id: alternateActionPopover
    }

    TabsBar {
        id: tabsBar
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }
        property bool isDarkBackground: ColorUtils.luminance(backgroundColor) <= 0.85
        actionColor: isDarkBackground ? "white" : "black"
        backgroundColor: terminalPage.terminal ? terminalPage.terminal.backgroundColor : ""
        foregroundColor: terminalPage.terminal ? terminalPage.terminal.foregroundColor : ""
        contourColor: isDarkBackground ? Qt.rgba(1.0, 1.0, 1.0, 0.4) : Qt.rgba(0.0, 0.0, 0.0, 0.2)
        color: isDarkBackground ? Qt.tint(backgroundColor, "#0DFFFFFF") : Qt.tint(backgroundColor, "#0D000000")
        model: terminalPage.tabsModel
        function titleFromModelItem(modelItem) {
            return modelItem.session.title;
        }

        actions: [
            Action {
                // FIXME: icon from theme is fuzzy at many GUs
                iconSource: Qt.resolvedUrl("Tabs/tab_add.png")
    //            iconName: "add"
                onTriggered: terminalPage.tabsModel.addTab()
            },
            Action {
                iconName: "settings"
                onTriggered: pageStack.push(settingsPage)
            }
        ]
        visible: !terminalPage.narrowLayout
    }

    Item {
        id: terminalContainer

        anchors {
            left: parent.left;
            top: terminalPage.narrowLayout ? parent.top : tabsBar.bottom;
            right: parent.right;
            bottom: keyboardBarLoader.top
            margins: units.gu(1)
        }

        // Hide terminal data when the access is still not granted
        layer.enabled: authService.isDialogVisible
        layer.effect: FastBlur {
            radius: units.gu(6)
        }
    }

    QMLTermScrollbar {
        anchors {
            top: terminalContainer.anchors.top
            bottom: terminalContainer.anchors.bottom
            left: terminalContainer.anchors.left
            right: terminalContainer.anchors.right
        }

        terminal: terminalPage.terminal
        z: inputArea.z + 1
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
        anchors {
            left: terminalContainer.anchors.left
            top: terminalContainer.anchors.top
            right: terminalContainer.anchors.right
            bottom: parent.bottom
            margins: terminalContainer.anchors.margins
        }
        enabled: terminal

        // This is the minimum wheel event registered by the plugin (with the current settings).
        property real wheelValue: 40

        // This is needed to fake a "flickable" scrolling.
        swipeDelta: terminal ? terminal.fontMetrics.height : 0

        // Mouse actions
        onMouseMoveDetected: terminal.simulateMouseMove(x, y, button, buttons, modifiers);
        onDoubleClickDetected: terminal.simulateMouseDoubleClick(x, y, button, buttons, modifiers);
        onMousePressDetected: terminal.simulateMousePress(x, y, button, buttons, modifiers);
        onMouseReleaseDetected: terminal.simulateMouseRelease(x, y, button, buttons, modifiers);
        onMouseWheelDetected: terminal.simulateWheel(x, y, buttons, modifiers, angleDelta);

        // Touch actions
        onTouchClick: terminal.simulateKeyPress(Qt.Key_Tab, Qt.NoModifier, true, 0, "");
        onTouchPressAndHold: alternateAction(x, y);

        // Swipe actions
        onSwipeYDetected: {
            if (steps > 0) {
                simulateSwipeDown(steps);
            } else {
                simulateSwipeUp(-steps);
            }
        }
        onSwipeXDetected: {
            if (steps > 0) {
                simulateSwipeRight(steps);
            } else {
                simulateSwipeLeft(-steps);
            }
        }
        onTwoFingerSwipeYDetected: {
            if (steps > 0) {
                simulateDualSwipeDown(steps);
            } else {
                simulateDualSwipeUp(-steps);
            }
        }

        function simulateSwipeUp(steps) {
            while(steps > 0) {
                terminal.simulateKeyPress(Qt.Key_Up, Qt.NoModifier, true, 0, "");
                steps--;
            }
        }
        function simulateSwipeDown(steps) {
            while(steps > 0) {
                terminal.simulateKeyPress(Qt.Key_Down, Qt.NoModifier, true, 0, "");
                steps--;
            }
        }
        function simulateSwipeLeft(steps) {
            while(steps > 0) {
                terminal.simulateKeyPress(Qt.Key_Left, Qt.NoModifier, true, 0, "");
                steps--;
            }
        }
        function simulateSwipeRight(steps) {
            while(steps > 0) {
                terminal.simulateKeyPress(Qt.Key_Right, Qt.NoModifier, true, 0, "");
                steps--;
            }
        }
        function simulateDualSwipeUp(steps) {
            while(steps > 0) {
                terminal.simulateWheel(width * 0.5, height * 0.5, Qt.NoButton, Qt.NoModifier, Qt.point(0, -wheelValue));
                steps--;
            }
        }
        function simulateDualSwipeDown(steps) {
            while(steps > 0) {
                terminal.simulateWheel(width * 0.5, height * 0.5, Qt.NoButton, Qt.NoModifier, Qt.point(0, wheelValue));
                steps--;
            }
        }

        // Semantic actions
        onAlternateAction: {
            // Force the hiddenButton in the event position.
            hiddenButton.x = x;
            hiddenButton.y = y;
            PopupUtils.open(alternateActionPopover, hiddenButton);
        }
    }

    Loader {
        id: keyboardBarLoader
        height: active ? units.gu(5) : 0
        anchors {left: parent.left; right: parent.right}
        active: !QuickUtils.keyboardAttached

        y: parent.height - height - Qt.inputMethod.keyboardRectangle.height
        z: parent.z + 0.1

        sourceComponent: KeyboardBar {
            height: units.gu(5)
            backgroundColor: tabsBar.color
            foregroundColor: tabsBar.foregroundColor
            onSimulateKey: terminal.simulateKeyPress(key, mod, true, 0, "");
            onSimulateCommand: terminal.session.sendText(command);
        }
    }

    Loader {
        id: bottomMessage

        height: units.gu(5)
        anchors {left: parent.left; right: parent.right}

        y: parent.height - height - Qt.inputMethod.keyboardRectangle.height
        z: parent.z + 0.2

        active: false
        sourceComponent:  Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.7

            Label {
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

        backgroundColor: tabsBar.color
        iconColor: tabsBar.actionColor
        visible: false
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

        backgroundColor: tabsBar.color
        iconColor: tabsBar.actionColor
        action: Action {
            iconName: "settings"
            onTriggered: pageStack.push(settingsPage);
        }
        visible: terminalPage.narrowLayout
    }

    CircularTransparentButton {
        id: tabsButton

        anchors {top: settingsButton.bottom; right: parent.right; margins: units.gu(1)}

        backgroundColor: tabsBar.color
        iconColor: tabsBar.actionColor
        action: Action {
            iconName: "browser-tabs"
            onTriggered: pageStack.push(tabsPage);
        }
        visible: terminalPage.narrowLayout
    }

    Loader {
        id: keyboardButton
        active: !QuickUtils.keyboardAttached
        anchors {right: parent.right; margins: units.gu(1)}

        y: parent.height - height - units.gu(1) - keyboardBarLoader.height

        sourceComponent: CircularTransparentButton {
            backgroundColor: tabsBar.color
            iconColor: tabsBar.actionColor
            action: Action {
                iconName: "input-keyboard-symbolic"
                onTriggered: {
                    Qt.inputMethod.show();
                    terminal.forceActiveFocus();
                }
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
            PropertyChanges { target: keyboardBarLoader; enabled: false }
            PropertyChanges { target: inputArea; enabled: false }
        }
    ]
}
