import QtQuick 2.0
import Ubuntu.Components 1.1

import "jsonParser.js" as Parser

KeyboardRow {
    id: keyboardRow
    keyWidth: units.gu(5)

    // This label is used to compute the maximum width of all the controls.
    Label {
        id: hiddenLabel
        visible: false
    }

    function dropProfile() {
        // TODO Check if this is enough and doesn't leak.
        for (var i = 0; i < model.length; i++)
            model[i].destroy();
        model = [];
    }

    function createActionString(action) {
        switch(action.type){
        case "key":
            return createKeyActionString(action.key, action.mod, action.text);
        case "string":
            return createStringActionString(action.string, action.text);
        }
    }

    function createOtherActionsString(actions) {
        var result = "[";
        for (var i = 0; i < actions.length; i++) {
            var action = actions[i];
            result += createActionString(action);

            if (i < actions.length - 1)
                result += ",";
        }

        return result + "]";
    }

    function createKeyActionString(key, mod, text) {
        if (["Control", "Alt", "Shift"].indexOf(mod) === -1)
            mod = "No";

        var textString = text ? "text: \"" + text + "\";" : "";
        return "Action { " + textString + " onTriggered: simulateKey(Qt.Key_"+ key + ", Qt." + mod + "Modifier); }";
    }

    function createStringActionString(string, text) {
        var textString = text ? "text: \"" + text + "\";" : "";
        return "Action { " + textString + " onTriggered: simulateCommand(\"" + string + "\"); }";
    }

    function createEntryString(text, actionString, otherActionsString) {
        var objectString = "
            import QtQuick 2.0
            import Ubuntu.Components 1.1

            KeyModel {
                text: \"" + text + "\"
                mainAction: " + actionString + "\n
                actions:" + otherActionsString +
            "}"
        return objectString;
    }

    function loadProfile(profileObject) {
        dropProfile();

        var maxWidth = 0;

        // This function might raise exceptions which are handled in KeyboardBar.qml
        var profile = profileObject;

        name = profile.name;
        short_name = profile.short_name;

        var layoutModel = []
        for (var i = 0; i < profile.buttons.length; i++) {
            var button = profile.buttons[i];
            var mainActionString = createActionString(button.main_action);

            var otherActionsString = button.other_actions
                                          ? createOtherActionsString(button.other_actions)
                                          : "[]";

            var entryString = createEntryString(button.main_action.text, mainActionString, otherActionsString);

            layoutModel.push(Qt.createQmlObject(entryString, keyboardRow));

            hiddenLabel.text = button.main_action.text;
            maxWidth = Math.max(hiddenLabel.width, maxWidth);
        }

        keyWidth = maxWidth + units.gu(3);
        model = layoutModel;
    }
    Component.onDestruction: dropProfile();
}
