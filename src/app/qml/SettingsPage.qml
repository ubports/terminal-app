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
                Florian Boucault <florian.boucault@canonical.com>
 */

import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: settingsPage
    objectName: "settingsPage"

    header: PageHeader {
        title: i18n.tr("Preferences")
        flickable: scrollView.flickableItem
        StyleHints {
            backgroundColor: theme.palette.normal.overlay
        }
//        sections {
//            model: [i18n.tr("Interface")]
//        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        property real margins: units.gu(2)

        Item {
            // not a child of ScrollView, but it's reparented to
            // ScrollView.viewport. For that reason we can not use 'anchors'
            // but we have to set the width instead.
            width: scrollView.width
            height: childrenRect.height + 2 * scrollView.margins

        Column {
            anchors {
                right: parent.right
                left: parent.left
                top: parent.top
                margins: scrollView.margins
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
                            model: Qt.fontFamilies()
                            currentIndex: model.indexOf(settings.fontStyle)

                            Binding {
                                target: settings
                                property: "fontStyle"
                                value: fontStyleCombo.model[fontStyleCombo.currentIndex]
                            }
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
                            currentIndex: model.indexOf(settings.fontSize)

                            Binding {
                                target: settings
                                property: "fontSize"
                                value: fontSizeCombo.model[fontSizeCombo.currentIndex]
                            }
                        }
                    }
                }
            }

            SettingsCard {
                id: colorsCard

                title: i18n.tr("ANSI Colors")
                // TODO This is a workaround at the moment.
                // The application should get them from the c++.
                property var model: ["GreenOnBlack","WhiteOnBlack","BlackOnWhite","BlackOnRandomLight","Linux","cool-retro-term","DarkPastels","BlackOnLightYellow", "Ubuntu"]

                // TRANSLATORS: This is the name of a terminal color scheme which is displayed in the settings
                property var namesModel: [i18n.tr("Green on black"),i18n.tr("White on black"),i18n.tr("Black on white"),i18n.tr("Black on random light"),i18n.tr("Linux"),i18n.tr("Cool retro term"),i18n.tr("Dark pastels / Ubuntu (old)"),i18n.tr("Black on light yellow"),i18n.tr("Ubuntu")]

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
                    model: colorsCard.namesModel
                    currentIndex: colorsCard.model.indexOf(settings.colorScheme)

                    Binding {
                        target: settings
                        property: "colorScheme"
                        value: colorsCard.model[ansiColorPresetCombo.currentIndex]
                    }
                }
            }

            SettingsCard {
                id: layoutsCard
                visible: !QuickUtils.keyboardAttached
                title: i18n.tr("Layouts")

                MouseArea {
                    parent: layoutsCard
                    anchors.fill: parent
                    onClicked: pageStack.push(layoutsPage)
                }

                Icon {
                    parent: layoutsCard
                    anchors {
                        right: parent.right
                        rightMargin: layoutsCard.margins
                        verticalCenter: parent.verticalCenter
                    }

                    width: units.gu(2)
                    height: units.gu(4)
                    name: "go-next"
                    asynchronous: true
                }
            }
        }
        }
    }
}
