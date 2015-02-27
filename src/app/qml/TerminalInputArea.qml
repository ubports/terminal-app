import QtQuick 2.3

Item{
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
    signal swipeLeftDetected();
    signal swipeRightDetected();
    signal twoFingerSwipeUp();
    signal twoFingerSwipeDown();

    // Semantic signals
    signal alternateAction(int x, int y);

    function avg(p1, p2) {
        return Qt.point((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
    }

    function distance(p1, p2) {
        return Math.sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
    }

    function absFloor(val) {
        return val > 0 ? Math.floor(val) : Math.ceil(val);
    }

    MultiPointTouchArea {
        property bool __moved: false
        property point __pressPosition: Qt.point(0, 0);
        property real __prevDragStepsY: 0
        property real __prevDragStepsX: 0

        // This enum represent the status of the dragging.
        // It is used to avoid simultaneously dragging along both axies
        // as it's very error prone.

        readonly property int noDragging: 0
        readonly property int yDragging: 1
        readonly property int xDragging: 2
        property real __dragging: noDragging

        id: singleTouchTouchArea

        anchors.fill: parent
        z: parent.z + 0.01

        // TODO Interval should be the same used by all system applications.
        Timer {
            id: pressAndHoldTimer
            running: false
            onTriggered: {
                if (!parent.__moved)
                    touchPressAndHold(singleTouchTouchArea.__pressPosition.x,
                                      singleTouchTouchArea.__pressPosition.y);
            }
        }

        maximumTouchPoints: 1
        onPressed: {
            touchAreaPressed = true;
            __moved = false;
            __prevDragStepsY = 0.0;
            __prevDragStepsX = 0.0;
            __dragging = noDragging;
            __pressPosition = Qt.point(touchPoints[0].x, touchPoints[0].y);
            pressAndHoldTimer.start();

            touchPress(touchPoints[0].x, touchPoints[0].y);
        }
        onUpdated: {
            var dragValue = touchPoints[0].y - __pressPosition.y;
            var dragValueX = touchPoints[0].x - __pressPosition.x;
            var dragSteps = dragValue / swipeDelta;
            var dragStepsX = dragValueX / swipeDelta;

            if (!__moved && distance(touchPoints[0], __pressPosition) > swipeDelta)
                __moved = true;

            if (__dragging !== xDragging && absFloor(dragSteps) < absFloor(__prevDragStepsY)) {
                swipeUpDetected();
                __dragging = yDragging;
            } else if (__dragging !== xDragging && absFloor(dragSteps) > absFloor(__prevDragStepsY)) {
                swipeDownDetected();
                __dragging = yDragging;
            } else if (__dragging !== yDragging && absFloor(dragStepsX) < absFloor(__prevDragStepsX)) {
                swipeLeftDetected();
                __dragging = xDragging;
            } else if (__dragging !== yDragging && absFloor(dragStepsX) > absFloor(__prevDragStepsX)) {
                swipeRightDetected();
                __dragging = xDragging;
            }

            __prevDragStepsY = dragSteps;
            __prevDragStepsX = dragStepsX;
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

        MultiPointTouchArea {
            property point __pressPosition: Qt.point(0, 0);
            property real __prevDragSteps: 0

            id: doubleTouchTouchArea
            anchors.fill: parent
            z: parent.z + 0.001

            maximumTouchPoints: 2
            minimumTouchPoints: 2
            onPressed: {
                singleTouchTouchArea.__moved = true;
                __pressPosition = Qt.point(touchPoints[0].x, touchPoints[0].y);
            }
            onUpdated: {
                // WORKAROUND: filter bad events that somehow get here during release.
                if (touchPoints.length !== 2)
                    return;

                var touchPoint = avg(touchPoints[0], touchPoints[1]);
                var dragValue = touchPoint.y - __pressPosition.y;
                var dragSteps = dragValue / swipeDelta;

                if (absFloor(dragSteps) < absFloor(__prevDragSteps)) {
                    twoFingerSwipeUp();
                } else if (absFloor(dragSteps) > absFloor(__prevDragSteps)) {
                    twoFingerSwipeDown();
                }

                __prevDragSteps = dragSteps;
            }

            mouseEnabled: false
        }

        mouseEnabled: false
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !parent.touchAreaPressed
        acceptedButtons: Qt.AllButtons

        z: parent.z

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
