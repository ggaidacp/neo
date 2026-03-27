import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt5Compat.GraphicalEffects
import "../settings"
import "../templates"

import FileManager 1.0

EmbeddedWindow {
	id: embeddedWindow

	headerText: ""
	overviewButtonVisiblity: true

	property alias imgBackground: imgBackground
	property alias img: img

	// Footer
	// Center
	property alias buttonClose: buttonClose
	// Right
	property alias buttonEdit: buttonEdit
	property alias buttonEditIcon: buttonEditIcon
	property alias buttonDelete: buttonDelete
	property alias buttonDeleteIcon: buttonDeleteIcon

	Component.onCompleted: {
		// Set the headerText to the name of the screenshot
		headerText = Settings.screenshot.substr(
					Settings.screenshot.lastIndexOf("/") + 1,
					Settings.screenshot.length)
		// Used for the second screen view
		Settings.contentArea = img
	}

	// Second screen
	Connections {
		target: Settings.embeddedWindow
		onCurrentIndexChanged: {
            if ((Settings.embeddedWindow.currentIndex === 1 &&
                Settings.loaderNewWindow.source === "qrc:/src/screenshots/ScreenshotView.qml") ||
                (Settings.embeddedWindow.currentIndex === 2 &&
                Settings.loader2.source === "qrc:/src/screenshots/ScreenshotView.qml") ||
                (Settings.embeddedWindow.currentIndex === 3 &&
                Settings.loader3.source === "qrc:/src/screenshots/ScreenshotView.qml") ||
                (Settings.embeddedWindow.currentIndex === 6 &&
                Settings.loader6.source === "qrc:/src/screenshots/ScreenshotView.qml")) {
				// Used for the second screen view
				Settings.contentArea = img
			}
		}
	}

    /*onBackClicked: {
		if (Settings.loaderNewWindow.visible) {
			Settings.loaderNewWindow.visible = false
			Settings.loaderNewWindow.source = ""
		} else if (Settings.loader2.visible) {
			Settings.loader2.source = "qrc:/src/dav/DavLibrary.qml"
		} else if (Settings.loader3.visible) {
			Settings.loader3.source = "qrc:/src/medialibrary/MediaLibrary.qml"
		} else if (Settings.loader6.visible) {
			Settings.loader6.source = "qrc:/src/screenshots/Screenshots.qml"
		}
    }*/

	FileManager {
		id: fileManager
	}

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
				width: parent.width
				height: parent.height
                color: "white"
			}

            Image {
				id: img
                width: parent.width * 1 / 3
				height: parent.height
				source: Settings.screenshot
                fillMode: Image.PreserveAspectFit
				mipmap: true
            }

			MouseArea {
				id: laserPointerArea
				width: parent.width
				height: parent.height
			}

			Item {
				id: whiteFade
				x: laserPointerArea.mouseX - (width / 2)
				y: laserPointerArea.mouseY - (height / 2)
				width: 30
				height: width
				//radius: width / 2
				//color: "white"
				//opacity: 0.5
				RadialGradient {
					anchors.fill: parent
					gradient: Gradient {
						GradientStop {
							position: 0.0
							color: "white"
						}
						GradientStop {
							position: 0.5
							color: "transparent"
						}
					}

					Rectangle {
						id: redCircle
						x: (whiteFade.width / 2) - (width / 2)
						y: (whiteFade.height / 2) - (height / 2)
						width: 10
						height: width
						radius: width / 2
						color: "red"

						Rectangle {
							id: whiteCircle
							x: (redCircle.width / 2) - (width / 2)
							y: (redCircle.height / 2) - (height / 2)
							width: 5
							height: width
							radius: width / 2
							color: "white"
						}
					}
				}
			}
		}

		// Footer
		Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowFooterHeight
			color: "transparent"
			anchors.horizontalCenter: parent.horizontalCenter

			ButtonEW {
				id: buttonClose
				width: (parent.width / 2) / 3
				height: parent.height / 2
				text: "Schließen"
				anchors.centerIn: parent
				onClicked: {
					if (Settings.loaderNewWindow.visible) {
						Settings.loaderNewWindow.visible = false
					} else if (Settings.loader2.visible) {
						Settings.loader2.source = "qrc:/src/dav/Dav.qml"
					} else if (Settings.loader3.visible) {
						Settings.loader3.source = "qrc:/src/medialibrary/MediaLibrary.qml"
					} else if (Settings.loader6.visible) {
						Settings.loader6.source = "qrc:/src/screenshots/Screenshots.qml"
					}
				}
			}

			Row {
				id: rowRight
				width: parent.width / 5
				height: parent.height
				spacing: width / 20
				anchors.left: parent.left
				LayoutMirroring.enabled: true

				Image {
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
						onClicked: {
							fileManager.deleteFile(
										Settings.screenshot.substr(
											Settings.screenshot.lastIndexOf(
												"/") + 1,
											Settings.screenshot.length),
										fileManager.getScreenshotDir())
							Settings.loader6.source = "Screenshots.qml"
						}
						onPressed: {
							buttonDeleteIcon.source = "qrc:/images/buttons/delete_gold.png"
						}
						onReleased: {
							buttonDeleteIcon.source = "qrc:/images/buttons/delete.png"
						}
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
						onClicked: {
							Settings.startEditMode(false)
						}
						onPressed: {
                            buttonEditIcon.source = "qrc:/images/buttons/edit_gold.png"
						}
						onReleased: {
                            buttonEditIcon.source = "qrc:/images/edit.png"
						}
					}
                }
			}
		}
	}
}
