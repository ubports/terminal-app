import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: tabsPage
    objectName: "tabsPage"

    header: PageHeader {
        title: i18n.tr("Tabs")
        flickable: tabsGrid

        trailingActionBar.actions: Action {
            objectName: "newTabAcion"
            iconName: "add"
            text: i18n.tr("New tab")
            onTriggered: {
                tabsModel.addTab();
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        GridView {
            id: tabsGrid
            anchors.fill: parent
            model: tabsModel
            anchors.margins: units.gu(1)
            cellWidth: (parent.width - units.gu(2)) * 0.5
            cellHeight: cellWidth * (terminalPage.terminalContainer.height / terminalPage.terminalContainer.width)

            //      add: Transition {
            //          NumberAnimation { properties: "x,y"; duration: 200 }
            //      }

            removeDisplaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 200 }
            }

            delegate: Item{
                id: tabDelegate
                width: tabsGrid.cellWidth
                height: tabsGrid.cellHeight

                property bool canClose: tabsModel.count > 1

                ShaderEffectSource {
                    id: thumb
                    sourceItem: model.terminal

                    live: tabsPage.visible

                    anchors.margins: units.gu(1)
                    anchors.fill: parent

                    CircularTransparentButton {
                        id: settingsButton
                        width: units.gu(4)
                        height: units.gu(4)

                        z: parent.z + 0.1

                        opacity: ( tabDelegate.canClose ? 1.0 : 0.0)
                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }

                        anchors {top: parent.top; right: parent.right; margins: units.gu(1)}

                        innerOpacity: 0.6
                        border {color: UbuntuColors.orange; width: units.dp(1)}
                        action: Action {
                            iconName: "close"
                            onTriggered: tabsModel.removeTab(index);
                        }
                    }

                    Rectangle {
                        id: blackRect
                        height: parent.height * 0.3
                        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }
                        color: "black"
                        opacity: 0.5
                    }

                    Label {
                        anchors { fill: blackRect; margins: units.dp(2) }
                        text: tabsModel.get(index).terminal.session.title
                        wrapMode: Text.Wrap
                        color: "white"
                    }

                    Rectangle {
                        id: highlightArea
                        anchors.fill: parent
                        color: "white"
                        opacity: tabsModel.selectedIndex == index ? 0.2 : 0
                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            tabsModel.selectTab(index);
                            pageStack.pop();
                        }
                    }
                }
            }
        }
    }
}
