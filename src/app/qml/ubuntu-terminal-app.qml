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
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3
import "KeyboardRows"

import QMLTermWidget 1.0

// Mouse/Touchpad and keyboard support
import QtSystemInfo 5.5

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    id: mview
    objectName: "terminal"
    applicationName: "com.ubuntu.terminal"
    automaticOrientation: true

    AuthenticationService {
        id: authService
        onDenied: Qt.quit();
    }

    TerminalSettings {
        id: settings
    }

    TerminalComponent {
        id: terminalComponent
    }

    TabsModel {
        id: tabsModel
        Component.onCompleted: addTab();
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

        ColorSchemePage {
            id: colorSchemePage
            visible: false

            // TODO This is a workaround at the moment.
            // The application should get them from the c++.
            model: ["GreenOnBlack","WhiteOnBlack","BlackOnWhite","BlackOnRandomLight","Linux","cool-retro-term","DarkPastels","BlackOnLightYellow", "Ubuntu"]

            // TRANSLATORS: This is the name of a terminal color scheme which is displayed in the settings
            namesModel: [i18n.tr("Green on black"),i18n.tr("White on black"),i18n.tr("Black on white"),i18n.tr("Black on random light"),i18n.tr("Linux"),i18n.tr("Cool retro term"),i18n.tr("Dark pastels / Ubuntu (old)"),i18n.tr("Black on light yellow"),i18n.tr("Ubuntu")]
        }
    }

    Component.onCompleted: {
        tabsModel.selectTab(0);

        // The margins for the terminal canvas are 2px
        // Hardcoded value from TerminalDisplay.h
        width = 80 * terminalPage.terminal.fontMetrics.width + 2
        height = 24 * terminalPage.terminal.fontMetrics.height + 2
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
