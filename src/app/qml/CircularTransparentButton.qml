import QtQuick 2.0
import Ubuntu.Components 1.1

Rectangle {
    property color iconColor: "Grey"
    property Action action
    radius: width * 0.5

    width: units.gu(5)
    height: units.gu(5)

    Loader {
        active: action.iconName
        z: parent.z + 0.1
        scale: 0.5
        anchors.fill: parent
        sourceComponent: Icon {
            name: action.iconName
            color: "Grey"
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: action.trigger();
    }

    Component.onCompleted: console.log(action.iconName)
}
