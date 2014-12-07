import QtQuick 2.0
import Ubuntu.Components 1.1

import ".."

KeyboardRow {
    keyWidth: units.gu(8)
    model: [
        KeyModel {
            text: "PG_UP"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_PageUp, Qt.NoModifier); }
        },
        KeyModel {
            text: "PG_DN"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_PageDown, Qt.NoModifier); }
        },
        KeyModel {
            text: "DEL"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_Delete, Qt.NoModifier); }
        },
        KeyModel {
            text: "HOME"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_Home, Qt.NoModifier); }
        },
        KeyModel {
            text: "END"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_End, Qt.NoModifier); }
        },
        KeyModel {
            text: "TAB"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_Tab, Qt.NoModifier); }
        },
        KeyModel {
            text: "\u2191"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_Up, Qt.NoModifier); }
        },
        KeyModel {
            text: "\u2193"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_Down, Qt.NoModifier); }
        },
        KeyModel {
            text: "\u2190"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_Left, Qt.NoModifier); }
        },
        KeyModel {
            text: "\u2192"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_Right, Qt.NoModifier); }
        }
    ]
}
