import QtQuick 2.15
import QtQuick.Controls 2.15
 
Item {
    visible: false
    width: parent.width
    height: parent.height

    id: welcomesplash
 
    Rectangle {
        width: parent.width
        height: parent.height
 
        Image {
            anchors.fill: parent
            source: "qrc:/images/welcomesplash.png"
        }
 
        MouseArea {
            anchors.fill: parent
            onClicked: {
                Qt.quit(); // Close the application when clicked
            }
        }
    }
}
