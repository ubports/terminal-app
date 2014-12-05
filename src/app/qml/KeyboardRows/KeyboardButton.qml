import QtQuick 2.0
import Ubuntu.Components 1.1

Rectangle {
    property alias text: mainLabel.text
    property Action action

    color: "black"

    Text {
        id: mainLabel
        anchors.centerIn: parent
        color: "white"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: action.trigger();
    }
}
