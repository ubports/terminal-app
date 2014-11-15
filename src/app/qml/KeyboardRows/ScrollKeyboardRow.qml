import QtQuick 2.0
import Ubuntu.Components 1.0

KeyboardRow {
    id: functionKeyBars
    keyWidth: units.gu(8)

    keyDeleagte: UbuntuShape {
        color: UbuntuColors.coolGrey
    }

    actions: [
        Action {text: "PG_UP"; onTriggered: simulateKey(Qt.Key_PageUp, Qt.NoModifier);},
        Action {text: "TAB"; onTriggered: simulateKey(Qt.Key_Tab, Qt.NoModifier);},
        Action {text: "\u2191"; onTriggered: simulateKey(Qt.Key_Up, Qt.NoModifier);},
        Action {text: "DEL"; onTriggered: simulateKey(Qt.Key_Delete, Qt.NoModifier);},
        Action {text: "HOME"; onTriggered: simulateKey(Qt.Key_Home, Qt.NoModifier);},
        Action {text: "PG_DN"; onTriggered: simulateKey(Qt.Key_PageDown, Qt.NoModifier);},
        Action {text: "\u2190"; onTriggered: simulateKey(Qt.Key_Left, Qt.NoModifier);},
        Action {text: "\u2193"; onTriggered: simulateKey(Qt.Key_Down, Qt.NoModifier);},
        Action {text: "\u2192"; onTriggered: simulateKey(Qt.Key_Right, Qt.NoModifier);},
        Action {text: "END"; onTriggered: simulateKey(Qt.Key_End, Qt.NoModifier);}
    ]
}
