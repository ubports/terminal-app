import QtQuick 2.3

MultiPointTouchArea{
    property bool touchAreaPressed: false
    property real swipeDelta: units.gu(1)

    // Mouse signals
    signal mouseMoveDetected(int x, int y, int button, int buttons, int modifiers);
    signal doubleClickDetected(int x, int y, int button, int buttons, int modifiers);
    signal mousePressDetected(int x, int y, int button, int buttons, int modifiers);
    signal mouseReleaseDetected(int x, int y, int button, int buttons, int modifiers);
    signal mouseWheelDetected(int x, int y, int buttons, int modifiers, int angleDelta);

    // Touch signals
    signal touchPress(int x, int y);
    signal touchRelease(int x, int y);
    signal swipeUpDetected();
    signal swipeDownDetected();

    anchors.fill: parent
    maximumTouchPoints: 1
    onPressed: {
        touchAreaPressed = true;
        touchPress(touchPoints[0].x, touchPoints[0].y);
    }
    onUpdated: {
        if (touchPoints[0].y - touchPoints[0].previousY > swipeDelta) {
            swipeDownDetected();
        } else if (touchPoints[0].y - touchPoints[0].previousY < -swipeDelta) {
            swipeUpDetected();
        }
    }
    onReleased: {
        touchRelease(touchPoints[0].x, touchPoints[0].y);
        touchAreaPressed = false;
    }

    mouseEnabled: true

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: !parent.touchAreaPressed

        onDoubleClicked: {
            mouseMoveDetected(mouse.x, mouse.y, mouse.button, mouse.buttons, mouse.modifiers);
        }
        onPositionChanged: {
            mouseMoveDetected(mouse.x, mouse.y, mouse.button, mouse.buttons, mouse.modifiers);
        }
        onPressed: {
            mousePressDetected(mouse.x, mouse.y, mouse.button, mouse.buttons, mouse.modifiers);
        }
        onReleased: {
            mouseReleaseDetected(mouse.x, mouse.y, mouse.button, mouse.buttons, mouse.modifiers);
        }
        onWheel: {
            mouseWheelDetected(wheel.x, wheel.y, wheel.buttons, wheel.modifiers, wheel.angleDelta);
        }
    }
}
