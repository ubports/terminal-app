import QtQuick 2.3
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.0
import Ubuntu.Components.Popups 0.1

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

    PageStack {
        id: pageStack
        Component.onCompleted: push(terminalPage)

        onCurrentPageChanged: {
            if(currentPage == terminalPage) {
                terminalPage.terminal.forceActiveFocus();

                // TODO WORKAROUND: the font event is not processed correctly,
                // when the terminal page is not visible, so we set it again here.
                terminalPage.terminal.font.family = settings.fontStyle;
                terminalPage.terminal.font.pixelSize = settings.fontSize;
            }
        }

        TerminalPage {
            id: terminalPage

            ExpandableButton {
                size: units.gu(8)
                anchors {right: parent.right; top: parent.top;}
                rotation: 1
                childComponent: Component {
                    Rectangle {
                        color: "black"
                        radius: width * 0.5
                    }
                }
                actions: [
                    Action {text: "S"; onTriggered: pageStack.push(settingsPage);},
                    Action {text: "T"; onTriggered: console.log("tabs");}
                ]
            }
        }

        SettingsPage {
            id: settingsPage
            visible: false
        }
    }
}
