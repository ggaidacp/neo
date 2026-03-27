import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"

Item {
	id: buttonFilterEW
    property string backgroundColor: Settings.blue80
    property string textColor:  Settings.blue80
	property string text
    property bool boxchecked : true
    property bool isClicked: true
    property string customtext: "abstract"
    signal clicked
    CheckBox  {
        id: customcheckbox
        width: 40
        height: 40
        anchors.centerIn: parent
        hoverEnabled: false
        checked: boxchecked
        Text {
            y:  6
            text: buttonFilterEW.customtext
            font.pointSize: Settings.isFullscreen ? 14 : 14
            font.family: Settings.defaultFont
            color: Settings.blue80
            anchors.left : parent.right
		}
        contentItem: Rectangle {
            color: "transparent" //customcheckbox.checked ? "#337A96" : "white"
            Rectangle {
                width: 24
                height: 24
                radius: 5
                color: "transparent" //customcheckbox.checked ? "#337A96" : "white"
                border.color: Settings.blue80
                anchors.centerIn: parent
            }
        }

        indicator:
            Item {
               width: 24
               height: 24
               y: 8
               x: 8
               Image {
                   width: parent.width
                   height: parent.height
                   anchors.centerIn: parent
                   source: boxchecked ? "qrc:/images/buttons/checked.png" : "qrc:/images/buttons/unchecked.png"  // Verwende unterschiedliche Bilder je nach Status
               }
        }

        MouseArea {
			id: button
			width: parent.width
			height: parent.height
			onClicked: {
                buttonFilterEW.isClicked = !buttonFilterEW.isClicked
                buttonFilterEW.clicked()
                customcheckbox.checked = !customcheckbox.checked
            }
        }
	}

}
