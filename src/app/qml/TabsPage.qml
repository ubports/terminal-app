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

        ListView {
            id: tabView
            anchors.fill: parent
            model: tabsModel

            delegate: ListItemWithActions{
                width: parent.width

                onItemClicked: { tabsModel.selectTab(index); }

                contents: Label {
                    text: tabsModel.get(index).terminal.session.title
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }

                Rectangle {
                    id: selectedTab
                    anchors.fill: parent
                    color: Theme.palette.selected.background
                    opacity: tabsModel.selectedIndex == index ? 1.0 : 0.0

                    Behavior on opacity {
                        NumberAnimation { duration: 200 }
                    }
                }

                leftSideAction: Action {
                    iconName: "delete"
                    text: i18n.tr("Delete")
                    enabled: tabsModel.count !== 1
                    onTriggered:  {
                        //Workaround since enabled is ignored
                        if (enabled)
                            tabsModel.removeTab(index);
                    }
                }

            }
        }
    }
}
