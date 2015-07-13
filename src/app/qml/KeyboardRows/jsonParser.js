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
}

function validateStringAction(stringObject) {
    if (!stringObject.string)
        raiseException("string is missing in", stringObject);
}

function validateAction(actionObject) {
    if (!actionObject.type)
        raiseException("type is missing in", actionObject);
    if (!isAllowed(actionObject.type, ["key", "string"]))
        raiseException("type must be either key or string in", actionObject);
    if (!(actionObject.type === "key" ? actionObject.key : actionObject.string))
        raiseException(actionObject.type + " is missing in", actionObject);
    if (actionObject.id && actionObject.text)
        raiseException("Should not define id and text together in", actionObject);
    if (!actionObject.id && !actionObject.text && !(actionObject.type === "key" && actionObject.key)) // We can also build the text from the key
        raiseException("text or id is missing in", actionObject);


    // No need to check for "if (!actionObject.id && !actionObject.text)" as we will
    // build the displayed text from the keys in that case

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

    var other_actions = buttonObject.other_actions;
    if (other_actions) {
        if (!Array.isArray(other_actions))
            raiseException("other_actions is not an array", other_actions);

        for (var i = 0; i < other_actions.length; i++) {
            validateAction(other_actions[i]);
        }
    }
}

function validateLayout(layoutObject) {
    if (!layoutObject.id) {
        if (!layoutObject.name)
            raiseException("name or id is missing in", layoutObject);
        if (!layoutObject.short_name)
            raiseException("short_name or id is missing in", layoutObject);
    } else {
        if (layoutObject.name)
            raiseException("Should not define id and name together in", layoutObject);
        if (layoutObject.short_name)
            raiseException("Should not define id and short_name together in", layoutObject);
    }

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
