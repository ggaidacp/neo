import QtQuick 2.15
import QtQuick.Controls 2.15
import DVAGLogger 1.0
import "../settings"

Item {
	id: buttonFolderEW
    property string backgroundColor: isClicked ? Settings.blue80 : "white"
    property string textColor: Settings.blue80
	property string text
    property int yoffset: 7
    property int xoffset: 0
    property int textSize: Settings.isFullscreen ? 20 : 14
    property bool isClicked: true
    property bool boxchecked: true
	signal clicked

    CheckBox  {
        id: customcheckboxFolder
        x: xoffset
        width: 40
        height: 40
        anchors.centerIn: parent
        font.family: Settings.defaultFont
        font.pixelSize: textSize
        text: "abstract"
        hoverEnabled: false
        checked: boxchecked
        Text {
            y: yoffset
            x: xoffset
            text: buttonFolderEW.text
            font.pointSize: Settings.isFullscreen ? 14 : 14
            color: Settings.blue80
            anchors.left : parent.right
            wrapMode: Text.WordWrap
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
				buttonFolderEW.clicked()
               /* customcheckboxFolder.checked = !customcheckboxFolder.checked
                buttonFolderEW.boxchecked = !buttonFolderEW.boxchecked*/
                //DVAGLogger.log("checked = " + customcheckboxFolder.checked)
			}

		}
	}
}
