/*
 * Copyright (C) 2015 Canonical Ltd
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
 * Author: Niklas Wenzel <nikwen.developer@gmail.com>
 */
import QtQuick 2.4
import Ubuntu.Components 1.3

QtObject {

    // Enum for translation types
    readonly property int name: 0
    readonly property int shortName: 1
    readonly property int modifier: 2
    readonly property int key: 3

    // The first parameter has to be one of the readonly properties above
    function getTranslatedNameById(type, id) {
        switch(type) {
        case name:
            if (id === "ctrl_keys") {
                // TRANSLATORS: This a keyboard layout name
                return i18n.tr("Control Keys");
            } else if (id === "fn_keys") {
                // TRANSLATORS: This a keyboard layout name
                return i18n.tr("Function Keys");
            } else if (id === "scroll_keys") {
                // TRANSLATORS: This a keyboard layout name
                return i18n.tr("Scroll Keys");
            } else if (id === "simple_cmds") {
                // TRANSLATORS: This a keyboard layout name
                return i18n.tr("Command Keys");
            }

            return "";
        case shortName:
            var translation = "";
            if (id === "ctrl_keys") {
                // TRANSLATORS: This the short display name of a keyboard layout. It should be no longer than 4 characters!
                translation = i18n.tr("Ctrl");
            } else if (id === "fn_keys") {
                // TRANSLATORS: This the short display name of a keyboard layout. It should be no longer than 4 characters!
                translation = i18n.tr("Fn");
            } else if (id === "scroll_keys") {
                // TRANSLATORS: This the short display name of a keyboard layout. It should be no longer than 4 characters!
                translation = i18n.tr("Scr");
            } else if (id === "simple_cmds") {
                // TRANSLATORS: This the short display name of a keyboard layout. It should be no longer than 4 characters!
                translation = i18n.tr("Cmd");
            }

            if (translation !== "") {
                // Shorten the string if the translation is longer than 4 characters
                if (translation.length <= 4) {
                    return translation;
                } else {
                    return translation.substring(0, 4);
                }
            }

            return "";
        case modifier:
            var translation = "";
            if (id === "Control") {
                // TRANSLATORS: This is the name of the Control key.
                translation = i18n.tr("CTRL");
            } else if (id === "Alt") {
                // TRANSLATORS: This is the name of the Alt key.
                translation = i18n.tr("Alt");
            } else if (id === "Shift") {
                // TRANSLATORS: This is the name of the Shift key.
                translation = i18n.tr("Shift");
            }

            if (translation !== "") {
                // Always return the translation in uppercase letters
                return translation.toUpperCase();
            }

            return id;
        case key:
            var translation = "";
            if (id === "esc_key") {
                // TRANSLATORS: This is the name of the Escape key.
                translation = i18n.tr("Esc");
            } else if (id === "pg_up_key") {
                // TRANSLATORS: This is the name of the Page Up key.
                translation = i18n.tr("PgUp");
            } else if (id === "pg_dn_key") {
                // TRANSLATORS: This is the name of the Page Down key.
                translation = i18n.tr("PgDn");
            } else if (id === "del_key") {
                // TRANSLATORS: This is the name of the Delete key.
                translation = i18n.tr("Del");
            } else if (id === "home_key") {
                // TRANSLATORS: This is the name of the Home key.
                translation = i18n.tr("Home");
            } else if (id === "end_key") {
                // TRANSLATORS: This is the name of the End key.
                translation = i18n.tr("End");
            } else if (id === "tab_key") {
                // TRANSLATORS: This is the name of the Tab key.
                translation = i18n.tr("Tab");
            } else if (id === "enter_key") {
                // TRANSLATORS: This is the name of the Enter key.
                translation = i18n.tr("Enter");
            }

            return id;
        default:
            return "";
        }
    }

}
