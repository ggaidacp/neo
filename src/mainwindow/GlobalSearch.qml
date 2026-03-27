import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"
import "../functions"
import FileManager 1.0

GlobalSearchForm {
	property alias fileModel: fileModel

	// Stores the delegate for the gridView
	property alias gridDelegate: gridDelegate

	property string davDir: fileManager.getDavDir()
	property string mediaDir: fileManager.getMediaDir()
	property string screenshotDir: fileManager.getScreenshotDir()
	property string importDir: fileManager.getImportDir()

	// Counter
	property int i: 0

	Component.onCompleted: {
		// All buttons(filters) are initially false --> getSearchResults
		getFilteredFiles()
	}

    /* Second screen
    Connections {
        target: Settings.embeddedWindow
        onCurrentIndexChanged: {

            if (Settings.embeddedWindow.currentIndex === 3) {
                // Used for the second screen view
                Settings.contentArea = contentmedia
                DVAGLogger.log("*********** CurrentIndex = " + Settings.embeddedWindow.currentIndex)
                //Settings.contentAreaEditMode = laserPointerArea
            }
        }
    }*/

	FileManager {
		id: fileManager
		onSearchFinished: {
			var searchResults = fileManager.getSearchResults()
			fileModel.clear()
			// Stringlist [filename1, path1, filename2, path2, ...]
			for (i = 0; i < searchResults.length; i += 2) {
				fileName = searchResults[i]
				fileType = fileManager.getSupportedFileType(
							fileManager.getMimeType(fileName, davDir))
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": searchResults[i + 1]
								 })
			}
			busyIndicator.visible = false
			searchField.enabled = true
			buttonSearchStart.enabled = true

			gridView.model = fileModel
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
        //localsearchField.text = ""
    }

    // Powerpoints Button
    buttonPowerpoints.onClicked: {
        buttonPowerpoints.boxchecked = !buttonPowerpoints.boxchecked
        getFilteredFiles()
        //localsearchField.text = ""
    }

    // Documents Button
    buttonDocuments.onClicked: {
        buttonDocuments.boxchecked = !buttonDocuments.boxchecked
        getFilteredFiles()
        //localsearchField.text = ""
    }

    // Entertainment Button
    buttonEntertainment.onClicked: {
        buttonEntertainment.boxchecked = !buttonEntertainment.boxchecked
        getFilteredFiles()
        localsearchField.text = ""
    }



    /*
      *
      * Functions
      *
    */
    // Fills the fileModel with files depending on the active filters
    function getFilteredFiles() {
        if (       buttonVideos.isClicked
                && buttonPowerpoints.isClicked
                && buttonDocuments.isClicked
                && buttonEntertainment.isClicked
            ) {
            QmlFileManager.getSearchResults(Settings.searchFieldText, davDir,
                                            fileModel)
            // Adds results
            QmlFileManager.addSearchResults(Settings.searchFieldText, mediaDir,
                                            fileModel)
            // Adds results
            QmlFileManager.addSearchResults(Settings.searchFieldText,
                                            screenshotDir, fileModel)
            // Adds results
            QmlFileManager.addSearchResults(Settings.searchFieldText,
                                            importDir, fileModel)

            gridView.model = fileModel
        } else {
            filteredFileModel.clear()
            if (buttonVideos.isClicked) {
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
            if (buttonPowerpoints.isClicked) {
                for (i = 0; i < fileModel.count; i++) {
                    // Add files of supported file types
                    if (fileModel.get(i).type === "powerpoint") {
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
            if (buttonDocuments.isClicked) {
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
            }
            if (buttonEntertainment.isClicked) {
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
        }
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
						Settings.videoFileGlobalSearch = path + "/" + name
						Settings.loaderNewWindow.source = "qrc:/src/medialibrary/VideoPlayer.qml"
						Settings.loaderNewWindow.visible = true
						break
					case "audio":
						Settings.mediaPlayerFileType = "audio"
						Settings.videoFileGlobalSearch = path + "/" + name
						Settings.loaderNewWindow.source = "qrc:/src/medialibrary/VideoPlayer.qml"
						Settings.loaderNewWindow.visible = true
						break
					case "powerpoint":
						fileManager.startProgram("powerpointpresentation",
												 path + "/" + name)
						break
					case "excel":
						fileManager.startProgram("excel", path + "/" + name)
						break
					case "word":
						fileManager.startProgram("word", path + "/" + name)
						break
					case "pdf":
						Settings.pdfFileGlobalSearch = path + "/" + name
						Settings.loaderNewWindow.source = "qrc:/src/medialibrary/PdfView.qml"
						Settings.loaderNewWindow.visible = true
						//fileManager.startProgram("pdf", path + "/" + name);
						break
					case "image":
						Settings.screenshotGlobalSearch = "file:" + path + "/" + name
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
                spacing: 8
                //anchors.top: top
                anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter

				Image {
					id: img
                    width: parent.width / 2 - 10
                    height: parent.height / 2 - 20
					source: "qrc:/images/fileicons/" + type + ".png"
                    //fillMode: Image.PreserveAspectFit
                    //mipmap: true
                    anchors.horizontalCenter: parent.horizontalCenter
				}

				Text {
					id: text
                    width: parent.width
                    height: parent.height / 2 - 30
                    font.pointSize: 10
                    text: QmlFileManager.shortenFilename(
                              completeFileName, width, height,font.pointSize)
                    leftPadding: 10
                    rightPadding: 10
					color: "black"
                    clip: !isClicked
                    wrapMode: Text.WrapAnywhere
                    /*verticalAlignment: (isClicked
                                        && (text.paintedHeight
                                            > text.height)) ? Text.AlignBottom : Text.AlignTop*/
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignTop


				}
			}
		}
	}
}
