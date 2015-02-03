import QtQuick 2.2
import Ubuntu.Components 1.1
import "KeyboardRows"

import "KeyboardRows/namesConvertions.js" as Conv
import "KeyboardRows/jsonParser.js" as Parser

Rectangle {
    id: rootItem
    color: "black"

    property int selectedLayoutIndex: 0
    property var _profilesPaths: [
        "file:///home/swordfish/workspaces/ubuntu/reboot/src/app/qml/KeyboardRows/Layouts/FunctionKeys.json",
        "file:///home/swordfish/workspaces/ubuntu/reboot/src/app/qml/KeyboardRows/Layouts/ControlKeys.json",
        "file:///home/swordfish/workspaces/ubuntu/reboot/src/app/qml/KeyboardRows/Layouts/SimpleCommands.json",
        "file:///home/swordfish/workspaces/ubuntu/reboot/src/app/qml/KeyboardRows/Layouts/ScrollKeys.json"
    ]

    signal simulateCommand(string command);
    signal simulateKey(int key, int mod);

    ListModel {
        id: layoutsList
    }

    Component {
        id: actionComponent
        Action {
            property int selectIndex
            onTriggered: rootItem.selectLayout(selectIndex);
        }
    }

    Component {
        id: layoutComponent
        KeyboardLayout {
            anchors.fill: keyboardContainer
            enabled: false
            visible: false
        }
    }

    function printLayouts() {
        for (var i = 0; i < layoutsList.count; i++) {
            console.log(layoutsList.get(i).layout.name);
        }
    }

    function createLayoutObject(profileUrl) {
        var object = layoutComponent.createObject(keyboardContainer);
        object.loadProfile(fileIO.read(profileUrl));
        return object;
    }

    function disableLayout(index) {
        var layoutObject = layoutsList.get(index).layout;
        console.log("disable", layoutObject.name);
        layoutObject.visible = false;
        layoutObject.enabled = false;
        layoutObject.z = rootItem.z;
        layoutObject.simulateKey.disconnect(simulateKey);
        layoutObject.simulateCommand.disconnect(simulateCommand);
    }

    function enableLayout(index) {
        var layoutObject = layoutsList.get(index).layout;
        console.log("enable", layoutObject.name);
        layoutObject.visible = true;
        layoutObject.enabled = true;
        layoutObject.z = rootItem.z + 0.01;
        layoutObject.simulateKey.connect(simulateKey);
        layoutObject.simulateCommand.connect(simulateCommand);
    }

    function selectLayout(index) {
        console.log("select layout called", index);
        if (index < 0 || index >= layoutsList.count)
            return;

        disableLayout(selectedLayoutIndex);
        enableLayout(index);
        selectedLayoutIndex = index;
    }

    function dropProfiles() {
        for (var i = 0; i < layoutsList.count; i++) {
            layoutsList.get(i).layout.destroy();
        }
        layoutsList.clear();
    }

    function updateSelector() {
        var result = [];
        for (var i = 0; i < layoutsList.count; i++) {
            var layoutObject = layoutsList.get(i).layout;
            var index = i;
            var actionObject = actionComponent.createObject(rootItem);

            actionObject.text = layoutObject.short_name;
            actionObject.description = layoutObject.name;
            actionObject.selectIndex = i;

            result.push(actionObject);
        }
        keyboardSelector.actions = result;
    }

    function loadProfiles() {
        for (var i = 0; i < keyboardLayouts.length; i++) {
            console.log(Qt.resolvedUrl(keyboardLayouts[i]));
            var layoutObject = createLayoutObject(Qt.resolvedUrl(keyboardLayouts[i]));
            layoutsList.append({layout: layoutObject});
        }
        updateSelector();
        selectLayout(0);
        printLayouts();
    }

    PressFeedback {
        id: pressFeedbackEffect
    }

    // TODO: What do we do with this control from a design perspective?
    ExpandableButton {
        id: keyboardSelector
        height: parent.height
        width: parent.height

        z: parent.z + 0.01

        childComponent: Component {
            Rectangle {
                color: "black"
            }
        }

        Rectangle {
            anchors.fill: parent
            color: UbuntuColors.orange

            Icon {
                scale: 0.5
                anchors.fill: parent
                name: "keypad"
                color: "black"
            }
        }
    }

    onSimulateKey: pressFeedbackEffect.start();
    onSimulateCommand: pressFeedbackEffect.start();

    Item {
        id: keyboardContainer
        anchors.left: keyboardSelector.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.top: parent.top
        height: units.gu(5)

        Rectangle {
            property string defaultString: i18n.tr("Change Keyboard");

            id: toolTip

            Connections {
                property alias index: keyboardSelector.selectedIndex
                property alias text: tooltipLabel.text

                target: keyboardSelector
                onSelectedIndexChanged: {
                    text = index >= 0
                                   ? keyboardSelector.actions[index].description
                                   : toolTip.defaultString
                }
            }

            visible: keyboardSelector.expanded

            anchors.fill: parent
            color: "Black"
            opacity: 0.8
            z: parent.z + 0.1

            Label {
                z: parent.z + 0.1
                id: tooltipLabel
                text: toolTip.defaultString
                anchors.centerIn: parent
                color: "white"
            }
        }
    }

    Component.onDestruction: dropProfiles();
    Component.onCompleted: loadProfiles();
}
