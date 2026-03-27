import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"
import "../templates"

EmbeddedWindow {
	id: embeddedWindow

	// Header
	headerText: ""
	overviewButtonVisiblity: true
	presentationModeVisibility: true

	// Content
	property alias imgBackground: imgBackground
	property alias img: img
	property alias laserPointerArea: laserPointerArea

	// Footer
	// Center
	property alias buttonClose: buttonClose
	// Right
	property alias buttonEdit: buttonEdit
	property alias buttonEditIcon: buttonEditIcon
    //property alias buttonDelete: buttonDelete
    //property alias buttonDeleteIcon: buttonDeleteIcon

	Column {
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
			id: imgBackground
			width: embeddedWindow.width
            height: (embeddedWindow.height / 30) * 26
			color: "transparent"

			Rectangle {
                width: parent.width - 4
                height: parent.height - 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "white"
			}

            Image {
				id: img
                width: parent.width
                height: parent.height
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                //fillMode: Image.PreserveAspectFit
                //mipmap: true

				// Laser Pointer
				LaserPointerArea {
					id: laserPointerArea
					width: parent.width
					height: parent.height
					visible: Settings.isPresentationMode
				}
            }
		}

        // Footer
        Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowFooterHeight//(embeddedWindow.height / 30) * 3
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            SeparatorLine {}

			// Center
			ButtonEW {
				id: buttonClose
				width: (parent.width / 2) / 3
				height: parent.height / 2
				text: "Schließen"
				anchors.centerIn: parent
			}

            // Right
            Row {
                id: rowRight
                width: parent.width / 5
                height: parent.height
                spacing: width / 20
                anchors.left: parent.left
                LayoutMirroring.enabled: true
                rightPadding: 28

           /*     Image {
                    id: buttonDeleteIcon
                    width: parent.width / 6
                    height: parent.height / 2
                    source: "qrc:/images/buttons/delete.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        id: buttonDelete
                        width: parent.width
                        height: parent.height
                    }
                }*/

                Image {
                    id: buttonEditIcon
                    width: parent.width / 6
                    height: parent.height / 2
                    source: "qrc:/images/edit.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        id: buttonEdit
                        width: parent.width
                        height: parent.height
                    }
                }
            }
		}
	}
}
