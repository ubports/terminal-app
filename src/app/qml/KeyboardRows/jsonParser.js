.pragma library

// This small library prints semantic errors of bad profiles.

function isAllowed(value, allowed) {
    return allowed.indexOf(value) !== -1;
}

function raiseException(msg, obj) {
    throw msg + "\n" + JSON.stringify(obj, null, 2);
}

function validateKeyAction(keyObject) {
    if (!keyObject.key)
        return raiseException("key is missing");
    if (keyObject.mod && !isAllowed(keyObject.mod, ["Control", "Shift", "Alt"]))
        return raiseException("mod is invalid in", keyObject);
    return "";
}

function validateStringAction(stringObject) {
    if (!stringObject.string)
        raiseException("string is missing in", stringObject);
    return "";
}

function validateAction(actionObject) {
    if (!actionObject.type)
        raiseException("type is missing in", actionObject);
    if (!isAllowed(actionObject.type, ["key", "string"]))
        raiseException("type must be either key or string in", actionObject);
    if (!actionObject.text)
        raiseException("text is missing in", actionObject);

    switch (actionObject.type) {
    case "key":
        validateKeyAction(actionObject);
        break;
    case "string":
        validateStringAction(actionObject);
        break;
    }
}

function validateButton(buttonObject) {
    if (!buttonObject.main_action)
        raiseException("main_action is missing", buttonObject);

    validateAction(buttonObject.main_action);
}

function validateLayout(layoutObject) {
    if (!layoutObject.name)
        raiseException("name is missing in ", layoutObject);
    if (!layoutObject.short_name)
        raiseException("short_name is missing in", layoutObject);
    if (!layoutObject.buttons)
        raiseException("buttons is missing in", layoutObject);

    for (var i = 0; i < layoutObject.buttons.length; i++) {
        validateButton(layoutObject.buttons[i]);
    }
}

function parseJson(jsonString) {
    var jsonObject = JSON.parse(jsonString);
    validateLayout(jsonObject);

    return jsonObject;
}
