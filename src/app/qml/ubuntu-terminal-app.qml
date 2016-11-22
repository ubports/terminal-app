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
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.2
import "KeyboardRows"

import QMLTermWidget 1.0

// Mouse/Touchpad and keyboard support
import QtSystemInfo 5.5

Window {
    id: window

    property string userPassword: ""
    readonly property bool sshMode: sshIsAvailable && sshRequired && (userPassword != "")

    objectName: "terminal"
    title: tabsModel.selectedTerminal ? tabsModel.selectedTerminal.session.title : ""
    color: terminalPage.active && terminalPage.terminal ? terminalPage.terminal.backgroundColor : theme.palette.selected.overlay
    contentOrientation: Screen.orientation

    minimumWidth: units.gu(20)
    minimumHeight: units.gu(20)

    property bool narrowLayout: window.width <= units.gu(50)

    property int visibilityBeforeFullscreen
    function toggleFullscreen() {
        if (window.visibility != Window.FullScreen) {
            visibilityBeforeFullscreen = window.visibility;
            window.visibility = Window.FullScreen;
        } else {
            window.visibility = visibilityBeforeFullscreen;
        }
    }

    AuthenticationService {
        id: authService
        onDenied: Qt.quit();
        onGranted: {
            if (sshUser != "") {
                userPassword = password
                tabsModel.addTab()
                tabsModel.removeTab(0)
            }
        }
    }

    TerminalSettings {
        id: settings
    }

    TerminalComponent {
        id: terminalComponent
    }

    TabsModel {
        id: tabsModel
    }

    JsonTranslator {
        id: translator
    }

    PageStack {
        id: pageStack
        Component.onCompleted: push(terminalPage)

        property bool prevKeyboardVisible: false

        onCurrentPageChanged: {
            if(currentPage == terminalPage) {
                // Restore previous keyboard state.
                if (prevKeyboardVisible) {
                    Qt.inputMethod.show();
                } else {
                    Qt.inputMethod.hide();
                }

                // Force the focus on the widget when the terminal shown.
                if (terminalPage.terminal) {
                    terminalPage.terminal.forceActiveFocus();
                }
            } else {
                // Force the focus out of the terminal widget.
                currentPage.forceActiveFocus();
                prevKeyboardVisible = Qt.inputMethod.visible;
                Qt.inputMethod.hide();
            }
        }

        TerminalPage {
            id: terminalPage
            tabsModel: tabsModel
            narrowLayout: window.narrowLayout
            // Hide terminal data when the access is still not granted
            layer.enabled: authService.isDialogVisible
            layer.effect: FastBlur {
                radius: units.gu(6)
            }

            // TODO: decide between the expandable button or the two buttons.
//            ExpandableButton {
//                size: units.gu(6)
//                anchors {right: parent.right; top: parent.top; margins: units.gu(1);}
//                rotation: 1
//                childComponent: Component {
//                    Rectangle {
//                        color: "#99000000" // Transparent black
//                        radius: width * 0.5
//                        border.color: UbuntuColors.orange;
//                        border.width: units.dp(3)
//                    }
//                }

//                Icon {
//                    width: units.gu(3)
//                    height: width
//                    anchors.centerIn: parent
//                    name: "settings"
//                    color: "Grey"
//                }

//                actions: [
//                    Action {
//                        iconName: "settings"
//                        onTriggered: pageStack.push(settingsPage)
//                    },
//                    Action {
//                        iconName: "browser-tabs"
//                        onTriggered: pageStack.push(tabsPage)
//                    }
//                ]
//            }
        }

        TabsPage {
            id: tabsPage
            visible: false
        }

        SettingsPage {
            id: settingsPage
            visible: false
        }

        LayoutsPage {
            id: layoutsPage
            visible: false
        }
    }

    Component.onCompleted: {
        i18n.domain = Qt.application.name;
        tabsModel.addTab();
        tabsModel.selectTab(0);

        // The margins for the terminal canvas are 2px
        // Hardcoded value from TerminalDisplay.h
        window.width = 90 * terminalPage.terminal.fontMetrics.width + 2 + units.gu(2)
        window.height = 24 * terminalPage.terminal.fontMetrics.height + 2 + units.gu(2) + units.gu(3)

        if (sshRequired && !sshIsAvailable) {
            console.debug("Ask for confirmation")
            var proceed_dialog =
                PopupUtils.open( Qt.resolvedUrl( "ConfirmationDialog.qml" ),
                                 null,
                                 {'title': i18n.tr("No SSH server running."),
                                  'text': i18n.tr("SSH server not found. Do you want to proceed in confined mode?")});

            proceed_dialog.dialogCanceled.connect( Qt.quit );
            proceed_dialog.dialogAccepted.connect( function() {
                PopupUtils.close(proceed_dialog)
            })
        }
        window.show()
    }

    InputDeviceManager {
        id: keyboardsModel
        filter: InputInfo.Keyboard
    }

    InputDeviceManager {
        id: miceModel
        filter: InputInfo.Mouse
    }

    InputDeviceManager {
        id: touchpadsModel
        filter: InputInfo.TouchPad
    }

    // WORKAROUND: Not yet implemented in the SDK
    Binding {
        target: QuickUtils
        property: "mouseAttached"
        value: miceModel.count > 0 || touchpadsModel.count > 0
    }

    // WORKAROUND: Not yet implemented in the SDK
    Binding {
        target: QuickUtils
        property: "keyboardAttached"
        value: keyboardsModel.count > 0
    }
}
