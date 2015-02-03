.pragma library

var profileErrorString = "Error loading keyboard profile: ";

function isAllowed(value, allowed) {
    return allowed.indexOf(value) !== -1;
}

function composeErrorString(err) {
    return profileErrorString + err;
}

function validateKeyAction(keyAction) {
    if (!keyAction.key)
        return composeErrorString("key is missing");
    if (keyAction.mod && !isAllowed(keyAction.mod, ["Control", "Shift", "Alt"]))
        return composeErrorString("mod is invalid");
    return "";
}

function validateCommandAction(commandAction) {
    if (!commandAction.command)
        return composeErrorString("command is missing");
    return "";
}

function validateAction(action) {
    if (!action.type)
        return composeErrorString("type is missing");
    if (isAllowed(action.type, ["key", "command"]))
        return composeErrorString("type must be either key or command");
    if (!action.text)
        return composeErrorString("text is missing");
    return action.type === "key" ? validateKeyAction(action) : validateCommandAction(action);
}

function validateButton(button) {
    if (!button.main_action)
        return composeErrorString("button main_action is missing");
}

function validateLayout(layoutObject) {
    if (!layoutObject.name)
        return composeErrorString("name field is missing");
    if (!layoutObject.short_name)
        return composeErrorString("short_name field is missing");
    if (!layoutObject.buttons)
        return composeErrorString("buttons field is missing");

    for (var button in layoutObject.buttons) {
        var error = validateButton(button);
        if (error)
            return composeErrorString(error);
    }

    return "";
}

function parseJson(jsonString) {
    var jsonObject = JSON.parse(jsonString);
//    if (!validateLayout(jsonObject)) {
//        return jsonObject;
//    }
    return jsonObject;
}
