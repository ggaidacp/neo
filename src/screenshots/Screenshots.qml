import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"
import "../functions"
import FileManager 1.0
import DVAGLogger 1.0

ScreenshotsForm {
	id: screenshotsForm

	property alias fileModel: fileModel

	// Stores the delegate for the gridView
	property alias gridDelegate: gridDelegate

	property string screenshotDir: fileManager.getScreenshotDir()


	// Stores the sort order
	property int sortOrder: 8 // -1 = NoSort
	// Counter
	property int i

	onVisibleChanged: {
		if (visible) Settings.isPresentationMode = presentationModeVisibility
	}
	Component.onCompleted: {
		// Load the files into the fileModel
		QmlFileManager.getFilesSorted(screenshotDir, fileModel, sortOrder)
        Settings.contentArea = contentView
		DVAGLogger.log("Screen Shot Dir = " + screenshotDir)

    }

	// Reload the files in case a new screenshot was taken
    // second screen
	Connections {
		target: Settings.embeddedWindow
		onCurrentIndexChanged: {
			// Load the files into the fileModel
			QmlFileManager.getFilesSorted(screenshotDir, fileModel, sortOrder)
            if (Settings.embeddedWindow.currentIndex === 6) {
                // Used for the second screen view
                Settings.contentArea = contentView
            }
        }
	}

	FileManager {
		id: fileManager
	}

	ListModel {
		id: fileModel
	}


	/*
	  *
	  * Footer Right
	  *
	*/
	// Button Sort
/*	buttonSort.onClicked: {
		// Switch the sort order
		// -1 = NoSort // 8 = Reversed
		sortOrder = (sortOrder == -1) ? 8 : -1
		QmlFileManager.getFilesSorted(screenshotDir, fileModel, sortOrder)
	}
	buttonSort.onPressed: {
		buttonSortIcon.source = "qrc:/images/buttons/sort_gold.png"
	}
	buttonSort.onReleased: {
		buttonSortIcon.source = "qrc:/images/buttons/sort.png"
	}
*/
	// Button Delete
	buttonDelete.onClicked: {
		for (i = 0; i < gridView.count; i++) {
			gridView.currentIndex = i
			if (gridView.currentItem.isClicked) {
				fileManager.deleteFile(fileModel.get(i).name, screenshotDir)
				gridView.currentItem.isClicked = false
			}
		}
		QmlFileManager.getFilesSorted(screenshotDir, fileModel, sortOrder)
	}
	buttonDelete.onPressed: {
        buttonDeleteIcon.source = "qrc:/images/buttons/delete.png"
	}
	buttonDelete.onReleased: {
        buttonDeleteIcon.source = "qrc:/images/buttons/delete_gold.png"
	}
    function deleteItem(index) {
        fileManager.deleteFile(fileModel.get(index).name, screenshotDir)
        QmlFileManager.getFilesSorted(screenshotDir, fileModel, sortOrder)
    }

	/*
	  *
	  * Delegate for the gridView
	  *
	*/
	Component {
		id: gridDelegate

		Item {
			id: rootItem
			width: gridView.cellWidth
			height: gridView.cellHeight

            property bool isClicked: false
        Rectangle {
            width: gridView.cellWidth
            height: gridView.cellHeight
			color: "transparent"
            //border.color: "black"
			Column {
                width: gridView.cellWidth //(parent.width / 10) * 9
                height: gridView.cellHeight  //(parent.height / 10) * 7
                topPadding: 10
                spacing: height / 20
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter

				Image {
					id: img
                    width: parent.width - 30
                    height: parent.height - 75//(parent.height / 7) * 3
					source: "file:" + screenshotDir + "/" + name
                   /* fillMode: Image.PreserveAspectFit*/
                    mipmap: true
					/*anchors.verticalCenter:  parent.verticalCenter*/
					anchors.horizontalCenter: parent.horizontalCenter

					// Element to mark clicked items
                    Rectangle {
						width: parent.width
						height: parent.height
                        color: "#337A96"
						opacity: 0.25
						visible: isClicked
					}
                    // Element to mark border of item
                    Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "transparent"
                        border.width: 1
                        border.color: "#337A96"
						//anchors.verticalCenter: parent.verticalCenter
                        visible: true
                    }

					MouseArea {
						width: parent.width
						height: parent.height
						onClicked: {
							gridView.currentIndex = index
							isClicked = !isClicked
						}
						onDoubleClicked: {
							gridView.currentIndex = index
							Settings.screenshotScreenshots = "file:"
									+ screenshotDir + "/" + fileModel.get(
										gridView.currentIndex).name
							Settings.loader6.source = "qrc:/src/screenshots/ScreenshotView.qml"
						}
					}
                    Rectangle {
                        width: 24
                        height: 24
                        color: "transparent"
                        anchors.right: parent.right

                     /*   Image {
                            width: parent.width / 2
                            height: parent.height / 2
                            source: "qrc:/images/close.png"
                            fillMode: Image.PreserveAspectFit
                            anchors.centerIn: parent
                        }*/

                        MouseArea {
                            width: parent.width / 2
                            height: parent.height / 2
                            onClicked: {
                                deleteItem(gridView.currentIndex)
                            }
                        }
                    }
				}

                Text {
                    id: text
                    width: parent.width
                    //height: 30
                    text: QmlFileManager.shortenFilename(Settings.fileMetaData.basename2Pretty(name), width, height, font.pointSize)
                    font.pointSize: 9
                    color: "black"
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
					horizontalAlignment: Text.AlignHCenter
                    clip: !isClicked
					/*anchors.horizontalCenter: parent.horizontalCenter
					anchors.bottom: parent.bottom*/
                }
			}
        }
		}
	}
}
