import QtQuick 2.15
import QtQuick.Controls 2.15
import "../settings"
import "../functions"
import FileManager 1.0

DavLibraryForm {

	property alias fileModel: fileModel
	// Stores the delegate for the gridView
	property alias gridDelegate: gridDelegate

	property string fileName
	property string fileType

	property string davDir

	// Trigger to indicate if search results are shown (used by buttonBack)
	property bool searchResultsShown: false
	// Counter
	property int i: 0

	Component.onCompleted: {
		switch (Settings.davNumber) {
		case 1:
			davDir = fileManager.getExistenzgruenderDir()
			headerText = "Existenzgründer"
			break
		case 2:
			davDir = fileManager.getAusbildungDir()
			headerText = "Ausbildung"
			break
		case 3:
			davDir = fileManager.getWeiterbildungDir()
			headerText = "Weiterbildung"
			break
		case 4:
			davDir = fileManager.getFuehrungsausbildungDir()
			headerText = "Führungsausbildung"
			break
		default:
			break
		}
		getFilteredFiles()
	}

	onOverviewClicked: {
		Settings.loader2.source = "qrc:/src/dav/Dav.qml"
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
							fileManager.getMimeType(fileName, davDir))
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": searchResults[i + 1]
								 })
			}
			gridView.model = fileModel
			// Reset the busy state of the searchField
			busyIndicator.visible = false
			searchField.enabled = true
			buttonSearchStart.enabled = true
		}
	}

	// Stores the files/folders in a dir
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
	buttonVideos.onClicked: {
		getFilteredFiles()
		searchField.text = ""
	}

	// Powerpoints Button
	buttonPowerpoints.onClicked: {
		getFilteredFiles()
		searchField.text = ""
	}

	// Documents Button
	buttonDocuments.onClicked: {
		getFilteredFiles()
		searchField.text = ""
	}

	// Entertainment Button
	buttonEntertainment.onClicked: {
		getFilteredFiles()
		searchField.text = ""
	}


	/*
	  *
	  * Footer Right
	  *
	*/
	buttonSearch.onClicked: {
		// Show the textfield
		searchField.visible = !searchField.visible
	}

	buttonSearchStart.onClicked: {
		busyIndicator.visible = true
		searchField.enabled = false
		buttonSearchStart.enabled = false
		fileManager.searchInDirThread(searchField.text, davDir)
		searchResultsShown = true
		buttonVideos.isClicked = false
		buttonPowerpoints.isClicked = false
		buttonDocuments.isClicked = false
		buttonEntertainment.isClicked = false
	}
	buttonSearchStart.onPressed: {
		buttonSearchStartIcon.source = "qrc:/images/buttons/search_arrow_gold.png"
	}
	buttonSearchStart.onReleased: {
		buttonSearchStartIcon.source = "qrc:/images/buttons/search_arrow.png"
	}


	/*
	  *
	  * Functions
	  *
	*/
	// Fills the fileModel with files depending on the active filters
	function getFilteredFiles() {
		if (!buttonVideos.isClicked && !buttonPowerpoints.isClicked
				&& !buttonDocuments.isClicked
				&& !buttonEntertainment.isClicked) {
			QmlFileManager.getFilesWithoutFolders(davDir, fileModel)

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
						Settings.videoFileDav = davDir + "/" + name
						Settings.loader2.source = "qrc:/src/medialibrary/VideoPlayer.qml"
						break
					case "audio":
						Settings.mediaPlayerFileType = "audio"
						Settings.videoFileDav = davDir + "/" + name
						Settings.loader2.source = "qrc:/src/medialibrary/VideoPlayer.qml"
						break
					case "powerpoint":
						fileManager.startProgram("powerpoint",
												 davDir + "/" + name)
						break
					case "excel":
						fileManager.startProgram("excel", davDir + "/" + name)
						break
					case "word":
						fileManager.startProgram("word", davDir + "/" + name)
						break
					case "pdf":
						Settings.pdfFileDav = davDir + "/" + name
						Settings.loader2.source = "qrc:/src/medialibrary/PdfView.qml"
						//fileManager.startProgram("pdf", davDir + "/" + name);
						break
					case "image":
						Settings.screenshotDav = "file:" + davDir + "/" + name
						Settings.loader2.source = "qrc:/src/screenshots/ScreenshotView.qml"
						break
					default:
						break
					}
				}
			}

			Column {
				width: (parent.width / 10) * 9
				height: (parent.height / 10) * 9
				spacing: height / 7
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter

				Image {
					id: img
					width: parent.width
					height: (parent.height / 7) * 4
					source: "qrc:/images/fileicons/" + type + ".png"
					fillMode: Image.PreserveAspectFit
					mipmap: true
				}

				Text {
					id: text
					width: parent.width
					height: (parent.height / 7) * 2
					text: Settings.fileMetaData.basename2Pretty(
							  completeFileName)
					font.pointSize: 10
					color: "black"
					wrapMode: Text.WrapAtWordBoundaryOrAnywhere
					horizontalAlignment: Text.AlignHCenter
					verticalAlignment: (isClicked
										&& (text.paintedHeight
											> text.height)) ? Text.AlignBottom : Text.AlignTop
					clip: !isClicked
					anchors.horizontalCenter: parent.horizontalCenter
				}
			}
		}
	}
}
