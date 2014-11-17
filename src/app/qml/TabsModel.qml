import QtQuick 2.0

ListModel {
    property int selectedIndex: 0
    property int maxTabs: 8

    id: tabsModel

    function addTab() {
        if (count >= 8)
            return;

        var termObject = terminalComponent.createObject(terminalPage.terminalContainer);
        tabsModel.append({terminal: termObject});

        termObject.visible = false;
    }

    function __disableTerminal(term) {
        term.visible = false;
        term.z = 0;
        term.focus = false;
        terminalPage.terminal = null;
    }

    function __enableTerminal(term) {
        term.visible = true;
        term.z = 1;
        term.forceActiveFocus();
        terminalPage.terminal = term;
    }

    function selectTab(index) {
        __disableTerminal(get(selectedIndex).terminal);
        __enableTerminal(get(index).terminal);
        selectedIndex = index;
    }

    function removeTab(index) {
        if (tabsModel.count <= 1)
            return;
        get(index).terminal.destroy();
        remove(index);

        // Decrease the selected index to keep the state consistent.
        if (index <= selectedIndex)
            selectedIndex = Math.max(selectedIndex - 1, 0);
        selectTab(selectedIndex);
    }
}
