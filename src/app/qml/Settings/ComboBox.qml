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
 * Authored-by: Florian Boucault <florian.boucault@canonical.com>
 */
import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

MouseArea {
    id: comboBox

    property var model
    property int currentIndex: 0
    property var bindingTarget
    property string bindingProperty
    readonly property var currentItem: model.get ? model.get(currentIndex)
                                                 : model[currentIndex]
    readonly property string currentText: textRole ? currentItem[textRole] : currentItem
    property string textRole
    property string valueRole

    implicitWidth: units.gu(21)
    implicitHeight: units.gu(4)

    DoubleBinding {
        source: bindingTarget
        sourceProperty: bindingProperty
        target: comboBox
        targetProperty: "currentIndex"

        function listModelIndexOf(listModel, value, role) {
            for (var i = 0; i < listModel.count; i++) {
                if (listModel.get(i)[role] === value) {
                    return i;
                }
            }
            return -1;
        }

        function jsListIndexOf(listModel, value, role) {
            if (role == "") {
                return listModel.indexOf(value);
            }

            for (var i = 0; i < listModel.length; i++) {
                if (listModel[i][role] === value) {
                    return i;
                }
            }
            return -1;
        }

        function sourceToTarget(sourceValue) {
            return comboBox.model.get ? listModelIndexOf(comboBox.model, sourceValue, comboBox.valueRole)
                                      : jsListIndexOf(comboBox.model, sourceValue, comboBox.valueRole);
        }
        function targetToSource(currentIndex) {
            return comboBox.valueRole ? comboBox.currentItem[comboBox.valueRole] : comboBox.currentItem;
        }
    }

    Rectangle {
        anchors.fill: parent

        color: theme.palette.normal.field
        border.color: theme.palette.normal.base
        border.width: units.dp(1)
        radius: units.dp(3)

        Icon {
            anchors {
                right: parent.right
                rightMargin: units.gu(2)
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: -units.gu(0.5)
            }

            width: units.gu(1)
            height: units.gu(1)
            asynchronous: true
            name: "up"
        }

        Icon {
            anchors {
                right: parent.right
                rightMargin: units.gu(2)
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: units.gu(0.5)
            }

            width: units.gu(1)
            height: units.gu(1)
            asynchronous: true
            name: "down"
        }
    }

    Label {
        id: currentLabel
        anchors {
            fill: parent
            leftMargin: units.gu(2)
            rightMargin: units.gu(5)
        }

        text: comboBox.currentText
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
        color: theme.palette.normal.overlayText
    }

    Binding {
        target: currentLabel
        property: "font.family"
        value: comboBox.fontFamilyFromModel ? comboBox.fontFamilyFromModel(comboBox.currentText) : undefined
        when: typeof comboBox.fontFamilyFromModel !== "undefined"
    }

    onWheel: {
        var count = comboBox.model.length ? comboBox.model.length :
                    comboBox.model.count ? comboBox.model.count : Infinity
        if (wheel.angleDelta.y > 0 && comboBox.currentIndex > 0) {
            comboBox.currentIndex--;
        } else if (wheel.angleDelta.y < 0 && comboBox.currentIndex < count - 1) {
            comboBox.currentIndex++;
        }
    }

    preventStealing: true
    onPressed: {
        var properties = {
            "model": comboBox.model,
            "itemHeight": comboBox.height,
            "itemMargins": currentLabel.anchors.leftMargin,
            "contentWidth": comboBox.width,
            "comboBox": comboBox,
            "textRole": comboBox.textRole
        }

        PopupUtils.open(Qt.resolvedUrl("ComboBoxPopup.qml"), comboBox, properties);
    }
}
