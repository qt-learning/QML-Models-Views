pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic
import QMLModelsViews_Section9

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Simple Tree View")

    Rectangle {
        anchors.fill: parent
        color: "lightgray"
    }

    TreeModel {
        id: treeModel
    }

    TreeView {
        id: treeView

        anchors.fill: parent
        editTriggers: TableView.DoubleTapped
        model: treeModel
        delegate: treeViewDelegateComponent

        selectionModel: ItemSelectionModel {}
    }

    Component {
        id: treeViewDelegateComponent

        TreeViewDelegate {
            id: treeViewDelegate

            //Defined by roleNames() in backend
            required property string displaying

            background: Rectangle {
                color: (treeViewDelegate.depth === 0) ? "lavender" :
                       (treeViewDelegate.depth === 1) ? "lightblue" :
                       (treeViewDelegate.depth === 2) ? "honeydew" : "white"
                border.width: treeViewDelegate.current ? 2 : 0
            }

            contentItem: Text {
                id: myTextEdit

                font.pixelSize: 15
                text: treeViewDelegate.displaying
                Keys.onReturnPressed: focus = false
            }

            TableView.editDelegate: TextField {
                required property int column
                required property int row

                anchors.fill: parent
                font.pixelSize: 15
                text: treeViewDelegate.displaying
                TableView.onCommit: {
                    let index = treeView.index(row, column)
                    treeModel.setData(index, text, "edition")
                }
            }

            onEditingChanged: treeView.width = myTextEdit.width
        }
    }
}
