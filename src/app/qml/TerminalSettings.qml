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
import Terminal 0.1

import "KeyboardRows/jsonParser.js" as Parser

QtObject {
    property alias fontSize: innerSettings.fontSize
    property alias fontStyle: innerSettings.fontStyle
    property alias colorScheme: innerSettings.colorScheme
    property alias shortcutNewWindow: innerSettings.shortcutNewWindow
    property alias shortcutNewTab: innerSettings.shortcutNewTab
    property alias shortcutCloseTab: innerSettings.shortcutCloseTab
    property alias shortcutCloseAllTabs: innerSettings.shortcutCloseAllTabs
    property alias shortcutPreviousTab: innerSettings.shortcutPreviousTab
    property alias shortcutNextTab: innerSettings.shortcutNextTab
    property alias shortcutCopy: innerSettings.shortcutCopy
    property alias shortcutPaste: innerSettings.shortcutPaste
    property alias shortcutFullscreen: innerSettings.shortcutFullscreen
    property alias shortcutSplitHorizontally: innerSettings.shortcutSplitHorizontally
    property alias shortcutSplitVertically: innerSettings.shortcutSplitVertically
    property alias shortcutMoveToTileAbove: innerSettings.shortcutMoveToTileAbove
    property alias shortcutMoveToTileBelow: innerSettings.shortcutMoveToTileBelow
    property alias shortcutMoveToTileLeft: innerSettings.shortcutMoveToTileLeft
    property alias shortcutMoveToTileRight: innerSettings.shortcutMoveToTileRight

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

    property Settings innerSettings: Settings {
        id: innerSettings
        property int fontSize: defaultFontSize
        property string fontStyle: "Ubuntu Mono"
        property string colorScheme: "Ubuntu"
        property string jsonVisibleProfiles: "[]"
        property string shortcutNewWindow: "Ctrl+Shift+N"
        property string shortcutNewTab: "Ctrl+Shift+T"
        property string shortcutCloseTab: "Ctrl+Shift+W"
        property string shortcutCloseAllTabs: "Ctrl+Shift+Q"
        property string shortcutPreviousTab: "Ctrl+PgUp"
        property string shortcutNextTab: "Ctrl+PgDown"
        property string shortcutCopy: "Ctrl+Shift+C"
        property string shortcutPaste: "Ctrl+Shift+V"
        property string shortcutFullscreen: "F11"
        property string shortcutSplitHorizontally: "Ctrl+Shift+O"
        property string shortcutSplitVertically: "Ctrl+Shift+E"
        property string shortcutMoveToTileAbove: "Alt+Up"
        property string shortcutMoveToTileBelow: "Alt+Down"
        property string shortcutMoveToTileLeft: "Alt+Left"
        property string shortcutMoveToTileRight: "Alt+Right"
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
                var profileObject = Parser.parseJson(FileIO.read(filePath));

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
