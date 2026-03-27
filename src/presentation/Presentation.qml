import QtQuick 2.15
import QtQuick.VirtualKeyboard
import "../settings"
import "../functions"
import DVAGLogger 1.0
import FileManager 1.0

PresentationForm {
	id: presentation
    property int defaultCounterStoryBoard: 4
    property int storyElementWidth: 240
	property alias fileModel: fileModel
	property alias storyboardModel: storyboardModel
	// Stores the delegate for the listView
	property alias listDelegate: listDelegate
	// Stores the delegate for the gridView
	property alias gridDelegate: gridDelegate

	// Stores the history of folder for the navigation
	property var history: []
	// Stores the current position in the history
	property int historyCounter: 0

	property string fileName
	property string fileType

	// Stores the path of the icon for the files in the gridView
	property string imgPath
	// Stores the path of the currently selected dir
	property string selectedDir: fileManager.getMediaDir()
	// Stores the path of the storyboard dir
	property string storyboardDir: fileManager.getStoryboardDir()

	// Trigger to indicate if search results are shown (used by buttonBack)
	property bool searchResultsShown: false

	property bool keepFile: false

	// Counter
	property int i
	property int j
	property int counter


	function initModule() {
		QmlFileManager.getFiles(selectedDir, fileModel)

		// Init the storyboard
		var storyboard = fileManager.readStoryboardJson()
		storyboardModel.clear()
		DVAGLogger.log("storyboard gecleared")
		if (storyboard.length > 0) {
			// Stringlist [filename1, filetype1, path1, filename2, filetype2, path2, ...]
			for (i = 0; i < storyboard.length; i += 3) {
				storyboardModel.append({
										   "name": storyboard[i],
										   "type": storyboard[i + 1],
										   "path": storyboard[i + 2],
										   "done": false
									   })


			}
		}
        if (storyboardModel.count === 0)
            for (x = 0; x < defaultCounterStoryBoard; x++)
				storyboardModel.append({
										   "name": "",
										   "type": "",
										   "path": "",
										   "done": false
									   })
	}

	Component.onCompleted: {
		Settings.presentationModule = presentation
		initModule()
	}
	onVisibleChanged: {
		if (visible) {
			Settings.isPresentationMode = presentationModeVisibility
		} else {

		}
	}

    Connections {
		target: Settings.embeddedWindow
        onCurrentIndexChanged:  {
			// Reload directory content
            QmlFileManager.getFiles(selectedDir, fileModel)
            gridView.update()
		}
	}

	Connections {
		target: fileManager
        onDataDirContentChanged:  {
			// Reload directory content
			QmlFileManager.getFiles(selectedDir, fileModel)
            gridView.update()
		}
	}

	FileManager {
		id: fileManager
		onSearchFinished: {
			var searchResults = fileManager.getSearchResults()
			fileModel.clear()
			// Stringlist [filename1, path1, filename2, path2, ...]
			for (i = 0; i < searchResults.length; i += 2) {
				fileName = searchResults[i]
				fileType = fileManager.getSupportedFileType(
							fileManager.getMimeType(fileName, selectedDir))
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": searchResults[i + 1]
								 })
			}
			busyIndicator.visible = false
            localsearchField.enabled = true
           // buttonSearchImg.enabled = true
		}
	}

	// Stores the files/folders in a dir
	ListModel {
		id: fileModel
	}

	// Stores the storyboard. Init is 3 empty elements
	ListModel {
		id: storyboardModel

		ListElement {
			name: ""
			type: ""
			path: ""
			done: false
		}
		ListElement {
			name: ""
			type: ""
			path: ""
			done: false
		}
		ListElement {
			name: ""
			type: ""
			path: ""
			done: false
		}

	}


	/*
	  *
	  * Content
	  *
	*/
	buttonScrollLeft.onClicked: {
       scrollBarList.decrease()
	}
	buttonScrollLeft.onPressed: {
		buttonScrollLeftIcon.source = "qrc:/images/presentation/scroll_left_gold.png"
	}
	buttonScrollLeft.onReleased: {
		buttonScrollLeftIcon.source = "qrc:/images/presentation/scroll_left.png"
	}

    buttonScrollRight.onClicked: {
        scrollBarList.increase()
    }
	buttonScrollRight.onPressed: {
		buttonScrollRightIcon.source = "qrc:/images/presentation/scroll_right_gold.png"
	}
	buttonScrollRight.onReleased: {
		buttonScrollRightIcon.source = "qrc:/images/presentation/scroll_right.png"
	}


	/*
	  *
	  * Footer Center
	  *
	*/



	buttonMedialibrary.onClicked: {
        DVAGLogger.log("Presi-Media isClicked: " + buttonMedialibrary.checked)
        //if (!buttonMedialibrary.checked) {
			selectedDir = fileManager.getMediaDir()
			QmlFileManager.getFiles(selectedDir, fileModel)
			// Reset the history
			history = history.slice(0, 0)
			historyCounter = 0

			//			buttonDav.isClicked = false
            /*buttonMedialibrary.checked = false
            buttonMedialibrary.checked = false
            buttonImport.isClicked = false
            buttonImport.boxchecked = false*/
        //}
	}

	buttonImport.onClicked: {
        DVAGLogger.log("Presi-Import isClicked: " + buttonImport.checked)
       // if (!buttonImport.checked) {
			selectedDir = fileManager.getImportDir()
			QmlFileManager.getFiles(selectedDir, fileModel)
			// Reset the history
			history = history.slice(0, 0)
			historyCounter = 0
	}

    /* Footer Right (search)
      */

  /*  localsearchField.onEnterPressed: {
         startSearch()
    }*/
    buttonSearchIconInside.onClicked : {
        startSearch()
    }

    function startSearch() {
        busyIndicator.visible = true
        localsearchField.enabled = false
        fileManager.searchInDirThread(localsearchField.text, selectedDir)
        searchResultsShown = true
    }

    buttonlocalSearch.onClicked:  {
        searchfieldrow.visible = !searchfieldrow.visible
        if (!searchfieldrow.visible) {
           localsearchField.focus = false
			searchfieldrow.height = 0
        } else {
		   searchfieldrow.height = 90
           localsearchField.focus = true
           localsearchField.forceActiveFocus()
        }

        //localsearchField.font.italic = false
	}

    // Footer Ende

	// Button New
    buttonNewEmbedded.onClicked: {
		storyboardModel.append({
								   "name": "",
								   "type": "",
								   "path": "",
								   "done": false
							   })
        scrollBarList.position = scrollListView.width
	}
    buttonNewEmbedded.onPressed: {
        buttonNewEmbeddedIcon.source = "qrc:/images/presentation/add_story_active.png"
	}
    buttonNewEmbedded.onReleased: {
        buttonNewEmbeddedIcon.source = "qrc:/images/presentation/add_story.png"
	}

	// Button Save
    function saveStories()  {
		var storyboard = []
		counter = 0
		// Copy all files in the storyboard to the storyboard "backup" dir
		for (i = 0; i < storyboardModel.count; i++) {
			storyboard[counter] = storyboardModel.get(i).name
			storyboard[counter + 1] = storyboardModel.get(i).type
			storyboard[counter + 2] = storyboardDir
			counter += 3
			fileManager.copyFile(storyboardModel.get(i).name,
								 storyboardModel.get(i).path, storyboardDir)
		}
		// Write the storayboard json
		fileManager.writeStoryboardJson(storyboard)

		// Delete all files which are not in the storyboard anymore
		// Aka older files
		var files = fileManager.getSupportedFilesInDir(storyboardDir)
		for (i = 0; i < files.length; i++) {
			keepFile = false
			for (j = 0; j < storyboardModel.count; j++) {
				if (files[i] === storyboardModel.get(j).name) {
					keepFile = true
				}
			}
			if (!keepFile) {
				fileManager.deleteFile(files[i], storyboardDir)
			}
		}

	}


	/*
	  *
	  * Functions
	  *
	*/
	// Called when a folder is opened
	function saveToHistory() {
		historyCounter++
		history[historyCounter] = selectedDir
		history = history.slice(0, historyCounter + 1)
	}


	/*
	  *
      * Delegate for the listView (story board)
	  *
	*/
	Component {
		id: listDelegate

		Item {
			id: rootItem
            width: !Settings.isFullscreen ? storyElementWidth : storyElementWidth * 1.5 //scrollListView.width / 4
            height: (scrollListView.height / 10) * 10
            //anchors.verticalCenter: parent.verticalCenter
			Rectangle {
                width: (parent.width / 10) * 9 //Settings.isFullscreen ? 250 : 200 //
                height: parent.height * 10 / 18 //Settings.isFullscreen ? 150 : 100
				color: "white"
                border.color: Settings.blue80
                anchors.verticalCenter: parent.verticalCenter
                clip: true

				MouseArea {
					width: parent.width
                    height: parent.height
					onDoubleClicked: {
						listView.currentIndex = index
						// Check if the clicked element is empty
						if (storyboardModel.get(
									listView.currentIndex).name !== "") {
							// Mark the element in the storyboard as done
							done = true
							var doc = path + "/" + name
							switch (type) {
							case "video":
								Settings.mediaPlayerFileType = "video"
								Settings.videoFilePresentation = path + "/" + name
                                DVAGLogger.log("Settings.videoFilePresentation = "
											+ Settings.videoFilePresentation)
								Settings.loaderNewWindow.source
										= "qrc:/src/medialibrary/VideoPlayer.qml"
								Settings.loaderNewWindow.visible = true
								break
							case "audio":
								Settings.mediaPlayerFileType = "audio"
								Settings.videoFilePresentation = path + "/" + name
                                DVAGLogger.log("Settings.videoFilePresentation = "
											+ Settings.videoFilePresentation)
								Settings.loaderNewWindow.source
										= "qrc:/src/medialibrary/VideoPlayer.qml"
								Settings.loaderNewWindow.visible = true
								break
							case "powerpoint":
                                DVAGLogger.log("doc = " + doc)
								fileManager.startProgram(
											"powerpointpresentation", doc)
								break
							case "excel":
                                DVAGLogger.log("doc = " + doc)
								fileManager.startProgram("excel",
														 path + "/" + name)
								break
							case "word":
                                DVAGLogger.log("doc = " + doc)
								fileManager.startProgram("word",
														 path + "/" + name)
								break
							case "pdf":
								Settings.pdfFilePresentation = path + "/" + name
                                DVAGLogger.log("Settings.pdfFilePresentation = "
											+ Settings.pdfFilePresentation)
								Settings.loaderNewWindow.source
										= "qrc:/src/medialibrary/PdfView.qml"
								Settings.loaderNewWindow.visible = true
								break
							case "image":
								Settings.screenshotPresentation = "file:" + path + "/" + name
								DVAGLogger.log("Settings.screenshotPresentation = " + Settings.screenshotPresentation)
								Settings.loaderNewWindow.source = "qrc:/src/screenshots/ScreenshotView.qml"
								Settings.loaderNewWindow.visible = true
								break
							default:
								break
							}
						}
					}
				}

				// Close icon for the storyboard elements
				Rectangle {
					width: parent.width / 8 > parent.height
						   / 6 ? parent.height / 6 : parent.width / 8
					height: parent.width / 8 > parent.height
							/ 6 ? parent.height / 6 : parent.width / 8
                    color: "transparent"
					anchors.right: parent.right

					Image {
                        width: parent.width / 2
                        height: parent.height / 2
						source: "qrc:/images/close.png"
						fillMode: Image.PreserveAspectFit
						anchors.centerIn: parent
					}

					MouseArea {
						width: parent.width
						height: parent.height
						onClicked: {
							listView.currentIndex = index
							storyboardModel.remove(listView.currentIndex)
                            saveStories()
						}
					}
				}

				Image {
					id: plusImg
					width: parent.width / 10
					height: parent.height / 3
                    source: "qrc:/images/presentation/plus.png"
					visible: type === "" ? true : false
					fillMode: Image.PreserveAspectFit
					anchors.centerIn: parent
				}

				DropArea {
					id: dragTarget
					width: parent.width
					height: parent.height
					anchors.centerIn: parent

					onDropped: {
						listView.currentIndex = index
						// Check if the dropped item is a folder. Only files should be droppable
						if (gridView.currentItem.iconType !== "folder") {
							storyboardModel.set(listView.currentIndex, {
													"name": gridView.currentItem.completeFileName,
													"type": gridView.currentItem.iconType,
													"path": selectedDir,
													"done": false
												})
                         saveStories()
						}
					}

					Column {
						id: column
						width: (parent.width / 10) * 9
						height: (parent.height / 10) * 9
						spacing: height / 7
                        topPadding: 13
						anchors.verticalCenter: parent.verticalCenter
						anchors.horizontalCenter: parent.horizontalCenter

						Image {
							id: img
							width: parent.width
							height: (parent.height / 7) * 4
							source: type === "" ? "" : "qrc:/images/fileicons/" + type + ".png"
							fillMode: Image.PreserveAspectFit
							opacity: done ? 0.5 : 1.0
						}

						Text {
							id: text
							width: parent.width
                            height: (parent.height / 70) * 25
                            text: QmlFileManager.shortenFilename(Settings.fileMetaData.basename2Pretty(name), width, height,font.pointSize)
							font.pointSize: 10
                            color: "black"

							horizontalAlignment: Text.AlignHCenter
							verticalAlignment: Text.AlignTop
							opacity: done ? 0.5 : 1.0
							clip: true
							anchors.horizontalCenter: parent.horizontalCenter
                            wrapMode: Text.WrapAnywhere
						}
					}
				}

				// Img to show if a file in the storyborad was already opened
				Image {
					id: checkImg
					width: (parent.width / 3) * 2
					height: (parent.height / 3) * 2
					source: "qrc:/images/presentation/done_gold.png"
					visible: done
					fillMode: Image.PreserveAspectFit
					anchors.centerIn: parent
				}
			}
		}
	}


	/*
	  *
      * Delegate for the gridView available Files
	  *
	*/
	Component {
		id: gridDelegate

		Item {
			id: rootItem
            width: gridView.cellWidth
            height: gridView.cellHeight

			property bool isClicked: false
			property string completeFileName: name
			property string iconType: type
			property bool isDir: (type === "folder") ? true : false

			MouseArea {
				id: mouseArea
				width: parent.width
				height: parent.height
				onClicked: {
					gridView.currentIndex = index
					isClicked = !isClicked
				}

				onDoubleClicked: {
					if (isDir) {
						selectedDir += "/" + name
						saveToHistory()
						QmlFileManager.getFiles(selectedDir, fileModel)
						gridView.currentIndex = 0
					}
				}

				drag.target: column

				onPressed: {
					gridView.currentIndex = index
				}

				onReleased: {
					gridView.currentIndex = index
					// End the drag event
                    column.Drag.drop()
				}

				Column {
					id: column
                    width: parent.width
                    height: parent.height
                    spacing: 8
                    //anchors.top: top
					anchors.horizontalCenter: parent.horizontalCenter

					Drag.active: mouseArea.drag.active
					Drag.hotSpot.x: width / 2
					Drag.hotSpot.y: height / 2

					states: State {
						when: mouseArea.drag.active
						ParentChange {
							target: column
							parent: content
							width: column.width
							height: column.height
						}
						AnchorChanges {
							target: column
							anchors.verticalCenter: undefined
							anchors.horizontalCenter: undefined
						}
					}

                    Image {
                        id: img
                        width: parent.width / 2 - 10
                        height: parent.height / 2 - 20
                        // Change the icon color if the icon was clicked
                        source: "qrc:/images/fileicons/" + type + ".png"
                        fillMode: Image.PreserveAspectFit
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: text
                        width: parent.width
                        height: parent.height / 2 - 30
                        font.pointSize: 10
                        color: "black"
                        text: QmlFileManager.shortenFilename(rootItem.completeFileName, width - 20, height,font.pointSize)
                        leftPadding: 10
                        rightPadding: 10
                        /*verticalAlignment: (isClicked
                                            && (text.paintedHeight
                                                > text.height)) ? Text.AlignBottom : Text.AlignTop*/
                        clip: !isClicked
                        wrapMode: Text.WrapAnywhere
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignTop
                    }
				}
			}
		}
	}
}
