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
import Ubuntu.Components.Extras 0.3
import QMLTermWidget 1.0
import GSettings 1.0

// For FastBlur
import QtGraphicalEffects 1.0

Page {
    id: terminalPage
    property alias terminalContainer: terminalContainer
    property Terminal terminal
    property var tabsModel
    property bool narrowLayout
    theme: ThemeSettings {
        name: tabsBar.isDarkBackground ? "Ubuntu.Components.Themes.SuruDark"
                                       : "Ubuntu.Components.Themes.Ambiance"
    }

    anchors.fill: parent

    header: PageHeader {
        // WORKAROUND: This way we disable the 'hide' animation when
        // closing the settings page.
        visible: false
    }

    TabsBar {
        id: tabsBar
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }
        property bool isDarkBackground: terminalPage.terminal && terminalPage.terminal.isDarkBackground
        actionColor: isDarkBackground ? "white" : "black"
        backgroundColor: terminalPage.terminal ? terminalPage.terminal.backgroundColor : ""
        foregroundColor: terminalPage.terminal ? terminalPage.terminal.foregroundColor : ""
        contourColor: terminalPage.terminal ? terminalPage.terminal.contourColor : ""
        color: isDarkBackground ? Qt.tint(backgroundColor, "#0DFFFFFF") : Qt.tint(backgroundColor, "#0D000000")
        model: terminalPage.tabsModel
        function titleFromModelItem(modelItem) {
            return modelItem.focusedTerminal ? modelItem.focusedTerminal.session.title : "";
        }

        actions: [
            Action {
                // FIXME: icon from theme is fuzzy at many GUs
                iconSource: Qt.resolvedUrl("tab_add.png")
    //            iconName: "add"
                onTriggered: terminalPage.tabsModel.addTerminalTab()
            },
            Action {
                iconName: "settings"
                onTriggered: terminalAppRoot.openSettingsPage()
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
        }

        Binding {
            target: tabsModel.currentItem
            property: "focus"
            value: true
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
            onSimulateCommand: terminal.focusedTerminal.session.sendText(command);
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
                PopupUtils.open(Qt.resolvedUrl("AlternateActionPopover.qml"));
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
            onTriggered: terminalAppRoot.openSettingsPage()
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

    GSettings {
        id: unity8Settings
        schema.id: "com.canonical.Unity8"
    }

    Loader {
        id: keyboardButton
        active: !QuickUtils.keyboardAttached || unity8Settings.alwaysShowOsk
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
        }
    ]
}
