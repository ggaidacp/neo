import QtQuick 2.11
import QtQuick.Controls
import QtQuick.Layouts
import "../settings"

PopUpWindow {
	id: popUpWindowWithTwoButtons

	headerText: ""

    property string text : "popUp"
    property string yesButtonImage : ""
    property bool default_active: true
	property string textButton1: "Ja"
	property string textButton2: "Nein"
    property ButtonEW   popUpButtonYes
    property ButtonEW   popUpButtonNo
    property int buttonWidth: 137
    property int buttonHeight: 48
	signal button1Clicked
	signal button2Clicked


    ColumnLayout {
        width: parent.width - 20
        height: parent.height - 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.top: parent.top

        Rectangle {
            width: parent.width
            height: parent.height * 10 / 40
            NeoText {
                id: popUpText
                light: true
                width: parent.width
                height: textElement.implicitHeight + 20
                text: popUpWindowWithTwoButtons.text
                font.pointSize: Settings.isFullscreen ? 18: 12
                color: "black"
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                textFormat: Text.PlainText
            }
        }


        // Trennungslinie
        Rectangle {
            width: parent.width
            height: 2
            color: Settings.grey
        }

        Item { Layout.fillWidth: true }
        // Buttons
        RowLayout {
            width: parent.width //(parent.width / 5) * 4
            height: buttonHeight   //parent.height * 10 / 40
            //anchors.bottom: parent.bottom
            //spacing: 115
            ButtonEW {
                id: popUpButtonYes
                width: buttonWidth //parent.width / 3
                height: buttonHeight //parent.height / 2
                text: popUpWindowWithTwoButtons.textButton1
                //anchors.left: parent.left
                backgroundColor: default_active ? Settings.blue80 : "white"
                textColor: default_active ? "white" : Settings.blue80
                Image {
                    source: yesButtonImage
                }
                onClicked: {
                    button1Clicked()
                    popUpWindowWithTwoButtons.visible = false
                }
            }

            Item { Layout.fillWidth: true }  // Dehnt sich aus

            ButtonEW {
                id: popUpButtonNo
                width: buttonWidth
                height: buttonHeight
                text: popUpWindowWithTwoButtons.textButton2
                backgroundColor: default_active ? "white" : Settings.blue80
                textColor: default_active ? Settings.blue80 : "white"
                //anchors.right : parent.right
                onClicked: {
                    button2Clicked()
                    popUpWindowWithTwoButtons.visible = false
                }
            }
        }

    }
}
