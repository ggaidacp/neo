import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"
import "../functions"
import "../templates"
import FileManager 1.0
import DVAGLogger 1.0

ExportForm {
	id: exportForm
	property alias fileModel: fileModel
	property alias volumeModel: volumeModel
	property alias exportModel: exportModel

	// Stores the delegates for the gridView
	property alias gridDelegate: gridDelegate
	// Stores the delegate for the exportList
	property alias exportListDelegate: exportListDelegate

	// Stores the history of folderpaths for the navigation
	property var history: []
	// Stores the current position in the history
	property int historyCounter: 0

	property string exportDir
	property string exportVolume

	// Stores the path of the currently selected dir
	property string selectedDir

	// Trigger to indicate if search results are shown
	property bool searchResultsShown: false

	// Counter for the popUpWindow after the import is done (how many files were imported)
	property int copiedFiles: 0
	// Counter
	property int i

	function updateDrivesList() {
		QmlFileManager.getVolumes(volumeModel)
	}

	onVisibleChanged: {
		if (visible) Settings.isPresentationMode = presentationModeVisibility
	}


	function init() {
		// Load the volumes into the volumeModel
		DVAGLogger.log("**** entering export init ********")
		updateDrivesList()
		popUpWindowVolumes.reloadClicked.connect(updateDrivesList)
		popUpWindowVolumes.visible = true
		gridView.delegate = gridDelegate



		if (Settings.isComposingEmail) {
			// Reset the delegate
			gridView.delegate = gridDelegate
			selectedDir = fileManager.getStoryboardDir()
			QmlFileManager.getFiles(selectedDir, fileModel)
			// Reset the history
			history = history.slice(0, 0)
			historyCounter = 0

			buttonPresentation.isClicked = true
			//			buttonDav.isClicked = false
			buttonMedialibrary.isClicked = false
			buttonOnlinePlatform.isClicked = false
			buttonScreenshots.isClicked = false

			root.enabled = true
			popUpWindowVolumes.visible = false
		}

		buttonPresentation.checked = true
		buttonPresentation.checkedChanged()
		//showPresentationDir()
	}

	Component.onCompleted: {
		Settings.exportForm = exportForm
		//Settings.contentArea = content
		init()
	}

	// second screen
	Connections {
		target: Settings.embeddedWindow
		onCurrentIndexChanged: {
			if (Settings.embeddedWindow.currentIndex === 10) {
				// Used for the second screen view
				//Settings.contentArea = content
			}
		}
	}

	FileManager {
		id: fileManager
	}

	// Stores the files/folders in a dir
	ListModel {
		id: fileModel
	}

	// Stores the volume list
	ListModel {
		id: volumeModel
	}

	// Stores the files for the export
	ListModel {
		id: exportModel
	}


	/*
	  *
	  * Header
	  *
	*/
	onOverviewClicked: {
		if (Settings.isComposingEmail) {
			Settings.embeddedWindow.currentIndex = 11
			Settings.lastIndex = 11
			Settings.contentArea = Settings.emailForm
		} else {
			// Reset the delegate
			gridView.delegate = gridDelegate
			root.enabled = false
			buttonPresentation.clicked()
			buttonPresentation.checked = true
			// Show the volume selection popUpWindow
			popUpWindowVolumes.visible = true
		}
	}


	/*
	  *
	  * Content
	  *
	*/
	/*dragTarget.onDragChanged: (drag) => {
								DVAGLogger.log("************* On Dropped Changed *********")
	}*/

	// Button Export
	buttonExport.onClicked: {
		if (Settings.isComposingEmail) {
			var tempDir = fileManager.getTempDir()

			for (i = 0; i < exportModel.count; i++) {
				if (exportModel.get(i).type === "web") {
					// "Web" files have to be created
					fileManager.createUrlFile(exportModel.get(i).name, tempDir,
											  exportModel.get(i).path)
				}
			}
			for (i = 0; i < exportModel.count; i++) {
				Settings.attachmentsModel.append(exportModel.get(i))
			}
			exportModel.clear()
			Settings.embeddedWindow.currentIndex = 11
			Settings.lastIndex = 10
			Settings.contentArea = Settings.emailForm
			return
		}

		exportDir = fileManager.getExportDir(exportVolume)
		// Reset the counter of copied files
		copiedFiles = 0
		// Reset the list of notCopiedFiles
		fileManager.clearNotCopiedFiles()
		// Check which items in the gridView are selected
		for (i = 0; i < exportModel.count; i++) {
			if (exportModel.get(i).type !== "web") {
				// Copy the file
				copiedFiles += fileManager.copyFile(exportModel.get(i).name,
													exportModel.get(i).path,
													exportDir)
			} else {
				// "Web" files have to be created
				fileManager.createUrlFile(exportModel.get(i).name, exportDir,
										  exportModel.get(i).path)
				// Increase the copiedFiles
				copiedFiles++
			}
		}

		// Show the right popUpWindow and text depending on the amount of copied and not copied files
		var notCopiedFiles = fileManager.getNotCopiedFiles()
		if (copiedFiles > 0 || notCopiedFiles.length > 0) {
			if (notCopiedFiles.length > 0) {
				// Because GERMAN, thats why
				if (copiedFiles === 1) {
					// Because GERMAN, thats why
					if (notCopiedFiles.length === 1) {
						// Change the text of the popUpWindowExportOverride to include the final counter
						popUpWindowExportOverride.text = copiedFiles
								+ " Datei wurde exportiert. " + notCopiedFiles.length
								+ " Datei wird überschrieben. Datei überschreiben?"
					} else {
						// Change the text of the popUpWindowExportOverride to include the final counter
						popUpWindowExportOverride.text = copiedFiles
								+ " Dateien werden exportiert. " + notCopiedFiles.length
								+ " Dateien werden überschrieben. Dateien überschreiben?"
					}
				} else {
					// Because GERMAN, thats why
					if (notCopiedFiles.length === 1) {
						// Change the text of the popUpWindowExportOverride to include the final counter
						popUpWindowExportOverride.text = copiedFiles
								+ " Datei wurde exportiert. " + notCopiedFiles.length
								+ " Datei wird überschrieben. Datei überschreiben?"
					} else {
						// Change the text of the popUpWindowExportOverride to include the final counter
						popUpWindowExportOverride.text = copiedFiles
								+ " Dateien wurden exportiert. " + notCopiedFiles.length
								+ " Dateien werden überschrieben. Dateien überschreiben?"
					}
				}
				popUpWindowExportOverride.visible = true
			} else {
				// Because GERMAN, thats why
				if (copiedFiles === 1) {
					// Change the text of the popUpWindowExportDone to include the final counter
					popUpWindowExportDone.text = copiedFiles + " Datei wurde exportiert."
				} else {
					// Change the text of the popUpWindowExportDone to include the final counter
					popUpWindowExportDone.text = copiedFiles + " Dateien wurden exportiert."
				}
				popUpWindowExportDone.visible = true
			}
		} else {
			popUpWindowExportDone.text = "Bitte wählen Sie eine Datei zum Exportieren aus."
			popUpWindowExportDone.visible = true
		}
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
			// Reset the localsearchField
			localsearchField.text = ""
		} else {
			// Check for the 4 root folders; Don't go further back
			if (selectedDir !== fileManager.getStoryboardDir()
					&& selectedDir !== fileManager.getDavDir()
					&& selectedDir !== fileManager.getMediaDir()
					&& selectedDir !== fileManager.getScreenshotDir()) {

				historyCounter--
				// Cut off the current folder from the path
				selectedDir = selectedDir.substr(0,
												 selectedDir.lastIndexOf("/"))
				QmlFileManager.getFiles(selectedDir, fileModel)
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
			// Reset the localsearchField
			localsearchField.text = ""
		} else {
			if (historyCounter + 1 <= history.length - 1) {
				historyCounter++
				// Get the folder from the history
				selectedDir = history[historyCounter]
				QmlFileManager.getFiles(selectedDir, fileModel)
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


	/*
	  *
	  * Footer Center
	  *
	*/

	// Button Presentation
	function showPresentationDir() {
		DVAGLogger.log("Präsentationen vom FS laden")
		// Reset the delegate
		gridView.delegate = gridDelegate
		selectedDir = fileManager.getStoryboardDir()
		QmlFileManager.getFiles(selectedDir, fileModel)
		// Reset the history
		history = history.slice(0, 0)
		historyCounter = 0
	}

	buttonPresentation.onClicked: {
		//buttonPresentation.checked = !buttonPresentation.checked
		if (buttonPresentation.checked) {
			showPresentationDir()
		}
	}




	// Button MediaLibrary
	function showMedialibraryDir() {
		DVAGLogger.log("Medien vom FS laden")
		// Reset the delegate
		gridView.delegate = gridDelegate
		selectedDir = fileManager.getMediaDir()
		QmlFileManager.getFiles(selectedDir, fileModel)
		// Reset the history
		history = history.slice(0, 0)
		historyCounter = 0
	}

	buttonMedialibrary.onClicked: {
		//buttonMedialibrary.checked = !buttonMedialibrary.checked
		if (buttonMedialibrary.checked) {
			showMedialibraryDir()
		}
	}

	// Button Online Platform
	function showOnlinePlarformDir() {
		DVAGLogger.log("online medien vom FS laden")
		// Reset the delegate
		gridView.delegate = gridDelegate
		var onlinePlatforms = fileManager.readOnlinePlatformsJson()
		if (onlinePlatforms.length > 0) {
			fileModel.clear()
			// Stringlist [id1, name1, url1, id2, name2, url2, ...]
			for (i = 0; i < onlinePlatforms.length; i += 4) {
				var strlen = ("" + onlinePlatforms[i + 1]).length
				var name = (strlen == 0) ? onlinePlatforms[i + 2] : onlinePlatforms[i + 1];
				fileModel.append({
									 "name": name,
									 "type": "web",
									 "path": onlinePlatforms[i + 2]
								 })
			}
		}
		// Reset the history
		history = history.slice(0, 0)
		historyCounter = 0

	}

	buttonOnlinePlatform.onClicked: {
		//buttonOnlinePlatform.checked = !buttonOnlinePlatform.checked
		if (buttonOnlinePlatform.checked) {
			showOnlinePlarformDir()
		}
	}

	// Button Screenshots
	function showScreenshotsDir() {
		DVAGLogger.log("Screen shots vom FS laden")
		// Reset the delegate
		gridView.delegate = gridDelegate
		selectedDir = fileManager.getScreenshotDir()
		// Get only the images in the folder; there should be only images anyway
		QmlFileManager.getImages(selectedDir, fileModel)
		// Reset the history
		history = history.slice(0, 0)
		historyCounter = 0
	}

	buttonScreenshots.onClicked: {
		//buttonScreenshots.checked = !buttonScreenshots.checked
		if (buttonScreenshots.checked) {
			showScreenshotsDir()
		}
	}


	/*
	  *
	  * Footer Right
	  *
	*/
	property int searchfieldplaceholder : 40
	buttonlocalSearch.onClicked: {
		searchfieldrow.visible = !searchfieldrow.visible
		if (!searchfieldrow.visible) {
		   localsearchField.focus = false
		} else {
		   localsearchField.focus = true
		   localsearchField.forceActiveFocus()
		}

	}


	localsearchField.onEnterPressed: {
	   startSearch()
	}
	buttonSearchIconInside.onClicked: {
	   startSearch()
	}

	function startSearch() {
		if (localsearchField.text === "" && searchResultsShown) {
			QmlFileManager.getFiles(selectedDir, fileModel)
			searchResultsShown = false
		} else {
			QmlFileManager.getSearchResults(localsearchField.text, selectedDir,
											fileModel)
			searchResultsShown = true
		}
	}


	function drvsDlgClosed() {
		exportVolume = volumeModel.get(
					popUpWindowVolumes.currentIndex).name.substr(0,
																 2) // e.g. "C:"
		// Init the export view with the mediaDir folder
		selectedDir = fileManager.getMediaDir()
		history[0] = selectedDir
		QmlFileManager.getFiles(selectedDir, fileModel)
		// Enable everything "under" the popup
		root.enabled = true
		showPresentationDir()
	}

	popUpWindowVolumes.onButtonClicked: {
		drvsDlgClosed()
	}
	popUpWindowVolumes.onCloseClicked: {
		drvsDlgClosed()
	}


	/*
	  *
	  * PopUpWindow for the completed export when override is necessary
	  *
	*/
	popUpWindowExportOverride.onCloseClicked: {
		// Enable everything "under" the popup
		root.enabled = true
	}

	// Yes Button
	popUpWindowExportOverride.onButton1Clicked: {
		var files = fileManager.getNotCopiedFiles()
		for (i = 0; i < files.length; i++) {
			fileManager.deleteFile(files[i].substr(
									   files[i].lastIndexOf("/") + 1,
									   files[i].length), exportDir)
			fileManager.copyFile(files[i].substr(files[i].lastIndexOf("/") + 1,
												 files[i].length),
								 files[i].substr(0, files[i].lastIndexOf("/")),
								 exportDir)
		}
		// Enable everything "under" the popup
		root.enabled = true
	}

	// No Button
	popUpWindowExportOverride.onButton2Clicked: {
		// Enable everything "under" the popup
		root.enabled = true
	}


	/*
	  *
	  * PopUpWindow for the completed export
	  *
	*/
	popUpWindowExportDone.onCloseClicked: {
		// Enable everything "under" the popup
		root.enabled = true
	}

	popUpWindowExportDone.onButtonClicked: {
		// Enable everything "under" the popup
		root.enabled = true
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
		// Clear old paths in the array
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
			id: itemGridDelegate
			width: gridView.cellWidth
			height: gridView.cellHeight

			property bool isClicked: false
			property string completeFileName: name
			property string iconType: type
			property string filePath: path
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
					// "Open" the folder and show the files inside
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
			}

			Column {
				id: column
				width: parent.width
				height: parent.height
				spacing: 8
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter

				Drag.active: mouseArea.drag.active

				//Drag.dragType: Drag.Automatic
				//Drag.mimeData: { "text/plain": fileModel.name }
				Drag.hotSpot.x: width / 2
				Drag.hotSpot.y: height / 2
				Drag.imageSource: "qrc:/images/fileicons/audio.png"

				/*DragHandler {
						id: handler
						onActiveChanged: if (active) {
							Drag.source = column
							Drag.hotSpot.x = parent.width/2
							Drag.hotSpot.y = parent.height/2
							//Drag.mimeData = { "text/plain": fileModel.name }

							// eigenes Drag-Bild festlegen
							Drag.imageSource = "qrc:/images/fileicons/audio.png"
						}
				}*/
				states: State {
					when: mouseArea.drag.active
					ParentChange {
						target: itemGridDelegate
						parent: contentrowwithoutsearch
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
					width: buttonScreenshots.checked ? parent.width - 6:
													   parent.width / 2 - 10
					height: buttonScreenshots.checked ? (parent.height / 7) * 4 :
														parent.height / 2 - 20
					source: buttonScreenshots.checked ? "file:/" + selectedDir + "/" + name :
														"qrc:/images/fileicons/" + type + ".png"
					fillMode: Image.PreserveAspectFit
					mipmap: true
					anchors.horizontalCenter: parent.horizontalCenter
				}

				Text {
					id: text
					width: parent.width
					height: parent.height / 2 - 30
					font.pointSize: 10
					text: QmlFileManager.shortenFilename(completeFileName, width - 20, height, font.pointSize)
					leftPadding: 10
					rightPadding: 10
					color: "black"
					wrapMode: Text.WrapAnywhere
					horizontalAlignment: Text.AlignHCenter
					/*verticalAlignment: (isClicked
										&& (text.paintedHeight
											> text.height)) ? Text.AlignBottom : Text.AlignTop*/
					verticalAlignment: Text.AlignTop
					clip: !isClicked
					anchors.horizontalCenter: parent.horizontalCenter
				}
			}
		}
	}


	dragTarget.onDropped: (drop) =>  {
			  DVAGLogger.log("************* On Dropped Begin *********")
			  // Check if the dropped item is a folder. Only files should be droppable
			  if (gridView.currentItem.iconType !== "folder") {
				  // Check if the dropped item is a "web" file
					if (gridView.currentItem.iconType !== "web") {
						exportModel.set(exportModel.count, {
										  "name": gridView.currentItem.completeFileName,
										  "type": gridView.currentItem.iconType,
										  "path": selectedDir
										  }
						)

					} else {
						dropWeb()
					}
				  DVAGLogger.log("***** Dropped Item : " + "exportModel.get(exportModel.count - 1).name" + " *********")
				  //drop.source.parent = target
				  //drop.source.destroy()
				  scrollBarExportList.position = scrollViewExport.height

			}

	}



	/*
	  *
	  * Delegate for the export listView
	  *
	*/
	Component {
		id: exportListDelegate

		MouseArea {
			width: listViewExport.width
			height: textExportList.paintedHeight + 40
			onClicked: {
				listViewExport.currentIndex = index
				DVAGLogger.log("****** ggi remove " + listViewExport.currentIndex)
				exportModel.remove(listViewExport.currentIndex)
			}

			Row {
				id: exportRow
				width: parent.width
				height: parent.height

				Image {
					width: parent.width / 5
					height: (parent.height / 5) * 4
					source: "qrc:/images/fileicons/" + type + ".png"
					fillMode: Image.PreserveAspectFit
					mipmap: true
					anchors.verticalCenter: parent.verticalCenter
				}

				Text {
					id: textExportList
					width: (parent.width / 5) * 3.5
					height: parent.height
					text: name
					font.pointSize: 12
					font.family: Settings.defaultFont
					color: "black"
					clip: true
					verticalAlignment: Text.AlignVCenter
				}

				Image {
					width: (parent.width / 5) * 0.5
					height: (parent.height / 5) * 4
					source: "qrc:/images/close.png"
					fillMode: Image.PreserveAspectFit
					mipmap: true
					anchors.verticalCenter: parent.verticalCenter
				}
			}
		}
	}
	function dropWeb() {
		// For "web" files the path is the url(filePath), e.g. "https://www.dvag.de/dvag/index.html"
		var strlen = ("" + gridView.currentItem.completeFileName).length
		var name = (strlen == 0) ? gridView.currentItem.filePath : gridView.currentItem.completeFileName;
		while (name !== name.replace("/", "_")) {
			name = name.replace("/", "_")
			DVAGLogger.log(name)
		}
		while (name !== name.replace(":", "_")) {
			name = name.replace(":", "_")
			DVAGLogger.log(name)
		}
		while (name !== name.replace("__", "_")) {
			name = name.replace("__", "_")
			DVAGLogger.log(name)
		}
		name = name.replace("http_", "")
		name = name.replace("https_", "")
		exportModel.set(exportModel.count, {
							"name": name,
							"type": gridView.currentItem.iconType,
							"path": gridView.currentItem.filePath
						})
	}
}
