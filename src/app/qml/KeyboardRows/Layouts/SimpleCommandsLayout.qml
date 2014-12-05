import QtQuick 2.0
import Ubuntu.Components 1.1

import ".."

KeyboardRow {
    keyWidth: units.gu(8)
    model: [
        KeyModel {
            text: "top"
            actions: [Action { onTriggered: simulateCommand("top\n"); }]
        },
        KeyModel {
            text: "clear"
            actions: [Action { onTriggered: simulateCommand("clear\n"); }]
        },
        KeyModel {
            text: "ls"
            actions: [
                Action { text: "-a"; onTriggered: simulateCommand("ls -a\n"); },
                Action { text: "-l"; onTriggered: simulateCommand("ls -l\n"); }
            ]
        }
    ]
}
