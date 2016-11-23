/*
 * Copyright (C) 2014 - 2016 Canonical Ltd
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
 *              Florian Boucault <florian.boucault@canonical.com>
 */
import QtQuick 2.4
import QtSystemInfo 5.5
import "helpers.js" as Helpers
import "KeyboardRows"

QtObject {
    id: terminalAppRoot

    property string userPassword: ""
    readonly property bool sshMode: sshIsAvailable && sshRequired && (userPassword != "")

    Component.onCompleted: initialize()

    function initialize() {
        i18n.domain = Qt.application.name;
        createTerminalWindow();
    }

    function createTerminalWindow() {
        Helpers.createComponentInstance(terminalWindowComponent, terminalAppRoot, {});
    }

    property Component terminalWindowComponent: TerminalWindow {
    }

    function openSettingsPage() {
        if (!settingsLoader.item) {
            settingsLoader.active = true;
        } else {
            settingsLoader.item.requestActivate();
        }
    }

    property Loader settingsLoader: Loader {
        source: Qt.resolvedUrl("SettingsWindow.qml")
        active: false
        asynchronous: true

        Connections {
            target: settingsLoader.item
            onClosing: settingsLoader.active = false
        }
    }

    property QtObject settings: TerminalSettings {
    }

    property QtObject translator: JsonTranslator {
    }

    property QtObject keyboardsModel: InputDeviceManager {
        filter: InputInfo.Keyboard
    }

    property QtObject miceModel: InputDeviceManager {
        filter: InputInfo.Mouse
    }

    property QtObject touchpadsModel: InputDeviceManager {
        filter: InputInfo.TouchPad
    }

    // WORKAROUND: Not yet implemented in the SDK
    property QtObject mouseAttached: Binding {
        target: QuickUtils
        property: "mouseAttached"
        value: miceModel.count > 0 || touchpadsModel.count > 0
    }

    // WORKAROUND: Not yet implemented in the SDK
    property QtObject keyboardAttached: Binding {
        target: QuickUtils
        property: "keyboardAttached"
        value: keyboardsModel.count > 0
    }
}
