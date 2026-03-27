import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"
import "../functions"
import FileManager 1.0
import DVAGLogger 1.0

UsbImportForm {
	property alias fileModel: fileModel
	property alias volumeModel: volumeModel

	// Stores the delegate for the gridView
	property alias gridDelegate: gridDelegate

	// Stores the history of folder for the navigation
	property var history: []
	// Stores the current position in the history
	property int historyCounter: 0

	property string fileName
	property string fileType
    property bool finalCopyProcess : false

	property string importDir: fileManager.getImportDir()

	// Stores the path of the currently selected dir
	property string selectedDir
    property string selectedDirHeader


	// Stores the currentIndex of the gridView to reset the position to the original position
	property int gridCurrentIndex
	// Trigger to indicate if search results are shown
	property bool searchResultsShown: false

	// Counter for the popUpWindow after the import is done (how many files were imported)
	property int copiedFiles: 0
	// Counter
	property int i

	Component.onCompleted: {
		// Load the volumes into the volumeModel
		QmlFileManager.getVolumes(volumeModel)
        root.enabled = !(popUpWindowVolumes.visible || popUpWindowImportDone.visible || popUpWindowImportOverride.visible)
        selectedDir = "";
        fileModel.clear();
    }
	onVisibleChanged: {
		if (visible) Settings.isPresentationMode = presentationModeVisibility
	}
    popUpWindowVolumes.onVisibleChanged: {
        if (!popUpWindowVolumes.visible) {
            showSelectedDirectory();
        }
    }

    function showSelectedDirectory() {
        if (volumeModel.get(popUpWindowVolumes.currentIndex) !== undefined) {
            selectedDir = volumeModel.get(
                        popUpWindowVolumes.currentIndex).name.substr(0, 2) // e.g. "C:"
            selectedDirHeader = volumeModel.get(
                        popUpWindowVolumes.currentIndex).name // e.g. "C:/myusbstick"
        }
        showSelectedDirectoryWithoutReset()
    }

    function showSelectedDirectoryWithoutReset() {
        history[0] = selectedDir
        QmlFileManager.getFiles(selectedDir, fileModel)
        // Set the headerText
        headerText = selectedDirHeader
        // Reset the scrollView to the top
        //scrollBar.position = 0
    }

    FileManager {
		id: fileManager
		onSearchFinished: {
            DVAGLogger.log("********** GGI On Search finished")
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
            //buttonSearchStart.enabled = true
		}
        onCopyFinished: {
            if (finalCopyProcess) {
                busyIndicator.visible = false
                return
            }

            DVAGLogger.log("********* COPY FILES FINISHED ************" )
            copiedFiles = fileManager.getCopiedFiles()
            busyIndicator.visible = false
            gridView.currentIndex = gridCurrentIndex

            // Show the right popUpWindow and text depending on the amount of copied and not copied files
            var notCopiedFiles = fileManager.getNotCopiedFiles()
            DVAGLogger.log("********* Not Copied Files Counter = " + notCopiedFiles.length)
            if (copiedFiles > 0 || notCopiedFiles.length > 0) {
                if (notCopiedFiles.length > 0) {
                    // Because GERMAN, thats why
                    if (copiedFiles === 1) {
                        // Because GERMAN, thats why
                        if (notCopiedFiles.length === 1) {
                            // Change the text of the popUpWindowImportDone to include the final counter
                            popUpWindowImportOverride.text = copiedFiles
                                    + " Dateien wurden importiert. " + notCopiedFiles.length
                                    + " Dateien werden überschrieben. Dateien überschreiben?"
                        } else {
                            // Change the text of the popUpWindowImportDone to include the final counter
                            popUpWindowImportOverride.text = copiedFiles
                                    + " Datei wurde importiert. " + notCopiedFiles.length
                                    + " Dateien werden überschrieben. Dateien überschreiben?"
                        }
                    } else {
                        // Because GERMAN, thats why
                        if (notCopiedFiles.length === 1) {
                            // Change the text of the popUpWindowImportDone to include the final counter
                            popUpWindowImportOverride.text = copiedFiles
                                    + " Datei wurde importiert. " + notCopiedFiles.length
                                    + " Datei wird überschrieben. Datei überschreiben?"
                        } else {
                            // Change the text of the popUpWindowImportDone to include the final counter
                            popUpWindowImportOverride.text = copiedFiles
                                    + " Dateien wurden importiert. " + notCopiedFiles.length
                                    + " Dateien werden überschrieben. Dateien überschreiben?"
                        }
                    }
                    popUpWindowImportOverride.visible = true
                } else {
                    // Because GERMAN, thats why
                    if (copiedFiles === 1) {
                        // Change the text of the popUpWindowImportDone to include the final counter
                        popUpWindowImportDone.text = copiedFiles + " Datei wurde importiert."
                    } else {
                        // Change the text of the popUpWindowImportDone to include the final counter
                        popUpWindowImportDone.text = copiedFiles + " Dateien wurden importiert."
                    }
                    popUpWindowImportDone.visible = true
                }
            } else {
                popUpWindowImportDone.text = "Bitte wählen Sie eine Datei zum Importieren aus."
                popUpWindowImportDone.visible = true
            }

            showSelectedDirectoryWithoutReset();
        }

	}


	// Stores the files/folders in a dir
    ListModel {
        id: fileModel
    }
    ListModel {
        id: fileModelEmpty
    }

	// Stores the volume list
	ListModel {
		id: volumeModel
	}


	/*
	  *
	  * Header
	  *
	*/
	onOverviewClicked: {
		// Reset the scrollView to the top
        //scrollBar.position = 0
		fileModel.clear()
		// Reset the headerText
		headerText = "USB Import"
		// Show the volume selection popUpWindow
		popUpWindowVolumes.visible = true
	}


	/*
	  *
	  * Footer Left
	  *
	*/
	// Navigation Button Back
	buttonBack.onClicked: {
		if (searchResultsShown) {
			// Reset the search results
			QmlFileManager.getFiles(selectedDir, fileModel)
			searchResultsShown = false
		} else {
			// The volume path is at least 4 digits long
			if (selectedDir.length > 3) {
				historyCounter--
				// Cut off the current folder from the path
				selectedDir = selectedDir.substr(0,
												 selectedDir.lastIndexOf("/"))
				QmlFileManager.getFiles(selectedDir, fileModel)
				// Set headerText to the current Path
				headerText = selectedDir
				// Reset the scrollView to the top
				//scrollBar.position = 0
			}
		}
	}
	buttonBack.onPressed: {
		buttonBackIcon.source = "qrc:/images/buttons/back_gold.png"
	}
	buttonBack.onReleased: {
        buttonBackIcon.source = "qrc:/images/buttons/back.png"
	}

	// Navigation Button Forward
	buttonForward.onClicked: {
		if (searchResultsShown) {
			// Reset the search results
			QmlFileManager.getFiles(selectedDir, fileModel)
			searchResultsShown = false
		} else {
			if (historyCounter + 1 <= history.length - 1) {
				historyCounter++
				// Get the folder from the history
				selectedDir = history[historyCounter]
				QmlFileManager.getFiles(selectedDir, fileModel)
				// Set headerText to the current Path
				headerText = selectedDir
				// Reset the scrollView to the top
				//scrollBar.position = 0
			}
		}
	}
	buttonForward.onPressed: {
		buttonForwardIcon.source = "qrc:/images/buttons/forward_gold.png"
	}
	buttonForward.onReleased: {
        buttonForwardIcon.source = "qrc:/images/buttons/forward.png"
	}

	// Import Button
	buttonImport.onClicked: {
        busyIndicator.visible = true
        busyIndicator.running = true
        finalCopyProcess = false
        DVAGLogger.log("********** - Busy Indicator visible and running *****************")
		// Store the currentIndex of the gridView
		gridCurrentIndex = gridView.currentIndex
		// Reset the counter of copied files
		copiedFiles = 0
		// Reset the list of notCopiedFiles
		fileManager.clearNotCopiedFiles()
		// Check which items in the gridView are selected
        DVAGLogger.log("********** - VOR SCHLEIFE  *****************")
        var filenameList = []
        for (var i = 0; i < gridView.count; i++) {
           // Extrahiere die "name"-Eigenschaft der Items
           gridView.currentIndex = i
           if (gridView.currentItem.isClicked) {
                DVAGLogger.log("********** - IN SCHLEIFE  ***************** " + fileModel.get(i).name)
                filenameList.push(fileModel.get(i).name)
           }
        }
        fileManager.copyFileThread(filenameList,selectedDir, importDir, false)
	}


	/*
	  *
	  * Footer Right
	  *
	*/
    function startSearch() {
        busyIndicator.visible = true
        busyIndicator.running = true
        localsearchField.enabled = false
        fileManager.searchInDirThread(localsearchField.text, selectedDir)
        searchResultsShown = true
    }
    localsearchField.onEnterPressed:  {
        startSearch()
    }
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

    buttonSearchIconInside.onClicked : {
        startSearch()
    }

	/*
	  *
	  * PopUpWindow for the volume selection
	  *
	*/

	popUpWindowVolumes.onReloadClicked: {
        busyIndicator.visible = true
		QmlFileManager.getVolumes(volumeModel)
        busyIndicator.visible = false
    }


	/*
	  *
	  * PopUpWindow for the completed import when override is necessary
	  *
	*/

	// Yes Button
	popUpWindowImportOverride.onButton1Clicked: {
        busyIndicator.visible = true

		var files = fileManager.getNotCopiedFiles()

        fileManager.copyFileThread(files,selectedDir, importDir, true)
        finalCopyProcess = true

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
					if (isDir) {
						selectedDir += "/" + name
						saveToHistory()
						QmlFileManager.getFiles(selectedDir, fileModel)
						// Set headerText to the current Path
						headerText = selectedDir
						gridView.currentIndex = 0
					}
				}
			}

			Column {
                width: parent.width
                height: parent.height
                spacing: 8
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter

				Image {
                    id: img
                    width: parent.width / 2 - 10
                    height: parent.height / 2 - 20
					source: isClicked ? ("qrc:/images/fileicons/" + type
										 + "_gold.png") : ("qrc:/images/fileicons/" + type + ".png")
					fillMode: Image.PreserveAspectFit
					mipmap: true
                    anchors.horizontalCenter: parent.horizontalCenter
				}

				Text {
                    id: text
                    width: parent.width
                    height: parent.height / 2 - 25
                    font.pointSize: 10
                    color: "black"
                    font.family: Settings.defaultFont
                    text: QmlFileManager.shortenFilename(completeFileName, width - 25, height - 20,font.pointSize)
                    leftPadding: 10
                    rightPadding: 10
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignTop
                    clip: false
                    wrapMode: Text.WrapAnywhere
                    anchors.horizontalCenter: parent.horizontalCenter
				}

			}
		}
	}
}
