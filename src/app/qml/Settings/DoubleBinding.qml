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
 * Authored by: Florian Boucault <florian.boucault@canonical.com>
 */

import QtQuick 2.4

QtObject {
    id: doubleBinding

    property var source
    property string sourceProperty
    property var target
    property string targetProperty

    function sourceToTarget(sourceValue) {
        return sourceValue;
    }

    function targetToSource(targetValue) {
        return targetValue;
    }

    Component.onCompleted: {
        if (source && target && sourceProperty && targetProperty) {
            target[targetProperty] = sourceToTarget(source[sourceProperty]);
            targetBinding.when = true;
            sourceBinding.when = true;
        }
    }

    property var targetBinding: Binding {
        target: doubleBinding.target
        property: doubleBinding.targetProperty
        value: doubleBinding.sourceToTarget(doubleBinding.source[doubleBinding.sourceProperty])
        when: false
    }

    property var sourceBinding: Binding {
        target: doubleBinding.source
        property: doubleBinding.sourceProperty
        value: doubleBinding.targetToSource(doubleBinding.target[doubleBinding.targetProperty])
        when: false
    }
}
