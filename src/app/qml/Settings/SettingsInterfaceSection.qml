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
import Terminal 0.1
import QMLTermWidget 1.0

SettingsSection {
    id: section

    windowColor: theme.palette.selected.overlay
    flickableItem: scrollView.flickableItem

    ScrollView {
        id: scrollView
        anchors.fill: parent

        Item {
            // not a child of ScrollView, but it's reparented to
            // ScrollView.viewport. For that reason we can not use 'anchors'
            // but we have to set the width instead.
            width: section.width
            height: childrenRect.height + 2 * section.margins

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

                    title: i18n.tr("Colors")

                    // TODO This is a workaround at the moment.
                    // The application should get them from the c++.
                    property var model: [
                        {"name": i18n.tr("Ubuntu"),                "value": "Ubuntu"},
                        {"name": i18n.tr("Green on black"),        "value": "GreenOnBlack"},
                        {"name": i18n.tr("White on black"),        "value": "WhiteOnBlack"},
                        {"name": i18n.tr("Black on white"),        "value": "BlackOnWhite"},
                        {"name": i18n.tr("Black on random light"), "value": "BlackOnRandomLight"},
                        {"name": i18n.tr("Linux"),                 "value": "Linux"},
                        {"name": i18n.tr("Cool retro term"),       "value": "cool-retro-term"},
                        {"name": i18n.tr("Dark pastels"),          "value": "DarkPastels"},
                        {"name": i18n.tr("Black on light yellow"), "value": "BlackOnLightYellow"},
                        {"name": i18n.tr("Customized"),            "value": terminalAppRoot.customizedSchemeName},
                    ]

                    property var currentScheme: ColorSchemeManager.findColorScheme(settings.colorScheme)

                    Column {
                        spacing: units.gu(2)

                        Row {
                            ColorRow {
                                width: units.gu(16)
                                title: i18n.tr("Background:")
                                colorScheme: colorsCard.currentScheme
                                start: 1
                                count: 1
                            }

                            ColorRow {
                                width: units.gu(16)
                                title: i18n.tr("Text:")
                                colorScheme: colorsCard.currentScheme
                                start: 0
                                count: 1
                            }
                        }

                        BackgroundOpacityEditor {
                            colorScheme: colorsCard.currentScheme
                        }

                        ColorRow {
                            title: i18n.tr("Normal palette:")
                            colorScheme: colorsCard.currentScheme
                            start: 2
                            count: 8
                        }

                        ColorRow {
                            title: i18n.tr("Bright palette:")
                            colorScheme: colorsCard.currentScheme
                            start: 12
                            count: 8
                        }

                        Column {
                            spacing: units.gu(1)
                            Label {
                                text: i18n.tr("Preset:")
                            }

                            ComboBox {
                                model: colorsCard.model
                                bindingTarget: settings
                                bindingProperty: "colorScheme"
                                textRole: "name"
                                valueRole: "value"
                            }
                        }
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
    }
}
