// Copyright (C) 2026 Qt Group.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

pragma ComponentBehavior: Bound
import QtQuick

Item {
    id: root

    height: 30
    width: 640

    required property string objColor
    required property int elementNum

    Rectangle {
        anchors.fill: parent
        color: root.objColor
        border.width: 2

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true

            onEntered: {
                root.objColor = "lightblue"
            }

            onExited: {
                root.objColor = "lightgray"
            }

            onPressed: {
                root.objColor = "gray"
            }

            onReleased: {
                root.objColor = "lightblue"
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: "Element Number: " + root.elementNum
    }
}
