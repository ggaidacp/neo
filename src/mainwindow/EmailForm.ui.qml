import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"
import "../templates"

EmbeddedWindow {
	id: embeddedWindow

    property alias contentView: contentView
	property alias root: root
	property alias textTo: textTo

	property alias inputTo: inputTo
	property alias inputSubject: inputSubject
	property alias inputBody: inputBody

	// Header
	headerText: "E-Mail"
    presentationModeVisibility: true

	// Content
	property alias listViewEmail: listViewEmail
	property alias buttonSend: buttonSend
	property alias buttonAttachments: buttonAttachments
	property alias statusLine: statusLine

	Column {
		id: root
		width: parent.width
		height: parent.height

        // Header
        Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowHeaderHeight
            color: "transparent"
        }

		// Content
		Rectangle {
            id: contentView
			width: embeddedWindow.width
			height: (embeddedWindow.height / 30) * 26
            color: "transparent"
            Rectangle {
                width: parent.width - 4
                height: parent.height - 4
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            Row {
                width: (parent.width / 10) * 9
                height: (parent.height / 10) * 9
                anchors.centerIn: parent

                Column {
                    width: (parent.width / 8) * 7
                    height: parent.height
                    spacing: parent.height / 30
                    anchors.verticalCenter: parent.verticalCenter

                    Row {
                        width: (parent.width / 10) * 9
                        height: parent.height / 20
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            id: textTo
                            width: textTo.paintedWidth > textSubject.paintedWidth ? textTo.paintedWidth : textSubject.paintedWidth
                            height: parent.height
                            text: "An:"
                            font.pointSize: Settings.isFullscreen ? 20 : 12
                            font.family: Settings.defaultFont
                            color: "black"
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter

                        }

                        NeoTextField {
                            id: inputTo
                            width: parent.width - textTo.width
                            height: parent.height
                            placeholderText: ""
                            font.pointSize: Settings.isFullscreen ? 20 : 12
                            inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhNoPredictiveText | Qt.ImhLowercaseOnly
                            background: Rectangle {
                                width: parent.width
                                height: parent.height
                                color: isValid ? "white" : "#ffe6e6"
                                border.color: "#337A96"
                            }

                        }
                    }

                    Row {
                        width: (parent.width / 10) * 9
                        height: parent.height / 20
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            id: textSubject
                            width: textTo.paintedWidth > textSubject.paintedWidth ? textTo.paintedWidth : textSubject.paintedWidth
                            height: parent.height
                            text: "Betreff:  "

                            font.pointSize: Settings.isFullscreen ? 20 : 12
                            font.family: Settings.defaultFont
                            color: "black"
                            anchors.verticalCenter: parent.verticalCenter
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                        }

                        NeoTextField {
                            id: inputSubject
                            width: parent.width - textSubject.width
                            height: parent.height
                            font.pointSize: Settings.isFullscreen ? 20 : 12
                            placeholderText: ""
                            background: Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "white"
                                //opacity: 0.75
                                border.color: "#337A96"
                            }

                        }
                    }

                    TextArea {
                        id: inputBody
                        width: (parent.width / 10) * 9
                        height: parent.height - (parent.height / 15) - (parent.height / 10) - 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: Settings.isFullscreen ? 20 : 15
                        background: Rectangle {
                            width: parent.width
                            height: parent.height
                            color: "white"
                            opacity: 0.75
                            border.color: "#337A96"
                        }

                    }

                    Text {
                        id: statusLine
                        width: (parent.width / 10) * 9
                        height: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pointSize: Settings.isFullscreen ? 20 : 12
                        font.family: Settings.defaultFont
                    }
                }

                Column {
                    width: parent.width / 6
                    height: parent.height - 20
                    anchors.top: parent.top
                    // Liste der Anhänge
                    Rectangle {
                        width: parent.width
                        height: (parent.height / 10) * 9
                        color: Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.5)
                        //radius: 5
                        border.color: "#337A96"

                        ScrollView {
                            width: (parent.width / 20) * 19
                            height: parent.height
                            clip: true
                            anchors.horizontalCenter: parent.horizontalCenter
                            ScrollBar.vertical: ScrollBar {
                                height: parent.height
                                anchors.right: parent.right
                                policy: "AlwaysOff"
                            }

                            ListView {
                                id: listViewEmail
                                width: parent.width
                                height: parent.height
                                model: Settings.attachmentsModel
                                delegate: emailListDelegate
                            }
                        }
                    }
                    // Button Anhängen
                    Rectangle {
                        width: parent.width
                        height: parent.height / 10
                        color: "transparent"

                        ButtonEW {
                            id: buttonAttachments
                            width: parent.width
                            height: (parent.height / 3) * 2
                            text: "Anhänge hinzufügen"

                            backgroundColor: Settings.blue80
                            textColor: "white"
                            textSize: Settings.isFullscreen ? 17 : 11
                            anchors.bottom: parent.bottom
                        }
                    }
                }
            }
            }
        }

        // Footer
        Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowFooterHeight
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            SeparatorLine {}
			// Center
			ButtonEW {
				id: buttonSend
				width: (parent.width / 2) / 3
				height: parent.height / 2
				text: "Senden"
				anchors.centerIn: parent
                backgroundColor: "white"
                textColor: "#337A96"
			}
		}
	}
}

/*##^## Designer {
	D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

