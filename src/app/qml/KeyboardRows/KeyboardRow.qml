import QtQuick 2.0
import Ubuntu.Components 1.0

Rectangle {
    id: container
    property list<Action> actions
    property Component keyDeleagte: defaultDelegate

    // TODO: Again we need to decide which is the best looking delegate (if any).
//    Component {
//        id: defaultDelegate
//        Rectangle {
//            opacity: 0.4
//            radius: width * 0.10
//            gradient: Gradient {
//                GradientStop { position: 0;    color: "#88FFFFFF" }
//                GradientStop { position: .1;   color: "#55FFFFFF" }
//                GradientStop { position: .5;   color: "#33FFFFFF" }
//                GradientStop { position: .501; color: "#11000000" }
//                GradientStop { position: .8;   color: "#11FFFFFF" }
//                GradientStop { position: 1;    color: "#55FFFFFF" }
//            }
//        }
//    }

    Component {
        id: defaultDelegate
        Rectangle { color: "black" }
    }

    signal simulateKey(int key, int mod);

    property real spacing: units.gu(1)
    property color textColor: "white"
    property real keyHeight: units.gu(5)
    property real keyWidth: units.gu(5)

    property real __totalWidth: (keyWidth + spacing) * actions.length
    property int __pages: Math.ceil(__totalWidth / width)
    property int __currentPage: 0

    color: "black"

    // TODO: Top orange bar. Decide what to do with this.
    Rectangle {
        anchors {left: parent.left; right: parent.right; top: parent.top}
        height: units.dp(2)
        color: UbuntuColors.orange;
    }

    Item {
        id: keyContainer
        anchors.verticalCenter: parent.verticalCenter
        height: keyHeight - spacing
        width: __pages * container.width
        x: spacing * 0.5

        layer.enabled: true

        Behavior on x {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutQuad
            }
        }

        Repeater {
            model: actions
            delegate: Loader {
                sourceComponent: keyDeleagte
                width: keyWidth
                height: keyHeight - spacing
                x: index * (keyWidth + spacing)

                Text {
                    z: parent.z + 0.01
                    anchors.centerIn: parent
                    text: actions[index].text
                    color: textColor
                }

                MouseArea {
                    z: parent.z + 0.02
                    anchors.fill: parent
                    onClicked: actions[index].trigger();
                }
            }
        }

        MouseArea {
            property real overshoot: container.width * 0.25
            anchors.fill: parent
            drag.target: keyContainer
            drag.axis: Drag.XAxis
            drag.minimumX: - (width - container.width) - overshoot
            drag.maximumX: overshoot

            propagateComposedEvents: true

            onReleased: {
                // Force the current page fall in the right range.
                var newPage = Math.round((-parent.x / width) * __pages);
                __currentPage = Math.min(Math.max(0, newPage), __pages - 1);

                // Force the first control to be aligned.
                var newPosition = __currentPage * container.width;
                newPosition = Math.floor(newPosition / (keyWidth + spacing)) * (keyWidth + spacing);
                keyContainer.x = - newPosition + spacing * 0.5;

                mouse.accepted = false;
            }
        }
    }
}
