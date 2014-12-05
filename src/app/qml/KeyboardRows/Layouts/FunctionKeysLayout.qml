import QtQuick 2.0
import Ubuntu.Components 1.1

import ".."

KeyboardRow {
    keyWidth: units.gu(6)
    model: [
        KeyModel {
            text: "ESC"
            actions: [Action { onTriggered: simulateKey(Qt.Key_Escape, Qt.NoModifier); }]
        },
        KeyModel {
            text: "F1"
            actions: [Action { onTriggered: simulateKey(Qt.Key_F1, Qt.NoModifier);}]
        },
        KeyModel {
            text: "F2"
            actions: [Action { onTriggered: simulateKey(Qt.Key_F2, Qt.NoModifier);}]
        },
        KeyModel {
            text: "F3"
            actions: [Action { onTriggered: simulateKey(Qt.Key_F3, Qt.NoModifier);}]
        },
        KeyModel {
            text: "F4"
            actions: [Action { onTriggered: simulateKey(Qt.Key_F4, Qt.NoModifier);}]
        },
        KeyModel {
            text: "F5"
            actions: [Action { onTriggered: simulateKey(Qt.Key_F5, Qt.NoModifier);}]
        },
        KeyModel {
            text: "F6"
            actions: [Action { onTriggered: simulateKey(Qt.Key_F6, Qt.NoModifier);}]
        },
        KeyModel {
            text: "F7"
            actions: [Action { onTriggered: simulateKey(Qt.Key_F7, Qt.NoModifier);}]
        },
        KeyModel {
            text: "F8"
            actions: [Action { onTriggered: simulateKey(Qt.Key_F8, Qt.NoModifier);}]
        },
        KeyModel {
            text: "F9"
            actions: [Action { onTriggered: simulateKey(Qt.Key_F9, Qt.NoModifier);}]
        },
        KeyModel {
            text: "F10"
            actions: [Action { onTriggered: simulateKey(Qt.Key_F10, Qt.NoModifier);}]
        },
        KeyModel {
            text: "F11"
            actions: [Action { onTriggered: simulateKey(Qt.Key_F11, Qt.NoModifier);}]
        },
        KeyModel {
            text: "F12"
            actions: [Action { onTriggered: simulateKey(Qt.Key_F12, Qt.NoModifier);}]
        }
    ]
}
