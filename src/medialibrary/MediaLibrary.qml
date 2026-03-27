import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"
import "../functions"
import FileManager 1.0
import DVAGLogger 1.0

MediaLibraryForm {
	property alias fileModel: fileModel

	// Stores the delegate for the gridView
	property alias gridDelegate: gridDelegate

	property string fileName
	property string fileType

	property string mediaDir: fileManager.getMediaDir()

	// Trigger to indicate if search results are shown (used by buttonBack)
	property bool searchResultsShown: false

	// Counter
	property int i: 0

	Component.onCompleted: {
		// All buttons(filters) are initially false --> getSearchResults
		getFilteredFiles()
		//Settings.contentArea = gridView
        buttonVideos.isClicked = true
        //buttonDocuments.isClicked = true
	}


	onVisibleChanged: {
		if (visible) Settings.isPresentationMode = presentationModeVisibility
	}

    Connections {
        target: Settings.embeddedWindow
        onCurrentIndexChanged: {
            // Reload directory content
            getFilteredFiles()
			if (Settings.embeddedWindow.currentIndex === 3) {
				// Used for the second screen view
				//Settings.contentArea = gridView
				DVAGLogger.log("*********** CurrentIndex = " + Settings.embeddedWindow.currentIndex)
				//Settings.contentAreaEditMode = laserPointerArea
			}
        }
    }

    Connections {
        target: fileManager
        onDataDirContentChanged: {
            // Reload directory content
            getFilteredFiles()
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
							fileManager.getMimeType(fileName, mediaDir))
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": searchResults[i + 1]
								 })
			}
			gridView.model = fileModel
			// Reset the busy state of the searchField
			busyIndicator.visible = false
            localsearchField.enabled = true
			buttonSearchStart.enabled = true
		}
	}

	// Stores the files in the dirs
	ListModel {
		id: fileModel
	}

	// Stores the filtered files in the dirs
	ListModel {
		id: filteredFileModel
	}


	/*
	  *
	  * Footer Center
	  *
	*/
	// Videos Button
    buttonVideos.onClicked:  {
        buttonVideos.boxchecked = !buttonVideos.boxchecked
		getFilteredFiles()
        localsearchField.text = ""
	}

	// Bilder Button
	buttonPictures.onClicked: {
		buttonPictures.boxchecked = !buttonPictures.boxchecked
		getFilteredFiles()
        localsearchField.text = ""
	}

	// Documents Button
    /*buttonDocuments.onClicked: {
        buttonDocuments.boxchecked = !buttonDocuments.boxchecked
		getFilteredFiles()
        localsearchField.text = ""
    }*/

	// Entertainment Button
	buttonEntertainment.onClicked: {
        buttonEntertainment.boxchecked = !buttonEntertainment.boxchecked
		getFilteredFiles()
        localsearchField.text = ""
	}


	/*
	  *
	  * Footer Right
	  *
	*/



    buttonlocalSearch.onClicked:  {
        searchfieldrow.visible = !searchfieldrow.visible
        if (!searchfieldrow.visible) {
           localsearchField.focus = false
        } else {
           localsearchField.focus = true
           localsearchField.forceActiveFocus()
        }

        //localsearchField.font.italic = false
    }


    localsearchField.onEnterPressed: {
        startSearch()
    }
    buttonSearchIconInside.onClicked: {
        startSearch()

    }
    function startSearch() {
        // Busy state of the searchField
        busyIndicator.visible = true
        localsearchField.enabled = false
        //buttonSearchStart.enabled = false
        // Start search
        fileManager.searchInDirThread(localsearchField.text, mediaDir)
        searchResultsShown = true
        // Reset the filters
        buttonVideos.isClicked = false
		buttonPictures.isClicked = false
		//buttonDocuments.isClicked = false
        buttonEntertainment.isClicked = false
        // Reset the model
        gridView.model = fileModel
    }

	/*
	  *
	  * Functions
	  *
	*/
	// Fills the fileModel with files depending on the active filters
	function getFilteredFiles() {


        /*if (       buttonVideos.isClicked
               && buttonPowerpoints.isClicked
                && buttonDocuments.isClicked
                && buttonEntertainment.isClicked
            ) {
            DVAGLogger.log("*** NO Filter (FULL) ******* ")
			QmlFileManager.getFilesWithoutFolders(mediaDir, fileModel)
            gridView.model = fileModel
        } else {*/
            QmlFileManager.getFilesWithoutFolders(mediaDir, fileModel)
            gridView.model = fileModel
			filteredFileModel.clear()
            if (buttonVideos.isClicked) {
                DVAGLogger.log("*** Filter Video ******* ")
				for (i = 0; i < fileModel.count; i++) {
					// Add files of supported file types
					if (fileModel.get(i).type === "video") {
						filteredFileModel.append({
													 "name": fileModel.get(
																 i).name,
													 "type": fileModel.get(
																 i).type,
													 "path": fileModel.get(
																 i).path
												 })
					}
				}
			}
			if (buttonPictures.isClicked) {
				for (i = 0; i < fileModel.count; i++) {
					// Add files of supported file types
					if (fileModel.get(i).type === "image") {
						filteredFileModel.append({
													 "name": fileModel.get(
																 i).name,
													 "type": fileModel.get(
																 i).type,
													 "path": fileModel.get(
																 i).path
												 })
					}
				}
            }
			/*if (buttonDocuments.isClicked) {
				for (i = 0; i < fileModel.count; i++) {
					// Add files of supported file types
					if (fileModel.get(i).type === "pdf" || fileModel.get(
								i).type === "word" || fileModel.get(
								i).type === "excel") {
						filteredFileModel.append({
													 "name": fileModel.get(
																 i).name,
													 "type": fileModel.get(
																 i).type,
													 "path": fileModel.get(
																 i).path
												 })
					}
				}
            }*/
            if (buttonEntertainment.isClicked) {
                DVAGLogger.log("*** Filter Entertainment ******* ")
				for (i = 0; i < fileModel.count; i++) {
					// Add files of supported file types
					if (fileModel.get(i).type === "audio") {
						filteredFileModel.append({
													 "name": fileModel.get(
																 i).name,
													 "type": fileModel.get(
																 i).type,
													 "path": fileModel.get(
																 i).path
												 })
					}
				}
			}
			gridView.model = filteredFileModel
        //}
	}


	/*
	  *
	  * Delegate for the gridView
	  *
	*/
	Component {
		id: gridDelegate

		Item {
			width: gridView.cellWidth
			height: gridView.cellHeight

			property bool isClicked: false
			property string completeFileName: name
			property bool isDir: (type === "folder") ? true : false

			MouseArea {
				width: parent.width
				height: parent.height
				onClicked: {
					gridView.currentIndex = index
					isClicked = !isClicked
				}
				onDoubleClicked: {
					gridView.currentIndex = index
					switch (type) {
					case "video":
						Settings.mediaPlayerFileType = "video"
						Settings.videoFileMediaLibrary = mediaDir + "/" + name
						Settings.loader3.source = "qrc:/src/medialibrary/VideoPlayer.qml"
						//Settings.loaderNewWindow.source = "qrc:/src/medialibrary/VideoPlayer.qml"
                        Settings.loaderNewWindow.visible = true
                        break
                    case "audio":
						Settings.mediaPlayerFileType = "audio"
						Settings.videoFileMediaLibrary = mediaDir + "/" + name
						Settings.loader3.source = "qrc:/src/medialibrary/VideoPlayer.qml"
						//Settings.loaderNewWindow.source = "qrc:/src/medialibrary/VideoPlayer.qml"
                        Settings.loaderNewWindow.visible = true
                        break
					case "powerpoint":
						fileManager.startProgram("powerpoint",
												 mediaDir + "/" + name)
						break
					case "excel":
						fileManager.startProgram("excel", mediaDir + "/" + name)
						break
					case "word":
						fileManager.startProgram("word", mediaDir + "/" + name)
						break
					case "pdf":
						Settings.pdfFileMediaLibrary = mediaDir + "/" + name
                        //Settings.loader3.source = "qrc:/src/medialibrary/PdfView.qml"
                        Settings.loaderNewWindow.source = "qrc:/src/medialibrary/PdfView.qml"
                        Settings.loaderNewWindow.visible = true
                        //fileManager.startProgram("pdf", mediaDir + "/" + name);
						break
					case "image":
						/*Settings.screenshotMediaLibrary = "file:" + mediaDir + "/" + name
						Settings.loader3.source = "qrc:/src/screenshots/ScreenshotView.qml"
						//Settings.loaderNewWindow.source = "qrc:/src/screenshots/ScreenshotView.qml"
						Settings.loaderNewWindow.visible = true*/

						Settings.screenshotPresentation = "file:" + mediaDir + "/" + name
						Settings.screenshotMediaLibrary = "file:" + mediaDir + "/" + name
						DVAGLogger.log("Settings.screenshotPresentation = " + Settings.screenshotPresentation)
						Settings.loaderNewWindow.source = "qrc:/src/screenshots/ScreenshotView.qml"
						Settings.loaderNewWindow.visible = true
                        break
					default:
						break
					}
				}
			}

			Column {
                width: parent.width
                height: parent.height
                spacing: height / 15
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
                padding: 5


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
                    height: parent.height / 2 - 25
                    font.pointSize: 10
                    font.family: Settings.defaultFont
                    text: QmlFileManager.shortenFilename(completeFileName, width - 25, height,font.pointSize)
                    leftPadding: 10
                    rightPadding: 10
                    color: "black"
					anchors.horizontalCenter: parent.horizontalCenter
                    wrapMode: Text.WrapAnywhere
                    horizontalAlignment: Text.AlignHCenter
                    /*verticalAlignment: (isClicked
                                        && (text.paintedHeight
                                            > text.height)) ? Text.AlignBottom : Text.AlignTop*/
                    verticalAlignment: Text.AlignTop
				}
			}
		}
	}

    onOverviewClicked: {
        Settings.loaderNewWindow.visible = false
        Settings.loaderNewWindow.source = ""
    }

}
