import QtQuick 2.15
import QtQuick.Controls 2.15
import DVAGLogger 1.0
import "../settings"

Item {
	id: buttonEW
	width: (parent.width / 15) * 3
	height: parent.height / 2


    property string backgroundColor: "white" //337A96
    property string textColor: Settings.blue80
	property string text
    property string source : ""
	property int textSize: Settings.isFullscreen ? 20 : 15
    property alias pressed: button.isPressed


	signal clicked

	Rectangle {
		width: parent.width
		height: parent.height
		color: buttonEW.backgroundColor
        border.color: Settings.blue80
        border.width: 2
        radius: 5
        anchors.centerIn: parent


		Text {
			text: buttonEW.text
			font.pointSize: buttonEW.textSize
            font.family: Settings.defaultFont
			color: buttonEW.textColor
			anchors.centerIn: parent
            Image {
                id: buttonEWImage
                source: source
            }
		}

		MouseArea {
			id: button
			width: parent.width
			height: parent.height
            property bool isPressed: false
            hoverEnabled: false

			onClicked: {
				buttonEW.clicked()
			}
			onPressed: {
                isPressed = true
                if (buttonEW.backgroundColor === Settings.blue80) {
					buttonEW.backgroundColor = "white"
                    buttonEW.textColor = Settings.blue80
				} else {
                    buttonEW.backgroundColor = Settings.blue80
					buttonEW.textColor = "white"
				}
			}
			onReleased: {
                isPressed = false
                if (buttonEW.backgroundColor === Settings.blue80) {
					buttonEW.backgroundColor = "white"
                    buttonEW.textColor = Settings.blue80
				} else {
                    buttonEW.backgroundColor = Settings.blue80
					buttonEW.textColor = "white"
				}
			}
		}
	}
}
