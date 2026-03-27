import QtQml 2.3
import QtQuick 2.11
import QtWebChannel 1.0
import "../settings"
import "../templates"
import DVAGLogger 1.0
import FileManager 1.0

PdfViewForm {
	Component.onCompleted: {
		// Init the webengineview
		var url = "file:" + fileManager.getDataDir() + "/pdfview/viewer.html"
        DVAGLogger.log("Loading PDF-viewer from " + url)
		webengineview.url = url

		initTimer.start()

		// Used for the second screen view
		Settings.contentArea = webengineview
		Settings.contentAreaEditMode = laserPointerArea
	}

	Timer {
		id: initTimer
        interval: 500
        repeat: true
		onTriggered: {
            loadDocument()
		}
	}

    function loadDocument() {
        webengineview.webChannel = qpdfbridge
        var b64data

        if (Settings.loader1.visible) {
            b64data = fileManager.readFileToBase64(
                        Settings.pdfFilePresentation)
            headerText = Settings.pdfFilePresentation.substr(
                        Settings.pdfFilePresentation.lastIndexOf("/") + 1,
                        Settings.pdfFilePresentation.length)
        } else if (Settings.loader2.visible) {
            b64data = fileManager.readFileToBase64(Settings.pdfFileDav)
            headerText = Settings.pdfFileDav.substr(
                        Settings.pdfFileDav.lastIndexOf("/") + 1,
                        Settings.pdfFileDav.length)
        } else if (Settings.loader3.visible) {
            b64data = fileManager.readFileToBase64(
                        Settings.pdfFileMediaLibrary)
            headerText = Settings.pdfFileMediaLibrary.substr(
                        Settings.pdfFileMediaLibrary.lastIndexOf("/") + 1,
                        Settings.pdfFileMediaLibrary.length)
        } else if (Settings.loader9.visible) {
            b64data = fileManager.readFileToBase64(
                        Settings.pdfFileGlobalSearch)
            headerText = Settings.pdfFileGlobalSearch.substr(
                        Settings.pdfFileGlobalSearch.lastIndexOf("/") + 1,
                        Settings.pdfFileGlobalSearch.length)
        }

        webengineview.runJavaScript('
qpdf_ShowPdfFileBase64("' + b64data + '");
')
    }

	// Second screen
	Connections {
		target: Settings.embeddedWindow
		onCurrentIndexChanged: {
			if (Settings.embeddedWindow.currentIndex === 1
                //	|| Settings.embeddedWindow.currentIndex === 2
					|| Settings.embeddedWindow.currentIndex === 3
					|| Settings.embeddedWindow.currentIndex === 9) {
				// Only the instance which is visible should "send" its webengineview
				if (webengineview.visible) {
					// Used for the second screen view
					Settings.contentArea = webengineview
					Settings.contentAreaEditMode = laserPointerArea
				}
			}
		}
	}

	WebChannel {
		id: qpdfbridge
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
    }


	/*
	  *
	  * Footer Right
	  *
	*/
	// Button Edit
	buttonEdit.onClicked: {
		Settings.startEditMode(true, webengineview)
	}
	buttonEdit.onPressed: {
		buttonEditIcon.source = "qrc:/images/buttons/edit_gold.png"
	}
	buttonEdit.onReleased: {
        buttonEditIcon.source = "qrc:/images/edit.png"
	}

	// Button Screenshot
	buttonScreenshot.onClicked: {
		Settings.makeScreenshot(webengineview)
		// Show the screenshot taken popUpWindow
		popUpWindowScreenshotTaken.visible = true
		// Disable everything "under" the popup
		root.enabled = false
	}
	buttonScreenshot.onPressed: {
		buttonScreenshotIcon.source = "qrc:/images/buttons/screenshot_gold.png"
	}
	buttonScreenshot.onReleased: {
		buttonScreenshotIcon.source = "qrc:/images/buttons/screenshot.png"
	}

	// Button Laser Pointer
	buttonLaserPointer.onClicked: {
		buttonLaserPointer.isClicked = !buttonLaserPointer.isClicked
	}


	/*
	  *
	  * PopUpWindow for the completed import
	  *
	*/
	popUpWindowScreenshotTaken.onCloseClicked: {
		// Enable everything "under" the popup
		root.enabled = true
	}

	popUpWindowScreenshotTaken.onButtonClicked: {
		// Enable everything "under" the popup
		root.enabled = true
	}
}
