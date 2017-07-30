/*
 * Copyright (C) 2013, 2014, 2016 Canonical Ltd
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
 * Authored by: Filippo Scognamiglio <flscogna@gmail.com>
 */

import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: settingsPage
    objectName: "settingsPage"

    header: PageHeader {
        title: i18n.tr("Settings")
        flickable: scrollView.flickableItem
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent

        Column {
            // Column is not a child of ScrollView, but it's reparented to
            // ScrollView.viewport. For that reason we can not use 'anchors'
            // but we have to set the width instead.
            width: scrollView.width

            ListItem {
                ListItemLayout {
                    anchors.verticalCenter: parent.verticalCenter
                    title.text: i18n.tr("Layouts")

                    Icon {
                        SlotsLayout.position: SlotsLayout.Trailing
                        width: units.gu(2)
                        height: width
                        name: "go-next"
                    }
                }

                onClicked: pageStack.push(layoutsPage);
            }

            ListItem {
                height: units.gu(13)

                Label {
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: units.gu(2)
                    }
                    text: i18n.tr("Font Size:")
                }

                Slider {
                    id: slFont
                    objectName: "slFont"
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        margins: units.gu(2)
                    }
                    minimumValue: settings.minFontSize;
                    maximumValue: settings.maxFontSize;
                    onValueChanged: {
                        settings.fontSize = value;
                    }
                    Component.onCompleted: {
                        value = settings.fontSize;
                    }

                    Connections {
                        target: settings
                        onFontSizeChanged: {
                            slFont.value = settings.fontSize
                        }
                    }
                }
            }

            ListItem {
                ListItemLayout {
                    anchors.fill: parent
                    title.text: i18n.tr("Color Scheme")

                    Label {
                        SlotsLayout.position: SlotsLayout.Trailing
                        text: colorSchemePage.currentName
                    }

                    Icon {
                        SlotsLayout.position: SlotsLayout.Last
                        width: units.gu(2); height: width
                        name: "go-next"
                    }
                }

                onClicked: pageStack.push(colorSchemePage);
            }
              ListItem {
                ListItemLayout {
                    anchors.fill: parent
                    title.text: i18n.tr("Login")

                    Label {
                        SlotsLayout.position: SlotsLayout.Trailing
			function getstate() {
                                var state = "Required";
				if (settings.authReq)
		                state = i18n.tr("Required");
 		                else
                                state = i18n.tr("Not required");
                                return state;
				}
                        text: getstate()
                    }

                    Icon {
                        SlotsLayout.position: SlotsLayout.Last
                        width: units.gu(2); height: width
                        name: "go-next"
                    }
                }

                onClicked: pageStack.push(loginPage);
            }
        }
    }
}
