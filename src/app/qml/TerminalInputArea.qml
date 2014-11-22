import QtQuick 2.3

MultiPointTouchArea{
    property bool touchAreaPressed: false
    property real swipeDelta: units.gu(1)

    // Mouse signals
    signal mouseMoveDetected(int x, int y, int button, int buttons, int modifiers);
    signal doubleClickDetected(int x, int y, int button, int buttons, int modifiers);
    signal mousePressDetected(int x, int y, int button, int buttons, int modifiers);
    signal mouseReleaseDetected(int x, int y, int button, int buttons, int modifiers);
    signal mouseWheelDetected(int x, int y, int buttons, int modifiers, point angleDelta);

    // Touch signals
    signal touchPressAndHold(int x, int y);
    signal touchClick(int x, int y);
    signal touchPress(int x, int y);
    signal touchRelease(int x, int y);
    signal swipeUpDetected();
    signal swipeDownDetected();

    // Semantic signals
    signal alternateAction(int x, int y);

    // Private parameters.
    property bool __moved: false
    property point __pressPosition: Qt.point(0, 0);
    property real __prevDragSteps: 0

    // TODO Interval should be the same used by all system applications.
    Timer {
        id: pressAndHoldTimer
        running: false
        onTriggered: {
            touchPressAndHold(__pressPosition.x, __pressPosition.y);
        }
    }

    function absFloor(val) {
        return val > 0 ? Math.floor(val) : Math.ceil(val);
    }

    anchors.fill: parent
    maximumTouchPoints: 1
    onPressed: {
        touchAreaPressed = true;
        __moved = false;
        __prevDragSteps = 0.0;
        __pressPosition = Qt.point(touchPoints[0].x, touchPoints[0].y);
        pressAndHoldTimer.start();

        touchPress(touchPoints[0].x, touchPoints[0].y);
    }
    onUpdated: {
        var dragValue = touchPoints[0].y - __pressPosition.y;
        var dragSteps = dragValue / swipeDelta;

        if (absFloor(dragSteps) < absFloor(__prevDragSteps)) {
            __moved = true;
            swipeUpDetected();
        } else if (absFloor(dragSteps) > absFloor(__prevDragSteps)) {
            __moved = true;
            swipeDownDetected();
        }

        __prevDragSteps = dragSteps;
    }
    onReleased: {
        var timerRunning = pressAndHoldTimer.running;
        pressAndHoldTimer.stop();
        touchAreaPressed = false;

        if (!__moved && timerRunning) {
            touchClick(touchPoints[0].x, touchPoints[0].y);
        }

        touchRelease(touchPoints[0].x, touchPoints[0].y);
    }

    mouseEnabled: true

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !parent.touchAreaPressed
        acceptedButtons: Qt.AllButtons

        onDoubleClicked: {
            doubleClickDetected(mouse.x, mouse.y, mouse.button, mouse.buttons, mouse.modifiers);
        }
        onPositionChanged: {
            mouseMoveDetected(mouse.x, mouse.y, mouse.button, mouse.buttons, mouse.modifiers);
        }
        onPressed: {
            // Do not handle the right click if the terminal needs them.
            if (mouse.button === Qt.RightButton && !terminal.terminalUsesMouse) {
                alternateAction(mouse.x, mouse.y);
            } else {
                mousePressDetected(mouse.x, mouse.y, mouse.button, mouse.buttons, mouse.modifiers);
            }
        }
        onReleased: {
            mouseReleaseDetected(mouse.x, mouse.y, mouse.button, mouse.buttons, mouse.modifiers);
        }
        onWheel: {
            mouseWheelDetected(wheel.x, wheel.y, wheel.buttons, wheel.modifiers, wheel.angleDelta);
        }
    }
}
