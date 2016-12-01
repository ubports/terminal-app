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
            updateTarget();
            connectSourceChanges();
        }
    }

    function connectTargetChanges() {
        target[targetProperty+"Changed"].connect(updateSource);
    }

    function disconnectTargetChanges() {
        target[targetProperty+"Changed"].disconnect(updateSource);
    }

    function connectSourceChanges() {
        source[sourceProperty+"Changed"].connect(updateTarget);
    }

    function disconnectSourceChanges() {
        source[sourceProperty+"Changed"].disconnect(updateTarget);
    }

    function updateTarget() {
        disconnectTargetChanges();
        target[targetProperty] = sourceToTarget(source[sourceProperty]);
        connectTargetChanges();

    }

    function updateSource() {
        disconnectSourceChanges();
        source[sourceProperty] = targetToSource(target[targetProperty]);
        connectSourceChanges();
    }
}
