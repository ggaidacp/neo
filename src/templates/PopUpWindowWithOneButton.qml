import QtQuick 2.11
import "../settings"

PopUpWindow {
    id: popUpWindowWithOneButton
    headerText: ""
    property string text
    property string textButton: "Ok"
    property int buttonWidth: 137
    property int buttonHeight: 48
    signal buttonClicked

    Rectangle {
        width: parent.width - 40 // 20 px links und rechts abstand vomn rand
        height: (parent.height / 10) * 8 // 9/10 Abstand zum unteren Rand
        color: "transparent"
        anchors.centerIn: parent

        Column {
            width: parent.width
            height: parent.height
            spacing: 20
            anchors.centerIn: parent
        // Message Text
            NeoText {
                id: popUpText
                light: true
                text: popUpWindowWithOneButton.text
                font.pointSize: Settings.isFullscreen ? 18: 12
                color: "black"
                wrapMode: Text.WordWrap
            }

        // Trennungslinie
            Rectangle {
                width: parent.width
                height: 1
                color: Settings.grey
                anchors.top: parent.top
                anchors.topMargin:  40
            }
        // The One Button
            ButtonEW {
                id: popUpButton
                width: buttonWidth //((parent.width / 5) * 4) / 3
                height: buttonHeight //(parent.height / 3) / 2
                text: popUpWindowWithOneButton.textButton
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom:  parent.bottom
                backgroundColor: Settings.blue80
                textColor: "white"
                onClicked: {
                    buttonClicked()
                    popUpWindowWithOneButton.visible = false
                }
            }
        }
    }
}

