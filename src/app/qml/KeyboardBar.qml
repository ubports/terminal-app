import QtQuick 2.4
import Ubuntu.Components 1.3
import "KeyboardRows"

import "KeyboardRows/jsonParser.js" as Parser

Rectangle {
    id: rootItem
    color: "black"

    property int selectedLayoutIndex: 0

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

    function createLayoutObject(profileObject) {
        var object = layoutComponent.createObject(keyboardContainer);
        object.loadProfile(profileObject);
        return object;
    }

    function disableLayout(index) {
        if (!isIndexLayoutValid(index))
            return;

        var layoutObject = layoutsList.get(index).layout;
        layoutObject.visible = false;
        layoutObject.enabled = false;
        layoutObject.z = rootItem.z;
        layoutObject.simulateKey.disconnect(simulateKey);
        layoutObject.simulateCommand.disconnect(simulateCommand);
    }

    function enableLayout(index) {
        if (!isIndexLayoutValid(index))
            return;

        var layoutObject = layoutsList.get(index).layout;
        layoutObject.visible = true;
        layoutObject.enabled = true;
        layoutObject.z = rootItem.z + 0.01;
        layoutObject.simulateKey.connect(simulateKey);
        layoutObject.simulateCommand.connect(simulateCommand);
    }

    function isIndexLayoutValid(index) {
        return (index >= 0 && index < layoutsList.count);
    }

    function selectLayout(index) {
        if (!isIndexLayoutValid(index))
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
        dropProfiles();

        for (var i = 0; i < settings.profilesList.count; i++) {
            var profile = settings.profilesList.get(i);
            if (!profile.profileVisible)
                continue;

            try {
                console.log("Loading Layout:", Qt.resolvedUrl(profile.file));
                var layoutObject = createLayoutObject(profile.object);
                layoutsList.append({layout: layoutObject});
            } catch (e) {
                console.error("Error in profile " + profile.file);
                console.error(e);
            }
        }
        updateSelector();
        selectLayout(0);
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

        enabled: layoutsList.count != 0

        Rectangle {
            anchors.fill: parent
            color: parent.enabled ? UbuntuColors.orange : UbuntuColors.warmGrey

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

    Connections {
        target: settings
        onProfilesChanged: rootItem.loadProfiles();
    }

    Component.onDestruction: dropProfiles();
    Component.onCompleted: loadProfiles();
}
