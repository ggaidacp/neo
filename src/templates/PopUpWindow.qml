import QtQuick 2.15
import "../settings"

Item {
	id: popUpWindow

	width: Settings.embeddedWindowWidth / 3
	height: Settings.embeddedWindowHeight / 4

	property string headerText
    signal closeClicked

	Rectangle {
		width: parent.width
		height: parent.height
        color: "white"
        border.color: Settings.grey
        border.width: 1

    }
}

