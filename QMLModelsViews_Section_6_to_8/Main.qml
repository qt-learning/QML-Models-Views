pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic
import Qt.labs.qmlmodels

/*
Controls
    Digit 1: Inserts a row above the current row
    Digit 2: Removes the current row
    Digit 3: Moves the current row to the top of the table
    Digit 4: Modifies the current row
    Digit 5: Clears the entire table
*/

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Simple Table Model")

    TableModel {
        id: contactsModel

        TableModelColumn { display: "firstName" }
        TableModelColumn { display: "lastName" }
        TableModelColumn { display: "age" }
        TableModelColumn { display: "phoneNumber" }

        rows: [
            {
                firstName: "John",
                lastName: "Doe",
                age: "49",
                phoneNumber: "111-111-1111"
            },
            {
                firstName: "Jane",
                lastName: "Doe",
                age: "48",
                phoneNumber: "222-222-2222"
            },
            {
                firstName: "George",
                lastName: "Doe",
                age: "12",
                phoneNumber: "333-333-3333"
            },
            {
                firstName: "Lily",
                lastName: "Doe",
                age: "10",
                phoneNumber: "444-444-4444"
            },
            {
                firstName: "Sarah",
                lastName: "Smith",
                age: "14",
                phoneNumber: "555-555-5555"
            }
        ]
    }

    ListModel {
        id: contactsHHeaderData

        ListElement{display: "First Name"}
        ListElement{display: "Last Name"}
        ListElement{display: "Age"}
        ListElement{display: "Phone Number"}
    }

    HorizontalHeaderView  {
        id: contactsHHeader

        anchors.left: scrollView.left
        anchors.top: parent.top
        syncView: contactsView
        model: contactsHHeaderData
        delegate: contactsHorizontalDelegate
        textRole: "display"
    }

    VerticalHeaderView  {
        id: contactsVHeader

        anchors.left: parent.left
        anchors.top: scrollView.top
        syncView: contactsView
        clip: true
    }

    ScrollView {
        id: scrollView

        anchors.left: contactsVHeader.right
        anchors.top: contactsHHeader.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true

        TableView {
            id: contactsView

            anchors.fill: parent
            columnSpacing: 1
            rowSpacing: 1
            editTriggers: TableView.DoubleTapped

            resizableColumns: true
            resizableRows: true

            model: contactsModel
            delegate: contactsDelegate

            selectionModel: ItemSelectionModel {
                model: contactsView.model
            }

            Keys.onDigit1Pressed: {
                if (currentRow >= 0) {
                    contactsView.model.insertRow(contactsView.currentRow, {"firstName": "Greg",
                                                  "lastName": "Doe",
                                                  "age": 100,
                                                  "phoneNumber":  "123-456-7890"})
                }
            }

            Keys.onDigit2Pressed: {
                if (currentRow >= 0) {
                    contactsView.model.removeRow(contactsView.currentRow)
                }
            }

            Keys.onDigit3Pressed: {
                if (currentRow >= 1) {
                    contactsView.model.moveRow(contactsView.currentRow, 0)
                }
            }

            Keys.onDigit4Pressed: {
                if (currentRow >= 0) {
                    contactsView.model.setRow(contactsView.currentRow, {"firstName": "Sam",
                                                   "lastName": "Smith",
                                                   "age": 50,
                                                   "phoneNumber":  "098-765-4321"})
                }
            }

            Keys.onDigit5Pressed: {
                contactsView.model.clear()
            }
        }
    }

    Component {
        id: contactsDelegate

        Rectangle {
            id: delegateRect

            required property bool current
            required property string display

            implicitWidth: 100
            implicitHeight: 50
            color: current ? "pink" : "lightgray"
            border.width: current ? 2 : 0
            TableView.editDelegate: contactsEditDelegate

            Text {
                id: delegateText

                text: delegateRect.display
                padding: 12
                anchors.fill: parent
            }
        }
    }

    Component {
        id: contactsHorizontalDelegate

        Text {
            id: delegateText

            required property string display

            padding: 12
            text: display

            Rectangle {
                anchors.fill: parent
                color: "gray"
                z: -1
            }
        }
    }

    Component {
        id: contactsEditDelegate

        TextField {
            id: delegateTextField

            required property int column
            required property int row
            required property string display

            anchors.fill: parent
            text: display

            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter

            TableView.onCommit: {
                let index = TableView.view.index(row, column)
                contactsModel.setData(index, "display", text)
            }
        }
    }
}
