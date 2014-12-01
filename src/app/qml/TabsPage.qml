import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.ListItems 1.0 as ListItem

Page {
    id: tabsPage
    objectName: "tabsPage"
    title: i18n.tr("Tabs")

    head.actions: [
        Action {
            objectName: "newTabAcion"
            iconName: "add"
            text: i18n.tr("New tab")
            onTriggered: {
                tabsModel.addTab();
            }
        }
    ]

    Item {
        anchors.fill: parent
        clip: true

        GridView {
            id: tabsGrid
            anchors.fill: parent
            model: tabsModel
            anchors.margins: units.gu(1)
            cellWidth: (parent.width - units.gu(2)) * 0.5
            cellHeight: cellWidth * (terminalPage.terminalContainer.height / terminalPage.terminalContainer.width)

//            add: Transition {
//                NumberAnimation { properties: "x,y"; duration: 200 }
//            }

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

                    Text {
                        anchors.fill: blackRect
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
                        onClicked: tabsModel.selectTab(index);
                    }
                }
            }
        }

//        ListView {
//            id: tabView
//            anchors.fill: parent
//            model: tabsModel

//            delegate: ListItemWithActions{
//                width: parent.width
//                height: units.gu(25)

//                onItemClicked: {
//                    // If the currently active tab is pressed. Return to it.
//                    if (tabsModel.selectedIndex == index) {
//                        pageStack.pop();
//                    } else {
//                        tabsModel.selectTab(index);
//                    }
//                }

//                contents: Row {
//                    anchors.fill: parent
//                    spacing: units.gu(4)

//                    ShaderEffectSource {
//                        id: thumb

//                        width: height * (model.terminal.width / model.terminal.height)
//                        height: parent.height

//                        sourceItem: model.terminal
//                    }

//                    Label {
//                        width: parent.width - (thumb.width + units.gu(6))

//                        text: tabsModel.get(index).terminal.session.title
//                        anchors.verticalCenter: parent.verticalCenter
//                        wrapMode: Text.Wrap
//                    }
//                }

//                Rectangle {
//                    id: selectedTab
//                    anchors.fill: parent
//                    color: Theme.palette.selected.background
//                    opacity: tabsModel.selectedIndex == index ? 1.0 : 0.0

//                    Behavior on opacity {
//                        NumberAnimation { duration: 200 }
//                    }
//                }

//                leftSideAction: Action {
//                    iconName: "delete"
//                    text: i18n.tr("Delete")
//                    enabled: tabsModel.count !== 1
//                    onTriggered:  {
//                        //Workaround since enabled is ignored
//                        if (enabled)
//                            tabsModel.removeTab(index);
//                    }
//                }
//            }
//        }
    }
}
