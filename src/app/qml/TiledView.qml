/*
 * Copyright (C) 2016-2017 Canonical Ltd
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
import QtQuick 2.5
import "binarytree.js" as BinaryTree

FocusScope {
    id: tiledView

    property Component handleDelegate: Rectangle {
        implicitWidth: units.dp(1)
        implicitHeight: units.dp(1)
        color: "white"
    }

    property int count: 0

    // FIXME: odd semantics: what if setRootItem is called later?
    function setRootItem(rootItem) {
        if (rootItem && rootItem === __rootNode.value) {
            return null;
        }

        var oldRoot = __rootNode.value;
        if (rootItem) {
            count = 1;
        } else {
            count = 0;
            __rootNode.cleanup();
        }
        __rootNode.setValue(rootItem);

        return oldRoot;
    }

    property var __rootNode: new BinaryTree.Node()
    Component.onDestruction: __rootNode.cleanup()

    Component.onCompleted: {
        __rootNode.setWidth(width);
        __rootNode.setHeight(height);
    }

    onWidthChanged: __rootNode.setWidth(width)
    onHeightChanged: __rootNode.setHeight(height)

    Component {
        id: separatorComponent
        TiledViewSeparator {
            handleDelegate: tiledView.handleDelegate
        }
    }

    function add(obj, newObj, side) {
        var node = __rootNode.findNodeWithValue(obj);
        var otherSide;
        if (side == Qt.AlignLeading) {
            otherSide = Qt.AlignTrailing;
        } else {
            otherSide = Qt.AlignLeading;
        }

        node.value = null;
        node.setLeftRatio(0.5);
        var separator = separatorComponent.createObject(tiledView, {"node": node});
        node.setSeparator(separator);

        var nodeSide = new BinaryTree.Node();
        nodeSide.setValue(newObj);
        node.setChild(side, nodeSide);

        var nodeOtherSide = new BinaryTree.Node();
        nodeOtherSide.setValue(obj);
        node.setChild(otherSide, nodeOtherSide);
        count += 1;
    }

    function remove(obj) {
        var node = __rootNode.findNodeWithValue(obj);
        var sibling = node.getSibling();
        if (sibling) {
            node.parent.copy(sibling);
        }
        count -= 1;
    }

    function closestTile(obj) {
        var node = __rootNode.findNodeWithValue(obj);
        var sibling = node.closestNodeWithValue();
        if (sibling) {
            return sibling.value;
        } else {
            return null;
        }
    }

    function closestTileInDirection(obj, direction) {
        var node = __rootNode.findNodeWithValue(obj);
        var closestNode = node.closestNodeWithValueInDirection(direction);
        if (closestNode && closestNode.value) {
            return closestNode.value;
        } else {
            return null;
        }
    }

    function getOrientation(obj) {
        var node = __rootNode.findNodeWithValue(obj);
        return node.orientation;
    }

    function setOrientation(obj, orientation) {
        var node = __rootNode.findNodeWithValue(obj);
        node.setOrientation(orientation);
    }

    function move(obj, targetObj, side) {
        remove(obj);
        add(targetObj, obj, side);
    }
}
