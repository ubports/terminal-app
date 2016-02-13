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
 * Authored by: Arto Jalkanen <ajalkane@gmail.com>
 */
import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
    id: root

    title: i18n.tr("Authentication required")

    text: i18n.tr("Enter passcode or passphrase:")

    signal passwordEntered(string password)
    signal dialogCanceled

    // Due to several different things forcing focus
    // on creation, we simply create this timer to
    // work around that (see bugs #1488481 and #1499994)
    Timer {
        interval: 1
        running: true
        onTriggered: passwordField.forceActiveFocus()
    }

    Component.onCompleted: {
        passwordField.forceActiveFocus();
    }

    TextField {
        id: passwordField
        objectName: "inputField"
        placeholderText: i18n.tr("passcode or passphrase")
        echoMode: TextInput.Password

        onAccepted: okButton.clicked(text)
    }

    Button {
        id: okButton
        objectName: "okButton"

        text: i18n.tr("OK")
        color: UbuntuColors.green

        onClicked: {
            passwordEntered(passwordField.text)
            passwordField.text = "";
        }
    }

    Button {
        id: cancelButton
        objectName: "cancelButton"
        text: i18n.tr("Cancel")

        color: UbuntuColors.red

        onClicked: {
            dialogCanceled();
        }
    }
}
