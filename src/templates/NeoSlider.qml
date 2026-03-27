import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"


Slider {
    id: neoSlider
    width: (parent.width / 12) * 3
    height: parent.height / 2
    from: 1
    to: 20
    value: 1
    stepSize: 0.5
    leftPadding: 0
    rightPadding: 0
    handle: Rectangle {
        x: neoSlider.leftPadding + neoSlider.visualPosition
           * (neoSlider.availableWidth - width)
        y: neoSlider.topPadding + neoSlider.availableHeight / 2 - height / 2
        implicitWidth: 10
        implicitHeight: 20
        color: "transparent"
        border.width: 0

        Image {
            id: handleImage
            source: "qrc:/images/whiteboard/slider-circle.png"  // Bild für den Griff
            width: 20
            height: 20
            y: 0  // Zentriere den Griff vertikal
        }
    }
    background: Rectangle {
        width: parent.width - 1
        height: 3
        color: "#DDDDDD"
        radius: 5
        anchors.centerIn: parent
        Rectangle {
            width: parent.width * (neoSlider.value / neoSlider.to) -1
            height: parent.height
            color: "#337A96"
            radius: parent.radius
        }
    }
    anchors.verticalCenter: parent.verticalCenter

}

