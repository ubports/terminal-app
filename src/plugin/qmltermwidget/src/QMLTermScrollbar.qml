import QtQuick 2.0
import Ubuntu.Components 1.3
import QMLTermWidget 1.0

Item {
    property QMLTermWidget terminal
    onTerminalChanged: terminalProxyFlickable.updateFromTerminal()

    Flickable {
        id: terminalProxyFlickable
        anchors.fill: parent
        enabled: false

        property bool updating: false

        function updateTerminal() {
            if (!terminal) return;
            if (updating) return;
            updating = true;
            terminal.scrollbarCurrentValue = contentY * terminal.scrollbarMaximum / (contentHeight - height);
            updating = false;
        }

        function updateFromTerminal() {
            if (!terminal) return;
            if (updating) return;
            updating = true;
            contentHeight = height * terminal.totalLines / terminal.lines;
            contentY = (contentHeight - height) * terminal.scrollbarCurrentValue / terminal.scrollbarMaximum;
            // pretend to flick so that the scrollbar appears
            flick(0.0, 0.0);
            cancelFlick();
            updating = false;
        }

        onContentYChanged: terminalProxyFlickable.updateTerminal()

        Connections {
            target: terminal
            onScrollbarMaximumChanged: terminalProxyFlickable.updateFromTerminal()
            onScrollbarCurrentValueChanged: terminalProxyFlickable.updateFromTerminal()
            onTotalLinesChanged: terminalProxyFlickable.updateFromTerminal()
            onLinesChanged: terminalProxyFlickable.updateFromTerminal()
        }
    }

    Scrollbar {
        flickableItem: terminalProxyFlickable
        align: Qt.AlignTrailing
        enabled: flickableItem.visibleArea.heightRatio != 1.0
    }
}
