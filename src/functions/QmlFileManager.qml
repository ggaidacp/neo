pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.11
import FileManager 1.0
import DVAGLogger 1.0

QtObject {
	id: qmlFileManager

	property FileManager fileManager: FileManager {}

	property string fileName
	property string fileType

	// Counter
	property int i: 0

    function pauseVideo(webview) {
            webview.runJavaScript(`
                (function() {
                    var video = document.querySelector('video');
                    if (video && !video.paused) {
                        video.pause();
                    }
                })();
            `);
    }
    function shortenFilename(filename, boxWidth, boxHeight, pointSize) {
            // Maximale Anzahl an Zeichen pro Zeile (Schätzung)
       // DVAGLogger.log(filename + " wird untersucht ...")
            var charsPerLine = Math.floor(boxWidth / (pointSize * 0.6));  // Schätzung für die Zeichenbreite
            var maxLines = Math.floor(boxHeight / (pointSize * 1.5));     // Schätzung für die Zeilenhöhe
            //DVAGLogger.log("************* " + filename + " width = " + boxWidth + " height = " + boxHeight + "chperline = " + charsPerLine + " maxline = " + maxLines)
            // Wenn der gesamte Text in das Textfeld passt, geben wir ihn direkt zurück
            if (filename.length <= (charsPerLine) * (maxLines)) {
               // DVAGLogger.log(filename + " passt rein")
                return filename;
            }

            // Andernfalls den Text kürzen und mit "..." abschließen

            var shortenedName = filename.substring(0, charsPerLine * maxLines - 6);  // Kürzen des Dateinamens
            //DVAGLogger.log(shortenedName + " passt geshorted rein")
            return shortenedName + "...";
    }

    // Fills the input fileModel with files from the input dir
	// With clear
	function getFiles(selectedDir, fileModel) {
		var files = fileManager.getSupportedFilesInDir(selectedDir)
		fileModel.clear()
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			fileType = fileManager.getSupportedFileType(
						fileManager.getMimeType(fileName, selectedDir))
			// Remove files of not supported file types
			if (fileName !== "" && fileType !== "") {
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": selectedDir
								 })
			}
		}
		return fileModel
	}

	// Adds files from the input dir to the input fileModel
	// No clear
	function addFiles(selectedDir, fileModel) {
		var files = fileManager.getSupportedFilesInDir(selectedDir)
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			fileType = fileManager.getSupportedFileType(
						fileManager.getMimeType(fileName, selectedDir))
			// Remove files of not supported file types
			if (fileName !== "" && fileType !== "") {
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": selectedDir
								 })
			}
		}
		return fileModel
	}

	// Fills the input fileModel with files from the input dir
	// With clear
	function getFilesWithoutFolders(selectedDir, fileModel) {
		var files = fileManager.getSupportedFilesInDir(selectedDir)
		fileModel.clear()
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			fileType = fileManager.getSupportedFileType(
						fileManager.getMimeType(fileName, selectedDir))
			// Remove files of not supported file types
			if (fileName !== "" && fileType !== "" && fileType !== "folder") {
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": selectedDir
								 })
			}
		}
		return fileModel
	}

	// Fills the input fileModel with files from the input dir, sorted by sortOrder
	// With clear
	function getFilesSorted(selectedDir, fileModel, sortOrder) {
		var files = fileManager.getSupportedFilesInDir(selectedDir, sortOrder)
		fileModel.clear()
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			// Remove files of not supported file types and folders
			if (fileName !== "" && !fileManager.isDir(fileName, selectedDir)) {
				fileModel.append({
									 "name": fileName
								 })
			}
		}
	}

	// Fills the input fileModel with images from the input dir
	// With clear
	function getImages(selectedDir, fileModel) {
		var files = fileManager.getSupportedFilesInDir(selectedDir)
		fileModel.clear()
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			fileType = fileManager.getSupportedFileType(
						fileManager.getMimeType(fileName, selectedDir))
			// Remove files of not supported file types
			if (fileName !== "" && fileType === "image") {
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": selectedDir
								 })
			}
		}
		return fileModel
	}

	// Adds images from the input dir to the input fileModel
	// No clear
	function addImages(selectedDir, fileModel) {
		var files = fileManager.getSupportedFilesInDir(selectedDir)
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			fileType = fileManager.getSupportedFileType(
						fileManager.getMimeType(fileName, selectedDir))
			// Remove files of not supported file types
			if (fileName !== "" && fileType === "image") {
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": selectedDir
								 })
			}
		}
		return fileModel
	}

	// Fills the input fileModel with videos from the input dir
	// With clear
	function getVideos(selectedDir, fileModel) {
		var files = fileManager.getSupportedFilesInDir(selectedDir)
		fileModel.clear()
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			fileType = fileManager.getSupportedFileType(
						fileManager.getMimeType(fileName, selectedDir))
			// Remove files of not supported file types
			if (fileName !== "" && fileType === "video") {
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": selectedDir
								 })
			}
		}
		return fileModel
	}

	// Adds videos from the input dir to the input fileModel
	// No clear
	function addVideos(selectedDir, fileModel) {
		var files = fileManager.getSupportedFilesInDir(selectedDir)
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			fileType = fileManager.getSupportedFileType(
						fileManager.getMimeType(fileName, selectedDir))
			// Remove files of not supported file types
			if (fileName !== "" && fileType === "video") {
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": selectedDir
								 })
			}
		}
		return fileModel
	}

	// Fills the input fileModel with powerpoints from the input dir
	// With clear
	function getPowerpoints(selectedDir, fileModel) {
		var files = fileManager.getSupportedFilesInDir(selectedDir)
		fileModel.clear()
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			fileType = fileManager.getSupportedFileType(
						fileManager.getMimeType(fileName, selectedDir))
			// Remove files of not supported file types
			if (fileName !== "" && fileType === "powerpoint") {
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": selectedDir
								 })
			}
		}
		return fileModel
	}

	// Adds powerpoints from the input dir to the input fileModel
	// No clear
	function addPowerpoints(selectedDir, fileModel) {
		var files = fileManager.getSupportedFilesInDir(selectedDir)
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			fileType = fileManager.getSupportedFileType(
						fileManager.getMimeType(fileName, selectedDir))
			// Remove files of not supported file types
			if (fileName !== "" && fileType === "powerpoint") {
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": selectedDir
								 })
			}
		}
		return fileModel
	}

	// Fills the input fileModel with documents(pdf, word, excel) from the input dir
	// With clear
	function getDocuments(selectedDir, fileModel) {
		var files = fileManager.getSupportedFilesInDir(selectedDir)
		fileModel.clear()
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			fileType = fileManager.getSupportedFileType(
						fileManager.getMimeType(fileName, selectedDir))
			// Remove files of not supported file types
			if (fileName !== "" && (fileType === "pdf" || fileType === "word"
									|| fileType === "excel")) {
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": selectedDir
								 })
			}
		}
		return fileModel
	}

	// Adds documents(pdf, word, excel) from the input dir to the input fileModel
	// No clear
	function addDocuments(selectedDir, fileModel) {
		var files = fileManager.getSupportedFilesInDir(selectedDir)
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			fileType = fileManager.getSupportedFileType(
						fileManager.getMimeType(fileName, selectedDir))
			// Remove files of not supported file types
			if (fileName !== "" && (fileType === "pdf" || fileType === "word"
									|| fileType === "excel")) {
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": selectedDir
								 })
			}
		}
		return fileModel
	}

	// Fills the input fileModel with audio-files from the input dir
	// With clear
	function getAudio(selectedDir, fileModel) {
		var files = fileManager.getSupportedFilesInDir(selectedDir)
		fileModel.clear()
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			fileType = fileManager.getSupportedFileType(
						fileManager.getMimeType(fileName, selectedDir))
			// Remove files of not supported file types
			if (fileName !== "" && fileType === "audio") {
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": selectedDir
								 })
			}
		}
		return fileModel
	}

	// Adds audio-files from the input dir to the input fileModel
	// No clear
	function addAudio(selectedDir, fileModel) {
		var files = fileManager.getSupportedFilesInDir(selectedDir)
		for (i = 0; i < files.length; i++) {
			fileName = files[i]
			fileType = fileManager.getSupportedFileType(
						fileManager.getMimeType(fileName, selectedDir))
			// Remove files of not supported file types
			if (fileName !== "" && fileType === "audio") {
				fileModel.append({
									 "name": fileName,
									 "type": fileType,
									 "path": selectedDir
								 })
			}
		}
		return fileModel
	}

	// Searches for files in the input dir and fills the input fileModel with them
	// With clear
	function getSearchResults(keyword, selectedDir, fileModel) {
		if (keyword !== "") {
			var searchResults = fileManager.searchInDir(keyword, selectedDir)
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
		}
		return fileModel
	}

	// Searches for files in the input dir and adds them to the input fileModel
	// No clear
	function addSearchResults(keyword, selectedDir, fileModel) {
		if (keyword !== "") {
			var searchResults = fileManager.searchInDir(keyword, selectedDir)
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
		}
		return fileModel
	}

	function getVolumes(volumeModel) {
		volumeModel.clear()
		var volumes = fileManager.getSupportedVolumes()
		for (i = 0; i < volumes.length; i++) {
			volumeModel.append({
								   "name": volumes[i]
							   })
		}
		return volumeModel
	}
}
