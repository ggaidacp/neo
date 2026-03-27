import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import "../settings"
import "../templates"

EmbeddedWindow {
	id: embeddedWindow

	property alias root: root
   // presentationModeVisibility: true
	// Header
	headerText: "Suche"

	// Content
	property alias gridView: gridView
	property alias scrollView: scrollView

	// Footer
	// Center
	property alias buttonVideos: buttonVideos
	property alias buttonPowerpoints: buttonPowerpoints
	property alias buttonDocuments: buttonDocuments
	property alias buttonEntertainment: buttonEntertainment

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
            width: embeddedWindow.width
			height: (embeddedWindow.height / 30) * 26
            color: "transparent"
            anchors.right: parent.right
            ScrollView {
                id: scrollView
                width: parent.width - 60
                height: parent.height
                clip: true
                topPadding: 30
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                ScrollBar.vertical.visible : false
                GridView {
                    id: gridView
                    width: parent.width
                    height: parent.height
                    /*cellWidth: gridView.width / 7
                    cellHeight: gridView.height / 5*/
                    cellWidth: Settings.isFullscreen ? Settings.fileGridCellWidthFull : Settings.fileGridCellWidth
                    cellHeight: Settings.isFullscreen ? Settings.fileGridCellHeightFull :  Settings.fileGridCellHeight
                    delegate: gridDelegate
                }
            }

            Text {
                id: folderEmptyText
                text: "Keine verfügbaren Dateien vorhanden"
                visible: gridView.model.count > 0 ? false : true
                color: "black"
                font.pointSize: 20
                font.family: Settings.defaultFont
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                anchors.centerIn: parent
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
            Rectangle {
                width: parent.width * 60 / 100
                height: parent.height
                color: "transparent"
                //anchors.horizontalCenter: parent.horizontalCenter
                property real checkboxwithratio: 0.25
                Row {
                    id: rowCenter
                    width: parent.width * 9 / 10
                    height: parent.height
                    spacing: width / 16
                    anchors.horizontalCenter:  parent.horizontalCenter
                    leftPadding: parent.width * 22 / 100

                        ButtonFilterEW {
                            id: buttonVideos
                            width: parent.width * 22 / 100
                            height: parent.height / 2
                            isClicked: true
                            boxchecked: true
                            customtext : "Videos"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        ButtonFilterEW {
                            id: buttonPowerpoints
                            width: parent.width * 22 / 100
                            height: parent.height / 2
                            isClicked: true
                            boxchecked: true
                            customtext : "Powerpoints"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        ButtonFilterEW {
                            id: buttonDocuments
                            width: parent.width * 22 / 100
                            height: parent.height / 2
                            isClicked: true
                            boxchecked: true
                            customtext : "Dokumente"
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        ButtonFilterEW {
                            id: buttonEntertainment
                            width: parent.width * 22 / 100
                            height: parent.height / 2
                            isClicked: true
                            boxchecked: true

                            customtext : "Audio"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
            }
        }
	}
}
