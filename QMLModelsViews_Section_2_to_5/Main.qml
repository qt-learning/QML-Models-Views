pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic

/*
Controls
    Arrow keys: move the current element up and down
    Escape: de-selects the current element
    Delete: deletes the current element
    Tab: inserts a copy of the current element
    Space: sets the current element to "Greg Doe"
    1: opens popup to insert a new entry
    2: deletes entire model
 */

Window {
    id: window

    width: 640
    height: 480
    visible: true
    title: qsTr("Contacts ModelView")

    ListModel {
        id: contactsModel

        ListElement{
            firstName: "John"
            lastName: "Doe"
            age: 49
            phoneNumber: "111-111-1111"
        }

        ListElement{
            firstName: "Jane"
            lastName: "Doe"
            age: 48
            phoneNumber: "222-222-2222"
        }

        ListElement{
            firstName: "George"
            lastName: "Doe"
            age: 12
            phoneNumber: "333-333-3333"
        }

        ListElement{
            firstName: "Lily"
            lastName: "Doe"
            age: 10
            phoneNumber: "444-444-4444"
        }

        ListElement{
            firstName: "Sarah"
            lastName: "Smith"
            age: 14
            phoneNumber: "555-555-5555"
        }

        ListElement{
            firstName: "Bob"
            lastName: "Smith"
            age: 45
            phoneNumber: "666-666-6666"
        }

        ListElement{
            firstName: "Julia"
            lastName: "Smith"
            age: 51
            phoneNumber: "777-777-7777"
        }

        ListElement{
            firstName: "Jose"
            lastName: "Wolf"
            age: 38
            phoneNumber: "888-888-8888"
        }

        ListElement{
            firstName: "Joe"
            lastName: "Wolf"
            age: 35
            phoneNumber: "999-999-9999"
        }
    }

    ListView {
        id: contactsView

        anchors.fill: parent

        delegate: contactsDelegate
        model: contactsModel
        header: contactsHeader
        footer: contactsFooter

        orientation: ListView.Vertical

        section.delegate:contactsSection
        section.criteria: ViewSection.FullString
        section.labelPositioning: ViewSection.InlineLabels
        section.property: "lastName"

        highlightFollowsCurrentItem: true
        highlight: contactsHighlight
        highlightMoveDuration: 1
        highlightResizeDuration: 1
        focus: true

        displaced: displacedTransition
        add: addTransition
        remove: removeTransition
        move: moveTransition

        Keys.onDeletePressed: {
            if (contactsView.currentIndex < 0) {
                console.log("Must select an element to delete an entry")
            } else {
                contactsView.model.remove(contactsView.currentIndex)
            }

        }

        Keys.onEscapePressed: {
            contactsView.currentIndex = -1
        }

        Keys.onSpacePressed: {
            if (contactsView.currentIndex < 0) {
                console.log("Must select an element to modify an entry")
            } else {
                contactsView.model.set(contactsView.currentIndex,
                                       {"firstName": "Greg",
                                           "lastName": "Doe",
                                           "age": 100,
                                           "phoneNumber":  "123-456-7890"})
            }
        }

        Keys.onDigit1Pressed: {
            newValuePopup.open()

        }

        Keys.onDigit2Pressed: {
            contactsView.model.clear()
        }


        Keys.onUpPressed: {
            if (contactsView.model.count <= 1) {
                console.log("Not enough elements in model to move an element")
            } else {
                contactsView.model.move(contactsView.currentIndex, contactsView.currentIndex-1,1)
            }
        }

        Keys.onDownPressed: {
            if (contactsView.model.count <= 1) {
                console.log("Not enough elements in model to move an element")
            } else {
                contactsView.model.move(contactsView.currentIndex, contactsView.currentIndex+1,1)
            }
        }

        Popup {
            id: newValuePopup

            height: 250
            width: 200
            anchors.centerIn: parent

            Column {
                anchors.centerIn: parent
                spacing: 5

                TextField {
                    id: firstNameField

                    font.pointSize: 10
                    placeholderText: "Enter first name"
                    width: 150
                    height: 30
                }

                TextField {
                    id: lastNameField

                    font.pointSize: 10
                    placeholderText: "Enter last name"
                    width: 150
                    height: 30
                }

                TextField {
                    id: ageField

                    font.pointSize: 10
                    placeholderText: "Enter age"
                    width: 150
                    height: 30
                    validator: IntValidator{}
                }

                TextField {
                    id: phoneField

                    font.pointSize: 10
                    placeholderText: "Enter phone number"
                    width: 150
                    height: 30
                    validator: RegularExpressionValidator{regularExpression: /^\d{3}-\d{3}-\d{4}$/}
                }

                Button {
                    height: 25
                    width: firstNameField.width
                    text: "Append"
                    anchors.horizontalCenter: parent.horizontalCenter
                    enabled: ((firstNameField.text !== "") && (lastNameField.text !== "") && (ageField.text !== "") && (phoneField.text !== ""))

                    onClicked: {
                        contactsView.model.append(
                            {"firstName": firstNameField.text,
                                "lastName": lastNameField.text,
                                "age": parseInt(ageField.text),
                                "phoneNumber": phoneField.text})
                        newValuePopup.close()
                        firstNameField.text = ""
                        lastNameField.text = ""
                        ageField.text = ""
                        phoneField.text = ""
                        contactsView.focus = true
                    }
                }
            }
        }
    }

    Component {
        id: contactsDelegate

        Rectangle {
            id: delegateRect

            required property string firstName
            required property string lastName
            required property int age
            required property string phoneNumber
            required property int index
            property ItemView listView: ListView.view

            height: 50
            width: parent ? parent.width : 0
            border.color: "black"

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 5
                text: "Name: %1 %2 \nAge: %3 \nPhone: %4"
                .arg(delegateRect.firstName).arg(delegateRect.lastName)
                .arg(delegateRect.age).arg(delegateRect.phoneNumber)
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onReleased: {
                    delegateRect.listView.currentIndex = delegateRect.index
                    delegateRect.color = "white"
                }

                onPressed: {
                    delegateRect.color = "gray"
                }

                onEntered: {
                    delegateRect.color = "lightgray"
                }

                onExited: {
                    delegateRect.color = "white"
                }
            }

            Keys.onTabPressed: {
                if (contactsView.currentIndex < 0) {
                    console.log("Must select an element to insert a new entry")
                } else {
                    listView.model.insert(contactsView.currentIndex,
                                          {"firstName": delegateRect.firstName,
                                              "lastName": delegateRect.lastName,
                                              "age": delegateRect.age,
                                              "phoneNumber": delegateRect.phoneNumber})
                }
            }
        }
    }

    Component {
        id: contactsHeader

        Rectangle {
            id: headerRect

            height: 35
            width: parent.width
            border.color: "black"
            color: "mistyrose"
            z: 2

            Text {
                anchors.centerIn: parent
                text: "Contacts List"
                font.pointSize: 18
            }
        }
    }

    Component {
        id: contactsFooter

        Rectangle {
            id: footerRect

            height: 20
            width: parent.width
            border.color: "black"
            color: "mistyrose"
        }
    }

    Component {
        id: contactsHighlight

        Rectangle {
            id: highlightRect

            border.color: "black"
            color: "yellow"
            opacity: 0.15
            z: 2
        }
    }

    Component {
        id: contactsSection

        Rectangle {
            id: sectionRect

            required property string section

            height: 30
            width: parent.width
            border.color: "black"
            color: "lightblue"

            Text {
                anchors.centerIn: parent
                text: sectionRect.section + " Family"
                font.bold: true
                font.pointSize: 12
            }
        }
    }

    Transition {
        id: displacedTransition

        NumberAnimation {
            properties: "x,y"
            duration: 300
        }
    }

    Transition {
        id: addTransition

        NumberAnimation {
            property: "opacity"
            from: 0
            to: 1.0
            duration: 300
        }

        NumberAnimation {
            property: "scale"
            from: 0
            to: 1.0
            duration: 300
        }
    }

    Transition {
        id: moveTransition

        NumberAnimation {
            properties: "x,y"
            duration: 300
        }
    }

    Transition {
        id: removeTransition

        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0
            duration: 300
        }

        NumberAnimation {
            property: "scale"
            from: 1.0
            to: 0
            duration: 300
        }
    }
}
