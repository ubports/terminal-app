/*
 * Copyright (C) 2016 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored-by: Filippo Scognamiglio <flscogna@gmail.com>
 *              Florian Boucault <florian.boucault@canonical.com>
 */
import QtQuick 2.4
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
import Ubuntu.Components 1.3

Window {
    id: terminalWindow

    title: tabsModel.selectedTerminal ? tabsModel.selectedTerminal.session.title : ""
    color: terminalPage.active && terminalPage.terminal ? terminalPage.terminal.backgroundColor : theme.palette.selected.overlay
    contentOrientation: Screen.orientation

    minimumWidth: units.gu(20)
    minimumHeight: units.gu(20)

    property bool narrowLayout

    property int visibilityBeforeFullscreen
    function toggleFullscreen() {
        if (terminalWindow.visibility != Window.FullScreen) {
            visibilityBeforeFullscreen = terminalWindow.visibility;
            terminalWindow.visibility = Window.FullScreen;
        } else {
            terminalWindow.visibility = visibilityBeforeFullscreen;
        }
    }

    AuthenticationService {
        id: authService
        alreadyGranted: terminalAppRoot.userPassword != ""
        onDenied: Qt.quit();
        onGranted: {
            if (sshUser != "") {
                terminalAppRoot.userPassword = password
                tabsModel.addTab()
                tabsModel.removeTab(0)
            }
        }
    }

    TabsModel {
        id: tabsModel
        onCountChanged: if (count == 0) {
                            terminalWindow.close();
                        }
    }

    PageStack {
        id: pageStack
        Component.onCompleted: push(terminalPage)

        property bool prevKeyboardVisible: false

        onCurrentPageChanged: {
            if(currentPage == terminalPage) {
                // Restore previous keyboard state.
                if (prevKeyboardVisible) {
                    Qt.inputMethod.show();
                } else {
                    Qt.inputMethod.hide();
                }

                // Force the focus on the widget when the terminal shown.
                if (terminalPage.terminal) {
                    terminalPage.terminal.forceActiveFocus();
                }
            } else {
                // Force the focus out of the terminal widget.
                currentPage.forceActiveFocus();
                prevKeyboardVisible = Qt.inputMethod.visible;
                Qt.inputMethod.hide();
            }
        }

        TerminalPage {
            id: terminalPage
            tabsModel: tabsModel
            narrowLayout: terminalWindow.narrowLayout
            // Hide terminal data when the access is still not granted
            layer.enabled: authService.isDialogVisible
            layer.effect: FastBlur {
                radius: units.gu(6)
            }
        }

        TabsPage {
            id: tabsPage
            visible: false
        }
    }

    Component.onCompleted: {
        tabsModel.addTab();
        tabsModel.selectTab(0);

        // The margins for the terminal canvas are 2px
        // Hardcoded value from TerminalDisplay.h
        terminalWindow.width = 90 * terminalPage.terminal.fontMetrics.width + 2 + units.gu(2)
        terminalWindow.height = 24 * terminalPage.terminal.fontMetrics.height + 2 + units.gu(2) + units.gu(3)
        terminalWindow.narrowLayout = Qt.binding(function () {return terminalWindow.width <= units.gu(50)});

        if (sshRequired && !sshIsAvailable) {
            console.debug("Ask for confirmation")
            var proceed_dialog =
                PopupUtils.open( Qt.resolvedUrl( "ConfirmationDialog.qml" ),
                                 null,
                                 {'title': i18n.tr("No SSH server running."),
                                  'text': i18n.tr("SSH server not found. Do you want to proceed in confined mode?")});

            proceed_dialog.dialogCanceled.connect( Qt.quit );
            proceed_dialog.dialogAccepted.connect( function() {
                PopupUtils.close(proceed_dialog)
            })
        }
        terminalWindow.show()
    }
}
