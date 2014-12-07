import QtQuick 2.0
import Ubuntu.Components 1.1

import ".."

KeyboardRow {
    keyWidth: units.gu(6)
    model: [
        KeyModel {
            text: "ESC"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_Escape, Qt.NoModifier); }
        },
        KeyModel {
            text: "F1"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_F1, Qt.NoModifier);}
        },
        KeyModel {
            text: "F2"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_F2, Qt.NoModifier);}
        },
        KeyModel {
            text: "F3"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_F3, Qt.NoModifier);}
        },
        KeyModel {
            text: "F4"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_F4, Qt.NoModifier);}
        },
        KeyModel {
            text: "F5"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_F5, Qt.NoModifier);}
        },
        KeyModel {
            text: "F6"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_F6, Qt.NoModifier);}
        },
        KeyModel {
            text: "F7"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_F7, Qt.NoModifier);}
        },
        KeyModel {
            text: "F8"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_F8, Qt.NoModifier);}
        },
        KeyModel {
            text: "F9"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_F9, Qt.NoModifier);}
        },
        KeyModel {
            text: "F10"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_F10, Qt.NoModifier);}
        },
        KeyModel {
            text: "F11"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_F11, Qt.NoModifier);}
        },
        KeyModel {
            text: "F12"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_F12, Qt.NoModifier);}
        }
    ]
}
