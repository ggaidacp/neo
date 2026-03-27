import QtQuick 2.11
import "../settings"

import FileManager 1.0
import DVAGLogger 1.0

ScreenshotViewForm {
	id: screenShotview
	Component.onCompleted: {
		// Used for the second screen view
		Settings.contentArea = img
		Settings.screenshotview = screenShotview

		if (Settings.loader1.visible) {
			// Set the headerText to the name of the screenshot
			headerText = Settings.screenshotPresentation.substr(
						Settings.screenshotPresentation.lastIndexOf("/") + 1,
						Settings.screenshotPresentation.length)
			// Get the img source
			img.source = Settings.screenshotPresentation
			// You should not be able to delete in this library
			//buttonDeleteIcon.visible = false
		} else if (Settings.loader2.visible) {
			// Set the headerText to the name of the screenshot
			headerText = Settings.screenshotDav.substr(
						Settings.screenshotDav.lastIndexOf("/") + 1,
						Settings.screenshotDav.length)
			// Get the img source
			img.source = Settings.screenshotDav
			// You should not be able to delete in this library
			//buttonDeleteIcon.visible = false
		} else if (Settings.loader3.visible) {
			// Set the headerText to the name of the screenshot
			headerText = Settings.screenshotMediaLibrary.substr(
						Settings.screenshotMediaLibrary.lastIndexOf("/") + 1,
						Settings.screenshotMediaLibrary.length)
			// Get the img source
			img.source = Settings.screenshotMediaLibrary
			// You should not be able to delete in this library
			//buttonDeleteIcon.visible = false
		} else if (Settings.loader6.visible) {
			// Set the headerText to the name of the screenshot
			headerText = Settings.screenshotScreenshots.substr(
						Settings.screenshotScreenshots.lastIndexOf("/") + 1,
						Settings.screenshotScreenshots.length)
			// Get the img source
			img.source = Settings.screenshotScreenshots
		} else if (Settings.loader9.visible) {
			// Set the headerText to the name of the screenshot
			headerText = Settings.screenshotGlobalSearch.substr(
						Settings.screenshotGlobalSearch.lastIndexOf("/") + 1,
						Settings.screenshotGlobalSearch.length)
			// Get the img source
			img.source = Settings.screenshotGlobalSearch
		}
	}

	// Second screen
	Connections {
		target: Settings.embeddedWindow
		onCurrentIndexChanged: {
			if (Settings.embeddedWindow.currentIndex === 1
					|| Settings.embeddedWindow.currentIndex === 2
					|| Settings.embeddedWindow.currentIndex === 3
					|| Settings.embeddedWindow.currentIndex === 6
					|| Settings.embeddedWindow.currentIndex === 9) {
				// Only the instance which is visible should "send" its img
				if (img.visible) {
					// Used for the second screen view
					Settings.contentArea = img
					if (Settings.isPresentationMode) {
						Settings.presentationSource.visible = true
					} else {
						Settings.presentationSource.visible = false
					}
				}
			}
		}
	}

	FileManager {
		id: fileManager
	}


	/*
	  *
	  * Header
	  *
	*/
	onOverviewClicked: {
        goAway()
    }

    function goAway() {
        Settings.loaderNewWindow.visible = false
        Settings.loaderNewWindow.source = ""
        Settings.contentArea = Settings.embeddedWindow
        if (Settings.loaderNewWindow.visible) {
            Settings.loaderNewWindow.visible = false
            Settings.loaderNewWindow.source = ""
        } else if (Settings.loader2.visible) {
            Settings.loader2.source = "qrc:/src/dav/DavLibrary.qml"
        } else if (Settings.loader3.visible) {
            Settings.loader3.source = "qrc:/src/medialibrary/MediaLibrary.qml"
        } else if (Settings.loader4.visible) {
            Settings.loader4.source = "qrc:/src/onlineplatform/OnlinePlatform.qml"
        } else if (Settings.loader6.visible) {
            Settings.loader6.source = "qrc:/src/screenshots/Screenshots.qml"
        } else if (Settings.loader9.visible) {
            Settings.loader9.source = "qrc:/src/mainwindow/GlobalSearch.qml"
        }
		Settings.isPresentationMode = false
    }

	/*
	  *
	  * Footer Center
	  *
	*/
	// Button Close
	buttonClose.onClicked: {

        goAway()

        /*if (Settings.loaderNewWindow.visible) {
			Settings.loaderNewWindow.visible = false
		} else if (Settings.loader2.visible) {
			Settings.loader2.source = "qrc:/src/dav/Dav.qml"
		} else if (Settings.loader3.visible) {
			Settings.loader3.source = "qrc:/src/medialibrary/MediaLibrary.qml"
		} else if (Settings.loader6.visible) {
			Settings.loader6.source = "qrc:/src/screenshots/Screenshots.qml"
		} else if (Settings.loader9.visible) {
			Settings.loader9.source = "qrc:/src/mainwindow/GlobalSearch.qml"
        }*/
	}


	/*
	  *
	  * Footer Right
	  *
	*/
	// Button Edit
	buttonEdit.onClicked: {
		Settings.startEditMode(false)
	}
	buttonEdit.onPressed: {
		buttonEditIcon.source = "qrc:/images/buttons/edit_gold.png"
	}
	buttonEdit.onReleased: {
        buttonEditIcon.source = "qrc:/images/edit.png"
	}

	/* Button Delete
	buttonDelete.onClicked: {
		// Only possible in Screenshots so no distinction between different views
		fileManager.deleteFile(
					Settings.screenshotScreenshots.substr(
						Settings.screenshotScreenshots.lastIndexOf("/") + 1,
						Settings.screenshotScreenshots.length),
					fileManager.getScreenshotDir())
		Settings.loader6.source = "Screenshots.qml"
	}
	buttonDelete.onPressed: {
		buttonDeleteIcon.source = "qrc:/images/buttons/delete_gold.png"
	}
	buttonDelete.onReleased: {
		buttonDeleteIcon.source = "qrc:/images/buttons/delete.png"
	}*/
	function clearView() {
		DVAGLogger.log("******** CLEAR VIEW ************")
		img.source = ""
		headerText = ""
		Settings.loader6.source = "qrc:/src/screenshots/Screenshots.qml"
	}
}
