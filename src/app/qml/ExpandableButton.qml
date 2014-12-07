import QtQuick 2.0
import Ubuntu.Components 1.1

Item {
    id: container
    property Component childComponent
    property Component parentComponent: childComponent
    property list<Action> actions
    property Action mainAction

    property real animationTime: 200
    property color textColor: "white"
    property real rotation: 0

    property bool expandable: true

    property int selectedIndex: -1
    property bool expanded: __expanded && expandable
    property bool __expanded: mainMouseArea.pressed && !clickTimer.running

    property real __rotationRads: rotation * Math.PI * 0.5
    property bool __isHorizontal: rotation % 2 === 0
    property bool __isInverted: __isHorizontal
                                    ? Math.cos(__rotationRads) < 0
                                    : Math.sin(__rotationRads) < 0

    // Emit haptic feedback.
    onSelectedIndexChanged: pressFeedbackEffect.start();
    onExpandedChanged: pressFeedbackEffect.start();

    Loader {
        sourceComponent: parentComponent
        width: container.width
        height: parent.height
    }

    PressFeedback {
        id: pressFeedbackEffect
    }

    Component {
        id: repeaterDelegate
        Loader {
            id: delegateContainer
            sourceComponent: childComponent
            width: container.width
            height: container.height

            Behavior on x {
                NumberAnimation { duration: animationTime }
            }

            Behavior on y {
                NumberAnimation { duration: animationTime }
            }

            Behavior on opacity {
                NumberAnimation { duration: animationTime }
            }

            Rectangle {
                color: UbuntuColors.orange;
                anchors.fill: parent
                z: parent.z + 0.01
                opacity: index == selectedIndex ? 0.5 : 0.0

                Behavior on opacity {
                    UbuntuNumberAnimation { }
                }
            }

            Loader {
                z: parent.z + 0.01
                anchors.centerIn: parent
                active: actions[index].text
                sourceComponent: Text {
                    color: textColor
                    text: actions[index].text
                }
            }

            Loader {
                anchors.fill: parent
                scale: 0.5
                active: actions[index].iconName
                sourceComponent: Icon {
                    name: actions[index].iconName
                }
            }

            states: [
                State {
                    name: "expanded"
                    when: expanded
                    PropertyChanges {
                        target: delegateContainer
                        opacity: 1.0
                        x: (index + 1) * width * Math.cos(__rotationRads);
                        y: (index + 1) * height * Math.sin(__rotationRads);
                    }
                },
                State {
                    name: "collapsed"
                    when: !expanded
                    PropertyChanges {
                        target: delegateContainer
                        opacity: 0.0
                        x: 0
                        y: 0
                    }
                }
            ]
        }
    }

    Timer {
        id: clickTimer
        interval: 400 // TODO This interval might need tweaking.
    }

    MouseArea {
        id: mainMouseArea
        property real __expandedWidth: container.width * (1 + Math.abs(Math.cos(__rotationRads)) * actions.length)
        property real __expandedHeight: container.height * (1 + Math.abs(Math.sin(__rotationRads)) * actions.length)
        width: (expanded ? __expandedWidth : container.width)
        height: (expanded ? __expandedHeight : container.height)
        z: parent.z + 0.1
        x: (__isHorizontal  && __isInverted ? -width + container.width  : 0)
        y: (!__isHorizontal && __isInverted ? -height + container.height : 0)

        enabled: expandable

        onPressed: {
            if (mainAction)
                clickTimer.start();
        }

        onPositionChanged: {
            if (containsMouse) {
                var index = __isHorizontal
                                ? Math.floor(mouse.x / container.width)
                                : Math.floor(mouse.y / container.height);

                if (__isInverted)
                    index = actions.length - index;

                selectedIndex = index - 1;
            }
        }

        onReleased: {
            if (clickTimer.running && mainAction)
                mainAction.trigger();
            else if (selectedIndex >= 0 && mainMouseArea.containsMouse)
                actions[selectedIndex].trigger();
        }
    }

    Repeater {
        id: repeater
        model: actions
        delegate: repeaterDelegate
    }
}
