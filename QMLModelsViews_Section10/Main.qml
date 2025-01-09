pragma ComponentBehavior: Bound
import QtQuick
import QtQml.Models

/*
Controls
    1: appends a new object to the end of the model
 */

Window {
    id: window

    width: 640
    height: 480
    visible: true
    title: qsTr("Simple Object Model")

    ObjectModel {
        id: itemModel

        CustomObject {objColor: "lightgray"; elementNum: 1}
        CustomObject {objColor: "lightgray"; elementNum: 2}
        CustomObject {objColor: "lightgray"; elementNum: 3}
    }

    ListView {
        anchors.fill: parent
        model: itemModel
        focus: true

        Keys.onDigit1Pressed: {
            var num  = itemModel.count + 1
            var component = Qt.createComponent("CustomObject.qml");
            model.append(component.createObject(parent, {objColor: "lightgray", elementNum: num}))
        }
    }
}
