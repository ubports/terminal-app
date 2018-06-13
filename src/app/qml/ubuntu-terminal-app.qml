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
import QtQuick 2.5
import QtSystemInfo 5.5
import QMLTermWidget 1.0
import Terminal 0.1
import "helpers.js" as Helpers
import "KeyboardRows"

QtObject {
    id: terminalAppRoot

    property string userPassword: ""
    readonly property bool sshMode: sshIsAvailable && sshRequired && (userPassword != "")

    property string customizedSchemeFile: StandardPaths.writableLocation(StandardPaths.AppConfigLocation)
                                            + "/customized.colorscheme"
    property string customizedSchemeName: "customized"

    function loadCustomizedTheme() {
        if (!FileIO.exists(customizedSchemeFile)) {
            var currentScheme = ColorSchemeManager.findColorScheme(settings.colorScheme);
            currentScheme.write(customizedSchemeFile);
        }
        ColorSchemeManager.loadCustomColorScheme(customizedSchemeFile);
    }

    Component.onCompleted: initialize()

    function initialize() {
        i18n.domain = Qt.application.name;
        loadCustomizedTheme();
        createTerminalWindow();
    }

    property var focusedTerminal
    property int terminalWindowCount: 0
    onTerminalWindowCountChanged: if (terminalWindowCount == 0) Qt.quit()
    function createTerminalWindow() {
        var workingDirectory = focusedTerminal ? focusedTerminal.session.getWorkingDirectory()
                                               : "$HOME";
        Helpers.createComponentInstance(terminalWindowComponent, terminalAppRoot,
                                        {"initialWorkingDirectory": workingDirectory});
        terminalWindowCount += 1;
    }

    property Component terminalWindowComponent: TerminalWindow {
        onClosing: terminalAppRoot.terminalWindowCount -= 1;
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

    property list<Shortcut> applicationShortcuts: [
        Shortcut {
            sequence: settings.shortcutNewWindow
            context: Qt.ApplicationShortcut
            onActivated: terminalAppRoot.createTerminalWindow();
        },
        Shortcut {
            sequence: StandardKey.ZoomIn
            context: Qt.ApplicationShortcut
            onActivated: settings.fontSize = Math.min(settings.fontSize + 1, settings.maxFontSize)
        },
        Shortcut {
            sequence: StandardKey.ZoomOut
            context: Qt.ApplicationShortcut
            onActivated: settings.fontSize = Math.max(settings.fontSize - 1, settings.minFontSize)
        },
        Shortcut {
            sequence: "Ctrl+0"
            context: Qt.ApplicationShortcut
            onActivated: settings.fontSize = settings.defaultFontSize
        }
    ]
}
