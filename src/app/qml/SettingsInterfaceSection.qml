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
 * Authored by: Florian Boucault <florian.boucault@canonical.com>
 */

import QtQuick 2.4
import QtQuick.Layouts 1.3
import Ubuntu.Components 1.3

SettingsSection {
    id: section
    Column {
        anchors {
            right: parent.right
            left: parent.left
            top: parent.top
            margins: section.margins
        }

        spacing: units.gu(1)

        SettingsCard {
            id: textCard

            title: i18n.tr("Text")

            Row {
                spacing: units.gu(2)

                Item {
                    width: childrenRect.width
                    height: childrenRect.height

                    Label {
                        id: fontStyleLabel
                        text: i18n.tr("Font:")
                    }

                    ComboBox {
                        id: fontStyleCombo
                        anchors {
                            top: fontStyleLabel.bottom
                            topMargin: units.gu(1)
                        }

                        function fontFamilyFromModel(model) {
                            return model;
                        }
                        model: Fonts.monospaceFamilies
                        bindingTarget: settings
                        bindingProperty: "fontStyle"
                    }
                }

                Item {
                    width: childrenRect.width
                    height: childrenRect.height

                    Label {
                        id: fontSizeLabel
                        text: i18n.tr("Font Size:")
                    }

                    ComboBox {
                        id: fontSizeCombo
                        anchors {
                            top: fontSizeLabel.bottom
                            topMargin: units.gu(1)
                        }
                        width: units.gu(9)
                        function arrayOfNumbers(min, max) {
                            var list = [];
                            for (var i = min; i <= max; i++) {
                                list.push(i);
                            }
                            return list;
                        }
                        model: arrayOfNumbers(settings.minFontSize, settings.maxFontSize)
                        bindingTarget: settings
                        bindingProperty: "fontSize"
                    }
                }
            }
        }

        SettingsCard {
            id: colorsCard

            title: i18n.tr("ANSI Colors")

            // TODO This is a workaround at the moment.
            // The application should get them from the c++.
            property ListModel model: ListModel {
                ListElement { name: "Ubuntu"; value: "Ubuntu" }
                ListElement { name: "Green on black"; value: "GreenOnBlack" }
                ListElement { name: "White on black"; value: "WhiteOnBlack" }
                ListElement { name: "Black on white"; value: "BlackOnWhite" }
                ListElement { name: "Black on random light"; value: "BlackOnRandomLight" }
                ListElement { name: "Linux"; value: "Linux" }
                ListElement { name: "Cool retro term"; value: "cool-retro-term" }
                ListElement { name: "Dark pastels"; value: "DarkPastels" }
                ListElement { name: "Black on light yellow"; value: "BlackOnLightYellow" }
            }

            Label {
                id: ansiColorPresetLabel
                text: i18n.tr("Preset:")
            }

            ComboBox {
                id: ansiColorPresetCombo
                anchors {
                    top: ansiColorPresetLabel.bottom
                    topMargin: units.gu(1)
                }
                model: colorsCard.model
                bindingTarget: settings
                bindingProperty: "colorScheme"
                textRole: "name"
                valueRole: "value"
            }
        }

        SettingsCard {
            id: layoutsCard
            visible: !QuickUtils.keyboardAttached
            title: i18n.tr("Layouts")

            Column {
                width: Math.min(parent.width, units.gu(32))

                Repeater {
                    model: settings.profilesList
                    delegate: RowLayout {
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                        height: units.gu(5)

                        Label {
                            text: name
                            Layout.fillWidth: true
                        }

                        Switch {
                            checked: profileVisible
                            property bool completed: false
                            onCheckedChanged: {
                                settings.profilesList.setProperty(index, "profileVisible", checked);
                                if (completed) settings.profilesChanged();
                            }
                            Component.onCompleted: completed = true
                        }
                    }
                }
            }
        }
    }
}
