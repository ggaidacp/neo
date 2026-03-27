import QtQuick 2.15
import QtQuick.Controls 2.15

Item {

Row {
    id: searchRectangle
    width: parent.width
    height: parent.height / 2
    anchors.verticalCenter: parent.verticalCenter
    LayoutMirroring.enabled: true

    Image {
        id: buttonSearchIcon
        width: parent.width / 6
        height: parent.height
        source: searchField.visible ? "qrc:/images/buttons/search_gold.png" : "qrc:/images/buttons/search.png"
        mipmap: true
        fillMode: Image.PreserveAspectFit

        MouseArea {
            id: buttonSearch
            width: parent.width
            height: parent.height
        }
    }

    Rectangle {
        width: parent.width / 18
        height: parent.height
        color: "transparent"
    }

    NeoTextField {
        id: searchField
        visible: false
        width: (parent.width / 6) * 3
        height: parent.height / 1.1
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: 14
        background: Rectangle {
            width: parent.width
            height: parent.height
            color: "white"
            //opacity: 0.75
            border.color: "#8D8D8D"
            radius: 15
        }

        BusyIndicator {
            id: busyIndicator
            width: parent.width
            height: parent.height
            running: true
            visible: false
            anchors.centerIn: parent
        }
    }
}
}

