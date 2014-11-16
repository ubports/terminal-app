import QtQuick 2.3
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 0.1

import QMLTermWidget 1.0

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    id: mview
    objectName: "terminal"
    applicationName: "com.ubuntu.terminal"
    automaticOrientation: true
    useDeprecatedToolbar: false

    width: units.gu(50)
    height: units.gu(75)

    AuthenticationService {
        onDenied: Qt.quit()
    }

    AlternateActionPopover {
        id: alternateActionPopover
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

    PageStack {
        id: pageStack
        Component.onCompleted: push(terminalPage)

        onCurrentPageChanged: {
            if(currentPage == terminalPage) {
                // TODO Remove this check. Check that all the other tabs are invisible.
                for (var i = 0; i < tabsModel.count; i++) {
                    if (tabsModel.get(i).terminal.visible === true && i !== tabsModel.selectedIndex)
                        console.log("Exists a tab visible which is not in foreground. This is wrong!!");
                }

                // TODO WORKAROUND: Resize event are not processed correctly because the page
                // is invisible. This forces a resize when the are visible. This is extremely
                // ugly and should be solved on the c++ side.
                if (terminalPage.terminal) {
                    terminalPage.terminal.width = terminalPage.terminal.width + 100;
                    terminalPage.terminal.width = Qt.binding(function () { return terminalPage.terminalContainer.width; });
                    terminalPage.terminal.height = Qt.binding(function () { return terminalPage.terminalContainer.height; });
                    terminalPage.terminal.update();
                    terminalPage.terminal.forceActiveFocus();
                }
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
    }

    Component.onCompleted: {
        tabsModel.selectTab(0);
    }
}
