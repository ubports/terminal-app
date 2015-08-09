import QtQuick 2.4
import Ubuntu.Components 1.2

Rectangle {
    property color backgroundColor: "black"
    property real innerOpacity: 1.0
    property color textColor: "white"
    property color iconColor: "white"
    property Action action
    radius: width * 0.5

    color: Qt.rgba(backgroundColor.r, backgroundColor.g, backgroundColor.b, innerOpacity)

    width: units.gu(5)
    height: units.gu(5)

    PressFeedback {
        id: pressFeedbackEffect
    }

    Loader {
        active: action.text
        z: parent.z + 0.1
        anchors.centerIn: parent
        sourceComponent: Text {
            opacity: innerOpacity
            text: action.text
            color: textColor
        }
    }

    Loader {
        active: action.iconName
        z: parent.z + 0.1
        scale: 0.5
        anchors.fill: parent
        sourceComponent: Icon {
            opacity: innerOpacity
            name: action.iconName
            color: iconColor
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            action.trigger();
            pressFeedbackEffect.start();
        }
    }
}
