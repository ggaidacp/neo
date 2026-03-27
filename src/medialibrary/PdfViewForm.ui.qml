import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebEngine
import "../settings"
import "../templates"

EmbeddedWindow {
	id: embeddedWindow

	property alias root: root

	// Header
	overviewButtonVisiblity: true
	presentationModeVisibility: true

	// Content
	property alias webengineview: webengineview
	property alias laserPointerArea: laserPointerArea

	// Footer
	// Right
	property alias buttonEdit: buttonEdit
	property alias buttonEditIcon: buttonEditIcon
	property alias buttonScreenshot: buttonScreenshot
	property alias buttonScreenshotIcon: buttonScreenshotIcon
	property alias buttonLaserPointer: buttonLaserPointer
	property alias buttonLaserPointerIcon: buttonLaserPointerIcon

	// PopUpWindow Screenshot Taken
	property alias popUpWindowScreenshotTaken: popUpWindowScreenshotTaken

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

			WebEngineView {
				id: webengineview
				width: parent.width
				height: parent.height
				settings.javascriptCanAccessClipboard: true
				settings.javascriptCanOpenWindows: true
				settings.javascriptEnabled: true
				settings.pluginsEnabled: true
				settings.autoLoadImages: true
				enabled: !buttonLaserPointer.isClicked
			}

			// Laser Pointer
			LaserPointerArea {
				id: laserPointerArea
				width: parent.width
				height: parent.height
				enabled: buttonLaserPointer.isClicked
				visible: Settings.isPresentationMode
			}
		}

		// Footer
        Rectangle {
            width: (embeddedWindow.width / 20) * 20
            height: Settings.embeddedWindowFooterHeight
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
           SeparatorLine {}

			// Right
			Row {
				id: rowRight
				width: parent.width / 4
				height: parent.height
				spacing: width / 18
				anchors.left: parent.left
				LayoutMirroring.enabled: true

				Image {
					id: buttonScreenshotIcon
					width: parent.width / 6
					height: parent.height / 2
					source: "qrc:/images/buttons/screenshot.png"
					fillMode: Image.PreserveAspectFit
					mipmap: true
					anchors.verticalCenter: parent.verticalCenter

					MouseArea {
						id: buttonScreenshot
						width: parent.width
						height: parent.height
					}
				}

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

				Image {
					id: buttonLaserPointerIcon
					width: parent.width / 6
					height: parent.height / 2
					source: buttonLaserPointer.isClicked ? "qrc:/images/buttons/laserpointer_gold.png" : "qrc:/images/buttons/laserpointer.png"
					fillMode: Image.PreserveAspectFit
					mipmap: true
					visible: Settings.isPresentationMode
					anchors.verticalCenter: parent.verticalCenter

					MouseArea {
						id: buttonLaserPointer
						width: parent.width
						height: parent.height

						property bool isClicked: false
					}
				}
			}
		}
	}


	/*
	  *
	  * PopUpWindow for the taken screenshot
	  *
	*/
	PopUpWindowWithOneButton {
		id: popUpWindowScreenshotTaken

		text: "Screenshot gespeichert."
		textButton: "Ok"
		visible: false
		anchors.centerIn: parent
	}
}
