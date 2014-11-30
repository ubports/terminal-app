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
                height: units.gu(25)

                onItemClicked: {
                    // If the currently active tab is pressed. Return to it.
                    if (tabsModel.selectedIndex == index) {
                        pageStack.pop();
                    } else {
                        tabsModel.selectTab(index);
                    }
                }

                contents: Row {
                    anchors.fill: parent
                    spacing: units.gu(4)

                    ShaderEffectSource {
                        id: thumb

                        width: height * (model.terminal.width / model.terminal.height)
                        height: parent.height

                        sourceItem: model.terminal
                    }

                    Label {
                        width: parent.width - (thumb.width + units.gu(6))

                        text: tabsModel.get(index).terminal.session.title
                        anchors.verticalCenter: parent.verticalCenter
                        wrapMode: Text.Wrap
                    }
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
