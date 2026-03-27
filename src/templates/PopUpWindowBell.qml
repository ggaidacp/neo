import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 6.7
import "../settings"

PopUpWindow {
	id: popUpWindowBell

    headerText: "Pausegong"
    width: 428//Settings.embeddedWindowWidth / 3
    height: 257//Settings.embeddedWindowHeight / 3

	property string text
    property string textMin
	property string textButton: "Start"
	property string inputValue
	signal buttonClicked



    Column {
		width: parent.width
        height: parent.height

		Rectangle {
            width: parent.width
            height: (parent.height / 10) * 10
            color: "transparent"
            anchors.centerIn: parent

			Column {
				width: parent.width
				height: parent.height
                spacing: 18

                // Text Message
                Row {
                    width: parent.width
                    height: 40
                    anchors.left: parent.left
                    leftPadding: 25
                    NeoText {
                        id: popUpText
                        width: parent.width
                        height: parent.height
                        text: popUpWindowBell.text
                        light: true
                        font.pointSize: 14
                        color: "black"
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignBottom
                    }
                }
                // Text-Feld Input
                Row {
                    width: parent.width
                    height: 40
                    NeoTextField {
                        id: minutesInput
                        visible: true
                        width: 380 //parent.width
                        height: parent.height
                        placeholderText: "Countdown festlegen"
                        anchors.horizontalCenter: parent.horizontalCenter
                        //anchors.centerIn: parent
                        inputMethodHints: Qt.ImhDigitsOnly
                        font.pointSize: 14
                        text: inputValue
                        background: Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "white"
                            //opacity: 0.75
                            border.color: Settings.grey
                        }

                        onTextChanged: {
                            var val = parseInt(minutesInput.text)
                            if (val !== minutesInput.text) {
                                inputValue = val
                            }
                        }
                        onEnterPressed: {
                            var val = parseInt(minutesInput.text)
                            if (val !== minutesInput.text) {
                                inputValue = val
                            }

                            buttonClicked()
                            popUpWindowBell.visible = false
                            Settings.isPresentationMode = true
                            minutesInput.activeFocus = false
                        }
                    }
                }
                // 15, 30, 60 Minuten Buttons
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20
                    // 15 Minuten
                    ButtonEW {
                        id: viertelStunde
                        width: 115
                        height: 40
                        text: "15 min"//popUpWindowBell.textButton
                        //anchors.horizontalCenter: popUpWindowBell.horizontalCenter
                        onClicked: {
                            minutesInput.text = "15"
                        }
                    }
                    // 30 Minuten
                    ButtonEW {
                        id: halbeStunde
                        width: 115
                        height: 40

                        text: "30 min"//popUpWindowBell.textButton
                        //anchors.horizontalCenter: popUpWindowBell.horizontalCenter
                        onClicked: {
                             minutesInput.text =  "30"
                        }
                    }
                    // 60 Minuten
                    ButtonEW {
                        id: eineStunde
                        width: 115
                        height: 40

                        text: "60 min"//popUpWindowBell.textButton
                        //anchors.horizontalCenter: popUpWindowBell.horizontalCenter
                        onClicked: {
                            minutesInput.text = "60"
                        }
                    }
                }
                // Linie
                Rectangle {
                    width: parent.width - 50
                    height: 1 // Die Dicke der Linie
                    color: Settings.grey
                    anchors.horizontalCenter: parent.horizontalCenter
                }

				Row {
					anchors.horizontalCenter: parent.horizontalCenter
                    spacing : 20

                    ButtonEW {
                        id: playGong
                        width: 183
                        height: 40

                        text: "Jetzt klingeln"//popUpWindowBell.textButton
                        anchors.verticalCenter: popUpWindowBell.verticalCenter
                        onClicked: {
                            //minutesInput.activeFocus = false
                            gong.play()
                        }
                        MediaPlayer {
                            id: gong
                            autoPlay: false
                            source: "qrc:/audio/gong_DVAG.MP3"
                            //volume: 1.0
                            audioOutput: audio // Verknüpfung des AudioOutput
                        }
                        AudioOutput {
                                id: audio
                                volume: 1.0  // Setzt die Lautstärke auf 50%
                        }

                    }


                   /* Rectangle {
                        width: parent.width / 12
                        height: parent.height
                        color: "transparent"
                    }*/

					ButtonEW {
						id: popUpButton
                        width: 183
						height: 40

						text: popUpWindowBell.textButton
                        backgroundColor: Settings.blue80
                        textColor: "white" //"#A6883D"
                        anchors.verticalCenter: popUpWindowBell.verticalCenter
						onClicked: {
							buttonClicked()
							popUpWindowBell.visible = false
                            minutesInput.focus = false
                            //Settings.contentArea = Settings.embeddedWindow
							Settings.isPresentationMode = true
						}
					}
				}
			}
		}
	}
}
