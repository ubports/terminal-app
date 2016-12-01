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
import QtQuick.Layouts 1.3
import Ubuntu.Components 1.3

MouseArea {
    id: colorComponentSlider

    property string label
    property alias value: slider.value
    property int minimumValue: 0
    property int maximumValue: 255

    function setValue(newValue) {
        value = Math.min(maximumValue, Math.max(newValue, minimumValue));
    }

    height: row.height

    onWheel: {
        if (wheel.angleDelta.y >= 0) {
            setValue(value+1);
        } else {
            setValue(value-1);
        }
    }

    RowLayout {
        id: row
        spacing: units.gu(2)
        anchors {
            left: parent.left
            right: parent.right
        }

        Label {
            text: colorComponentSlider.label
            textSize: Label.Large
        }

        Slider {
            id: slider
            Layout.fillWidth: true
            minimumValue: colorComponentSlider.minimumValue
            maximumValue: colorComponentSlider.maximumValue
            stepSize: 1
            live: true
            function formatValue(v) {
                return "";
            }
        }

        TextFieldStyled {
            id: textField
            implicitWidth: units.gu(6)
            hasClearButton: false
            horizontalAlignment: TextInput.AlignHCenter
            validator: IntValidator {
                bottom: colorComponentSlider.minimumValue
                top: colorComponentSlider.maximumValue
            }
            inputMethodHints: Qt.ImhDigitsOnly
            Keys.onUpPressed: setValue(value+1)
            Keys.onDownPressed: setValue(value-1)
        }


        DoubleBinding {
            source: slider
            target: textField
            sourceProperty: "value"
            targetProperty: "text"
            function sourceToTarget(sourceValue) {
                return Math.round(sourceValue);
            }
        }

    }
}
