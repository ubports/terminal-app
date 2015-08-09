import QtQuick 2.4
import Ubuntu.Components 1.2

import "jsonParser.js" as Parser

KeyboardRow {
    id: keyboardRow
    keyWidth: units.gu(5)

    readonly property variant modifiers: ["Control", "Alt", "Shift"]

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
            return createKeyActionString(action.key, action.mod, action.text, action.id);
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

    function createKeyActionString(key, mod, text, id) {
        if (modifiers.indexOf(mod) === -1)
            mod = "No";

        return "Action { text: \"" + createKeyText(key, mod, text, id) + "\"; onTriggered: simulateKey(Qt.Key_"+ key + ", Qt." + mod + "Modifier); }";
    }

    function createStringActionString(string, text) {
        var textString = text ? "text: \"" + text + "\";" : "";
        return "Action { " + textString + " onTriggered: simulateCommand(\"" + string + "\"); }";
    }

    function createEntryString(text, actionString, otherActionsString) {
        var objectString = "
            import QtQuick 2.4
            import Ubuntu.Components 1.2

            KeyModel {
                text: \"" + text + "\"
                mainAction: " + actionString + "\n
                actions:" + otherActionsString +
            "}"
        return objectString;
    }

    function createKeyText(key, mod, text, id) {
        if (id) {
            return translator.getTranslatedNameById(translator.key, id);
        } else if (text) {
            return text;
        } else if (key) {
            return ((mod && modifiers.indexOf(mod) !== -1) ? translator.getTranslatedNameById(translator.modifier, mod) + "+" : "") + key;
        } else
            return "";
    }

    function loadProfile(profileObject) {
        dropProfile();

        var maxWidth = 0;

        // This function might raise exceptions which are handled in KeyboardBar.qml
        var profile = profileObject;

        var name = "";
        var shortName = "";
        if (profile.id) {
            name = translator.getTranslatedNameById(translator.name, profile.id);
            short_name = translator.getTranslatedNameById(translator.shortName, profile.id);
        }
        if (name === "")
            name = profile.name;
        if (short_name === "")
            short_name = profile.short_name;

        var layoutModel = []
        for (var i = 0; i < profile.buttons.length; i++) {
            var button = profile.buttons[i];
            var keyText = createKeyText(button.main_action.key, button.main_action.mod, button.main_action.text, button.main_action.id);
            var mainActionString = createActionString(button.main_action);

            var otherActionsString = button.other_actions
                                          ? createOtherActionsString(button.other_actions)
                                          : "[]";

            var entryString = createEntryString(keyText, mainActionString, otherActionsString);

            layoutModel.push(Qt.createQmlObject(entryString, keyboardRow));

            hiddenLabel.text = keyText;
            maxWidth = Math.max(hiddenLabel.width, maxWidth);
        }

        keyWidth = maxWidth + units.gu(3);
        model = layoutModel;
    }

    Component.onDestruction: dropProfile();
}
