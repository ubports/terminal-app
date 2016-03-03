import QtQuick 2.4
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3
import "KeyboardRows"

import QMLTermWidget 1.0

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    id: mview
    objectName: "terminal"
    applicationName: "com.ubuntu.terminal"
    automaticOrientation: true

    width: units.gu(90)
    height: units.gu(55)

    AuthenticationService {
        id: authService
        onDenied: Qt.quit();

        states: State {
            when: authService.isDialogVisible

            // We use a PropertyChanges for hiding terminal data
            // until the access is granted.
            // When that happens, the visibility of the terminal is
            // restore to the previous value thanks to the
            // 'restoreEntryValues' property which is true by default.
            // ref. http://doc.qt.io/qt-5/qml-qtquick-propertychanges.html#restoreEntryValues-prop
            PropertyChanges {
                target: terminalPage.terminalContainer
                visible: false
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
    }
}
