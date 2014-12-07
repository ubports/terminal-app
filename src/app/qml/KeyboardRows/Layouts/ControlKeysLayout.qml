import QtQuick 2.0
import Ubuntu.Components 1.1

import ".."

KeyboardRow {
    keyWidth: units.gu(10)
    model: [
        KeyModel {
            text: "CTRL+R"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_R, Qt.ControlModifier);}
        },
        KeyModel {
            text: "CTRL+C"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_C, Qt.ControlModifier);}
        },
        KeyModel {
            text: "CTRL+Z"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_Z, Qt.ControlModifier);}
        },
        KeyModel {
            text: "CTRL+A"
            mainAction: Action { onTriggered: simulateKey(Qt.Key_A, Qt.ControlModifier);}
        }
    ]
}
