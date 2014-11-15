import QtQuick 2.0
import Ubuntu.Components 1.0

KeyboardRow {
    id: functionKeyBars
    keyWidth: units.gu(6)

    keyDeleagte: UbuntuShape {
        color: UbuntuColors.coolGrey
    }

    actions: [
        Action {text: "ESC"; onTriggered: simulateKey(Qt.Key_Escape, Qt.NoModifier);},
        Action {text: "F1"; onTriggered: simulateKey(Qt.Key_F1, Qt.NoModifier);},
        Action {text: "F2"; onTriggered: simulateKey(Qt.Key_F2, Qt.NoModifier);},
        Action {text: "F3"; onTriggered: simulateKey(Qt.Key_F3, Qt.NoModifier);},
        Action {text: "F4"; onTriggered: simulateKey(Qt.Key_F4, Qt.NoModifier);},
        Action {text: "F5"; onTriggered: simulateKey(Qt.Key_F5, Qt.NoModifier);},
        Action {text: "F6"; onTriggered: simulateKey(Qt.Key_F6, Qt.NoModifier);},
        Action {text: "F7"; onTriggered: simulateKey(Qt.Key_F7, Qt.NoModifier);},
        Action {text: "F8"; onTriggered: simulateKey(Qt.Key_F8, Qt.NoModifier);},
        Action {text: "F9"; onTriggered: simulateKey(Qt.Key_F9, Qt.NoModifier);},
        Action {text: "F10"; onTriggered: simulateKey(Qt.Key_F10, Qt.NoModifier);},
        Action {text: "F11"; onTriggered: simulateKey(Qt.Key_F11, Qt.NoModifier);},
        Action {text: "F12"; onTriggered: simulateKey(Qt.Key_F12, Qt.NoModifier);}
    ]
}
