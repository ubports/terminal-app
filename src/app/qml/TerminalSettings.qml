/*
 * Copyright (C) 2014 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored-by: Filippo Scognamiglio <flscogna@gmail.com>
 */
import QtQuick 2.4
import Qt.labs.settings 1.0

import "KeyboardRows/jsonParser.js" as Parser

Item {
    id: rootItem
    property alias fontSize: innerSettings.fontSize
    property alias fontStyle: innerSettings.fontStyle
    property alias colorScheme: innerSettings.colorScheme

    readonly property int defaultFontSize: 12
    readonly property int minFontSize: 4
    readonly property int maxFontSize: 50

    property alias jsonVisibleProfiles: innerSettings.jsonVisibleProfiles

    property ListModel profilesList: ListModel {}

    signal profilesChanged();

    onProfilesChanged: saveProfileVisibleStrings();

    function saveProfileVisibleStrings() {
        var result = {};

        for (var i = 0; i < profilesList.count; i++) {
            var profileObject = profilesList.get(i);
            result[profileObject.file] = profileObject.profileVisible;
        }

        jsonVisibleProfiles = JSON.stringify(result);
    }

    Settings {
        id: innerSettings
        property int fontSize: defaultFontSize
        property string fontStyle: "Ubuntu Mono"
        property string colorScheme: "Ubuntu"
        property string jsonVisibleProfiles: "[]"
    }

    // Load the keyboard profiles.
    Component.onCompleted: {
        var visibleProfiles = undefined;
        try {
            visibleProfiles = JSON.parse(innerSettings.jsonVisibleProfiles);
        } catch (e) {}

        function isProfileVisible(profilePath) {
            return !(visibleProfiles[profilePath] === false);
        }

        for (var i = 0; i < keyboardLayouts.length; i++) {
            var filePath = keyboardLayouts[i];
            var isVisible = isProfileVisible(filePath);

            try {
                var profileObject = Parser.parseJson(fileIO.read(filePath));

                var name = "";
                if (profileObject.id)
                    name = translator.getTranslatedNameById(translator.name, profileObject.id);
                if (name === "")
                    name = profileObject.name;

                profilesList.append(
                        {
                            file: filePath,
                            profileVisible: isVisible,
                            object: profileObject,
                            name: name
                        });
            } catch (e) {
                console.error("Error in profile", filePath);
                console.error(e);
            }
        }
        profilesChanged();
    }
}
