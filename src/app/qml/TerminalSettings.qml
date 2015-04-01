import QtQuick 2.0
import Qt.labs.settings 1.0

import "KeyboardRows/jsonParser.js" as Parser

Item {
    id: rootItem
    property alias fontSize: innerSettings.fontSize
    property alias fontStyle: innerSettings.fontStyle
    property alias colorScheme: innerSettings.colorScheme
    property alias showKeyboardBar: innerSettings.showKeyboardBar

    property alias jsonVisibleProfiles: innerSettings.jsonVisibleProfiles

    property ListModel profilesList: ListModel {}

    signal profilesChanged();

    Settings {
        id: innerSettings
        property int fontSize: 14
        property string fontStyle: "Ubuntu Mono"
        property string colorScheme: "Ubuntu"
        property bool showKeyboardBar: true
        property string jsonVisibleProfiles: "[]"

        // Store the profile visibilities as a json string.
        Component.onDestruction: {
            var result = {};

            for (var i = 0; i < profilesList.count; i++) {
                var profileObject = profilesList.get(i);
                result[profileObject.file] = profileObject.profileVisible;
            }

            jsonVisibleProfiles = JSON.stringify(result);
        }
    }

    // Load the keyboard profiles.
    Component.onCompleted: {
        var visibleProfiles = undefined;
        try {
            visibleProfiles = JSON.parse(innerSettings.jsonVisibleProfiles);
        } catch (e) {}

        for (var i = 0; i < keyboardLayouts.length; i++) {
            var filePath = keyboardLayouts[i];
            var isVisible = visibleProfiles && visibleProfiles[filePath];

            try {
                var profileObject = Parser.parseJson(fileIO.read(filePath));

                profilesList.append(
                        {
                            file: filePath,
                            profileVisible: isVisible,
                            object: profileObject,
                            name: profileObject.name
                        });
            } catch (e) {
                console.error("Error in profile", filePath);
                console.error(e);
            }
        }
        profilesChanged();
    }
}
