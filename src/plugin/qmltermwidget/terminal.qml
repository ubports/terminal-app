import QtQuick 2.0
import QMLTermWidget 1.0
import QtQuick.Controls 1.2

Rectangle {
    width: 640
    height: 480

    Action{
        onTriggered: terminal.copyClipboard();
        shortcut: "Ctrl+Shift+C"
    }

    Action{
        onTriggered: terminal.pasteClipboard();
        shortcut: "Ctrl+Shift+V"
    }

    QMLTermWidget {
        id: terminal
        anchors.fill: parent
        anchors.margins: 10
        focus: true
	//shellProgram: "top"
        onSessionFinished: Qt.quit() 
        //initialWorkingDirectory: "/tmp"

	//colorScheme: "GreenOnBlack"

	font.pointSize: 12 
        font.family: "Ubuntu Mono"            

        Keys.onPressed: {
            simulateKeyPress(event.key, event.modifiers, true, event.nativeScanCode, event.text);
            event.accepted = true;
        }

        MouseArea {
            anchors.fill: parent
            onDoubleClicked: terminal.simulateMouseDoubleClick(mouse.x, mouse.y, mouse.button, mouse.buttons, mouse.modifiers)
	    onPositionChanged: terminal.simulateMouseMove(mouse.x, mouse.y, mouse.button, mouse.buttons, mouse.modifiers)
            onPressed: terminal.simulateMousePress(mouse.x, mouse.y, mouse.button, mouse.buttons, mouse.modifiers)
	    onReleased: terminal.simulateMouseRelease(mouse.x, mouse.y, mouse.button, mouse.buttons, mouse.modifiers) 
	    onWheel: {terminal.simulateWheel(wheel.x, wheel.y, wheel.buttons, wheel.modifiers, wheel.angleDelta); } 
        }
	Component.onCompleted: {
	    //console.log(terminal.availableColorSchemes);
	    terminal.startShellProgram();
        }
    }
}
