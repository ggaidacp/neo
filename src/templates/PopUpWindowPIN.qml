import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 5.9

import "../settings"


PopUpWindow {
	id: popUpWindowPIN

    //headerText: ""

	width: Settings.embeddedWindowWidth / 3
	height: Settings.embeddedWindowHeight / 4

	property string inputValue: minutesInput.text
    property string version:  AppInfo.version //"Version: NEO" + " 2.2.0.0"

	signal buttonQuitClicked
	signal buttonCancelClicked


	Column {
		width: parent.width
		height: parent.height


		Rectangle {
			width: parent.width
            height: (parent.height / 10) * 10
            color: "transparent"


			Column {
				width: parent.width
				height: parent.height
                spacing: 10
                padding: 10
                //anchors.centerIn: parent
                // Message in Caption
				Text {
					id: popUpText
					width: (parent.width / 5) * 4
					height: (parent.height / 3) * 1
					text: "Geben Sie die PIN ein um die Anwendung zu beenden:"
					font.pointSize: 15
					color: "black"
					wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    //anchors.horizontalCenter: parent.horizontalCenter
				}
                // Input Field
                NeoTextField {
					id: minutesInput
					visible: true
                    width: parent.width / 4
					height: 45
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.centerIn: parent
					font.pointSize: 15
                    echoMode: TextInput.Password
                    inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhPreferLowercase | Qt.ImhSensitiveData | Qt.ImhNoPredictiveText
                    //text: inputValue
					background: Rectangle {
						width: parent.width
						height: parent.height
						color: "white"
                        //opacity: 0.75
						border.color: "#8D8D8D"
					}
                    onEnterPressed: {
                        buttonQuitClicked()
                    }

				}
                //buttons
				Row {
					width: (parent.width / 5) * 4
					height: parent.height / 3
					spacing: width / 3
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom : parent.bottom
					ButtonEW {
						id: popUpButtonYes
						width: parent.width / 3
						height: parent.height / 2
						text: "Beenden"
						onClicked: {
							buttonQuitClicked()
							popUpWindowPIN.visible = false
							minutesInput.text = ""
						}
					}

					ButtonEW {
						id: popUpButtonNo
						width: parent.width / 3
						height: parent.height / 2
						text: "Abbrechen"
						onClicked: {
							buttonCancelClicked()
							popUpWindowPIN.visible = false
							minutesInput.text = ""
						}
					}
				}
                // NEO Version
                Text {
                    text: version
                    anchors.bottom: parent.bottom
                    anchors.right:  parent.right
                    rightPadding: 5
                    bottomPadding: 5
                }
			}
		}
	}
}
