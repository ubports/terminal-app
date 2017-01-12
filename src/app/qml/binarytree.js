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
.pragma library

function Node() {
    this.value = null;
    this.parent = null;
    this.left = null;
    this.right = null;
    this.separator = null;
    this.leftRatio = 0.5;
    this.rightRatio = 0.5;
    this.orientation = Qt.Horizontal;
    this.originX = 0;
    this.originY = 0;
    this.x = 0;
    this.y = 0;
    this.width = 0;
    this.height = 0;
}

Node.prototype.cleanup = function cleanup(value) {
    if (this.separator) {
        this.separator.destroy();
        this.separator = null;
    }
    this.parent = null;
    this.value = null;
    if (this.left) {
        this.left.cleanup();
        this.left = null;
    }
    if (this.right) {
        this.right.cleanup();
        this.right = null;
    }
}

Node.prototype.setValue = function setValue(value) {
    this.value = value;
    this.updateX();
    this.updateY();
    this.updateWidth();
    this.updateHeight();
}

Node.prototype.updateWidth = function updateWidth() {
    if (this.value) {
        this.value.width = this.width;
    } else if (this.orientation == Qt.Horizontal) {
        if (this.right && !this.left) {
            this.right.setWidth(this.width);
            this.right.setX(0);
        }
        if (this.left && !this.right) {
            this.left.setWidth(this.width);
            this.left.setX(0);
        }
        if (this.right && this.left) {
            this.left.setWidth(this.width * this.leftRatio);
            this.left.setX(0);
            this.right.setWidth(this.width * this.rightRatio);
            this.right.setX(this.left.width);
        }
    } else if (this.orientation == Qt.Vertical) {
        if (this.left) {
            this.left.setWidth(this.width);
            this.left.setX(0);
        }
        if (this.right) {
            this.right.setWidth(this.width);
            this.right.setX(0);
        }
    }
    this.updateSeparator();
}

Node.prototype.setWidth = function setWidth(width) {
    this.width = width;
    this.updateWidth();
};

Node.prototype.updateHeight = function updateHeight() {
    if (this.value) {
        this.value.height = this.height;
    } else if (this.orientation == Qt.Vertical) {
        if (this.right && !this.left) {
            this.right.setHeight(this.height);
            this.right.setY(0);
        }
        if (this.left && !this.right) {
            this.left.setHeight(this.height);
            this.left.setY(0);
        }
        if (this.right && this.left) {
            this.left.setHeight(this.height * this.leftRatio);
            this.left.setY(0);
            this.right.setHeight(this.height * this.rightRatio);
            this.right.setY(this.left.height);
        }
    } else if (this.orientation == Qt.Horizontal) {
        if (this.left) {
            this.left.setHeight(this.height);
            this.left.setY(0);
        }
        if (this.right) {
            this.right.setHeight(this.height);
            this.right.setY(0);
        }
    }
    this.updateSeparator();
}

Node.prototype.setHeight = function setHeight(height) {
    this.height = height;
    this.updateHeight();
};

Node.prototype.setLeftRatio = function setLeftRatio(ratio) {
    this.leftRatio = ratio;
    this.rightRatio = 1.0 - this.leftRatio;
    if (this.orientation == Qt.Horizontal) {
        this.updateWidth();
    } else {
        this.updateHeight();
    }
};

Node.prototype.setRightRatio = function setRightRatio(ratio) {
    this.rightRatio = ratio;
    this.leftRatio = 1.0 - this.rightRatio;
    if (this.orientation == Qt.Horizontal) {
        this.updateWidth();
    } else {
        this.updateHeight();
    }
};

Node.prototype.setChild = function setChild(side, childNode) {
    switch (side) {
        case Qt.AlignLeading:
            if (this.left) {
                // FIXME: breaks copy()
//                this.left.cleanup();
            }
            this.left = childNode;
            break;
        case Qt.AlignTrailing:
            if (this.right) {
                // FIXME: breaks copy()
//                this.right.cleanup();
            }
            this.right = childNode;
            break;
        default:
            break;
    }
    if (childNode) {
        childNode.parent = this;
    }
    this.updateX();
    this.updateY();
    this.updateWidth();
    this.updateHeight();
}

Node.prototype.updateSeparator = function updateSeparator() {
    if (this.separator) {
        this.separator.orientation = this.orientation == Qt.Vertical ? Qt.Horizontal : Qt.Vertical;
        if (this.left && this.right) {
            // FIXME: separator should be centered
            this.separator.x = this.right.originX + this.right.x;
            this.separator.y = this.right.originY + this.right.y;
            if (this.separator.orientation == Qt.Vertical) {
                this.separator.width = this.separator.implicitWidth;
                this.separator.height = this.right.height;
            } else if (this.separator.orientation == Qt.Horizontal) {
                this.separator.width = this.right.width;
                this.separator.height = this.separator.implicitHeight;
            }
            this.separator.visible = true;
        } else {
            this.separator.visible = false;
        }
    }
}

Node.prototype.setSeparator = function setSeparator(separator) {
    this.separator = separator;
    this.updateSeparator();
}

Node.prototype.copy = function copy(otherNode) {
    if (!otherNode) return;
    var newParent = otherNode.parent;

    this.orientation = otherNode.orientation;
    this.setValue(otherNode.value);
    this.setChild(Qt.AlignLeading, otherNode.left);
    this.setChild(Qt.AlignTrailing, otherNode.right);

    if (newParent.left === otherNode) {
        newParent.setChild(Qt.AlignLeading, this);
    } else if (otherNode.parent.right === otherNode) {
        newParent.setChild(Qt.AlignTrailing, this);
    }
    otherNode.left = null;
    otherNode.right = null;
    otherNode.cleanup();
    this.updateX();
    this.updateY();
    this.updateWidth();
    this.updateHeight();
}

Node.prototype.setOrientation = function setOrientation(orientation) {
    this.orientation = orientation;
    this.updateWidth();
    this.updateHeight();
    this.updateSeparator();
}

Node.prototype.updateX = function updateX() {
    var absoluteX = this.originX + this.x;
    if (this.value) {
        this.value.x = Math.round(absoluteX);
    } else {
        if (this.left) {
            this.left.setOriginX(absoluteX);
        }
        if (this.right) {
            this.right.setOriginX(absoluteX);
        }
    }
    this.updateSeparator();
}

Node.prototype.setX = function setX(x) {
    this.x = x;
    this.updateX();
};

Node.prototype.setOriginX = function setOriginX(x) {
    this.originX = x;
    this.updateX();
};

Node.prototype.updateY = function updateY() {
    var absoluteY = this.originY + this.y;
    if (this.value) {
        this.value.y = Math.round(absoluteY);
    } else {
        if (this.left) {
            this.left.setOriginY(absoluteY);
        }
        if (this.right) {
            this.right.setOriginY(absoluteY);
        }
    }
    this.updateSeparator();
}

Node.prototype.setY = function setY(y) {
    this.y = y;
    this.updateY();
};

Node.prototype.setOriginY = function setOriginY(y) {
    this.originY = y;
    this.updateY();
};

Node.prototype.getSibling = function getSibling() {
    if (this.parent) {
        if (this.parent.left === this) {
            return this.parent.right;
        } else {
            return this.parent.left;
        }
    }
    return null;
}

Node.prototype.findNodeWithValue = function findNodeWithValue(value) {
    if (this.value === value) return this;
    var result;
    if (this.left) {
        result = this.left.findNodeWithValue(value);
        if (result) {
            return result;
        }
    }
    if (this.right) {
        result = this.right.findNodeWithValue(value);
        if (result) {
            return result;
        }
    }
    return null;
};

Node.prototype.closestChildWithValue = function closestChildWithValue(sides) {
    var currentLevelNodes = [this];
    var nextLevelNodes = [];
    while (currentLevelNodes.length != 0) {
        for (var i=0; i<currentLevelNodes.length; i++) {
            var node = currentLevelNodes[i];
            if (node.value) {
                return node;
            }
            if ((sides == undefined || sides & Qt.AlignLeading) && node.left) {
                nextLevelNodes.push(node.left);
            }
            if ((sides == undefined || sides & Qt.AlignTrailing) && node.right) {
                nextLevelNodes.push(node.right);
            }
        }
        currentLevelNodes = nextLevelNodes;
        nextLevelNodes = [];
    }
    return null;
}

Node.prototype.closestNodeWithValue = function closestNodeWithValue() {
    // explore sibling hierarchy
    var sibling = this.getSibling();
    if (sibling) {
        var closestChild = sibling.closestChildWithValue(Qt.AlignLeading | Qt.AlignTrailing);
        if (closestChild) {
            return closestChild;
        }
    }
    // explore parent's sibling hierarchy
    if (this.parent) {
        var parentSibling = this.parent.getSibling();
        if (parentSibling) {
            var closestChild = parentSibling.closestChildWithValue(Qt.AlignLeading | Qt.AlignTrailing);
            if (closestChild) {
                return closestChild;
            }
        }
    }
    return null;
};

Node.prototype.closestNodeWithValueInDirection = function closestNodeWithValueInDirection(direction) {
    if (this.parent) {
        if (this.parent.left === this) {
            if ((direction == Qt.AlignRight && this.parent.orientation == Qt.Horizontal) ||
                (direction == Qt.AlignBottom && this.parent.orientation == Qt.Vertical)) {
                return this.parent.right.closestChildWithValue(Qt.AlignLeading);
            }
        } else if (this.parent.right === this) {
            if ((direction == Qt.AlignLeft && this.parent.orientation == Qt.Horizontal) ||
                (direction == Qt.AlignTop && this.parent.orientation == Qt.Vertical)) {
                return this.parent.left.closestChildWithValue(Qt.AlignTrailing);
            }
        }
        return this.parent.closestNodeWithValueInDirection(direction);
    } else {
        return null;
    }
}
