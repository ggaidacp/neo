pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import FileManager 1.0
import FileMetaData 1.0
import DVAGLogger 1.0
import QtWebEngine 6.7
import "../mainwindow"
import "../whiteboard"
import "../templates"
import "../screenshots"

QtObject {
	id: settings


	/*
	  *
	  * Items for the embeddedWindow, corresponding loader and "second screen"(presentation mode)
	  *
	*/
	// MediaControl overlay window

    property TextField activeTextField
	// MediaControl overlay window
	property variant mediaControlOverlay
    // Keeps the main window
    property ApplicationWindow mainWindow
    // Keeps the embeddedWindow
    property Item  embeddedWindow
    // Used by the embeddedWindow. Init with 0 --> no window was opened(empty item)
	property int lastIndex: 0
	// Used to keep the fullscreen state of the embeddedWindow
	property bool isFullscreen: false
	property ShaderEffectSource presentationSource
	property ShaderEffectSource presentationSourceEditMode
    property variant presentationModule: null
    // Used to keep the presentation state of the "second screen" (off/on)
    property bool isPresentationMode: false
    onIsPresentationModeChanged: {
		  DVAGLogger.log("ACHTUNG !!!! ******** GGI Presentation mode: ****************** ist = " + isPresentationMode)

		  presentationSource.visible = isPresentationMode

	}
	//property bool isPresentationBgBlackVisible: (Settings.isPresentationMode && !Settings.embeddedWindow.isCurrentIndexZero) || stopWatch.visible
    //property bool isPresentationBgBlackVisible: true
    property bool isPresentationBgWhiteVisible: true
    property Rectangle presenterBgBlack: null
    property Rectangle presenterBgWhite: null
    property StopWatch stopWatch: null
    property Rectangle leftScreen: null

	// Used by the embeddedWindow. If the EditMode window gets closed, a signal is sent to show the "WantToSave"-Popup
    property bool isEditMode: false
    // colors
    property string blue80: "#337A96"
    property string blue120: "#004763"
    property string grey:    "#D8D8D8"
	// Mail stuff
	property bool isComposingEmail: false
	// Stores the files for the export
	property ListModel attachmentsModel: ListModel {
		onCountChanged: {
			attachmentsSize = 0
			for (var i = 0; i < Settings.attachmentsModel.count; i++) {
				attachmentsSize += fileManager.getFileSize(
					Settings.attachmentsModel.get(
						i).path + "/" + Settings.attachmentsModel.get(i).name)
			}
            DVAGLogger.log("Attachments size: " + attachmentsSize)
			if (emailForm != undefined) {
				emailForm.updateStatus()
			}
		}
	}

	property int attachmentsSize: 0
	property EmailForm emailForm
	property ExportForm exportForm
	property Whiteboard whiteboard
	property EditMode editmode
	property ScreenshotView screenshotview
    //property Welcomesplash welcomesplash

	// Loader of the embeddedWindow
	property Loader loader1
	property Loader loader2
	property Loader loader3
	property Loader loader4
	property Loader loader5
	property Loader loader6
	property Loader loader7
	property Loader loader8
	property Loader loader9
	property Loader loader10
	property Loader loader11
    property Loader loader12
	property Loader loaderEditMode
	property Loader loaderNewWindow

	// Used for the second screen; Keeps the component which should be shown on the second screen
    property Item contentArea

	// Keeps the component which should be shown on top of the contentArea on the second screen if necessary e.g. the LaserPointer in some cases
	property Item contentAreaEditMode
    onContentAreaEditModeChanged: DVAGLogger.log("contentAreaEditMode = " + contentAreaEditMode)

	// Keeps the root column of the mainWindow
	// Used by the embeddedWindow in fullscreen to hide the content of the mainwindow because the background of the embeddedWindow is transparent
	property Column rootColumn

    // Dialog(s)
    property PopUpWindow downloadFinishedWin

    // Monitor download status, don't start more than one at a time, it crashes...
    property bool mediaLibDownloadStarted: false

	/*
	  *
	  * Readonly widths and heights of the mainWindow, embeddedWindow and its elements
	  *
	*/
	// Width of two Full-HD screens
    readonly property int twoScreensWidth: 3840 //Screen.desktopAvailableWidth

	// Height and width of the main window
    readonly property int mainWindowWidth: 1920 //Screen.width
    readonly property int mainWindowHeight: 1080 //Screen.height

	// Height and width of the toolbar in the main window
	readonly property int toolBarWidth: mainWindowWidth
    readonly property int toolBarHeight: mainWindowHeight * 10 / 144 // 75

    // Height and width of the window that is embedded in the main window
    // GGI: and should be 16:9
    readonly property int embeddedWindowWidth: isFullscreen ? mainWindowWidth : (mainWindowWidth / 9) * 6 // = 1280
    // 1440 : 810 = 1,7777778 --> 16:9
    readonly property int embeddedWindowHeight: isFullscreen ? mainWindowHeight : ((mainWindowHeight - toolBarHeight) / 12) * 10 - 2// 835,5

	// Height and width of the Header/Content/Footer of the embedded window
    readonly property int embeddedWindowHeaderHeight: embeddedWindowHeight / 18 // 47
	readonly property int embeddedWindowHeaderWidth: embeddedWindowWidth
    readonly property int embeddedWindowContentHeight: (embeddedWindowHeight / 30) * 26
	readonly property int embeddedWindowContentWidth: embeddedWindowWidth
    readonly property int embeddedWindowFooterHeight: (embeddedWindowHeight / 36) * 3 // 69
	readonly property int embeddedWindowFooterWidth: embeddedWindowWidth

    readonly property string defaultFont : "DVAG Type"
    readonly property string defaultFontLight : "DVAG Type Light"

    readonly property int fileGridCellWidth : 140
    readonly property int fileGridCellHeight : 160

    readonly property int fileGridCellWidthFull : fileGridCellWidth * 139 / 100
    readonly property int fileGridCellHeightFull : fileGridCellHeight * 139 / 100
	/*
	  *
	  * video-file paths for the different views
	  *
	*/
	property string videoFilePresentation
	// Path for the Presentation
	property string videoFileDav
	// Path for the DavLibrary
	property string videoFileMediaLibrary
	// Path for the MediaLibrary
	property string videoFileGlobalSearch
	// Path for the GlobalSearch

	// Used by the Media Player. Show a backgroundimage if the fileType is "audio"
	property string mediaPlayerFileType: "video"


	/*
	  *
	  * img-file paths for the different views
	  *
	*/
	// Used by the screenshots view to store the screenshot path which should be opened
	property string screenshotPresentation
	property string screenshotDav
	property string screenshotMediaLibrary
	property string screenshotScreenshots
	property string screenshotGlobalSearch



	/*
	  *
	  * Pdf-file paths for the different views
	  *
	*/
	property string pdfFilePresentation
	// Path for the Presentation
	property string pdfFileDav
	// Path for the DavLibrary
	property string pdfFileMediaLibrary
	// Path for the MediaLibrary
	property string pdfFileGlobalSearch
	// Path for the GlobalSearch

	// Used to store the selected dav category; Used by "Dav" and "DavLibrary"
	property int davNumber

	// Used to store the url of a clicked online platform so it can be shown in the webview (WebViewPage)
	property string url
	property QtObject webengineclouds
	property QtObject urlTextFieldClouds
	property string textCloud : "Cloud"
	property QtObject cloudsmodule

	// Used by "GlobalSearch" to get the searchfield text from the "main"
	property string searchFieldText


	/*
	  *
	  * Screenshot Management
	  *
	*/
	property FileManager fileManager: FileManager {}
	// Stores the path of the screenshots folder
	property string screenshotsDir: fileManager.getScreenshotDir()
	// Prefix of the screenshot file names
	property string screenshotPrefix: "DVAG"
	// Complete name of the current screenshot
	property string screenshotName

	// Make a screenshot of a qml item and save it as .png in the screenshotsDir
	function makeScreenshot(content) {
		content.grabToImage(function (result) {
			// Add a timestamp to the file name of the screenshots
			screenshotName = screenshotPrefix + "_" + Qt.formatDateTime(
						new Date(), "yyyy-MM-dd_hh-mm-ss") + ".png"
			result.saveToFile(screenshotsDir + "/" + screenshotName)
		})
	}

	// Make a screenshot of a qml item and save it as .png in the screenshotsDir
	// Closes the edit mode here in the callback
	// Otherwise there is the possibility that the edit mode is closed before the callback makes the screenshot -> no screenshot
	function makeScreenshotEditMode(content) {
		content.grabToImage(function (result) {
			screenshotName = screenshotPrefix + "_" + Qt.formatDateTime(
						new Date(), "yyyy-MM-dd_hh-mm-ss") + ".png"
			result.saveToFile(screenshotsDir + "/" + screenshotName)
			Settings.loaderEditMode.visible = false
			Settings.loaderEditMode.source = ""
		})
	}


    /*
	  *
	  * EditMode Management
	  *
	*/
	// Used to store the path of the screenshot made via edit-mode to load it into the canvas in "EditMode"
	property string screenshotPathEditMode

	function startEditMode(takeScreenshot, content) {
		if (takeScreenshot) {
			content.grabToImage(function (result) {
				screenshotName = screenshotPrefix + "_" + Qt.formatDateTime(
							new Date(), "yyyy-MM-dd_hh-mm-ss") + ".png"
				result.saveToFile(screenshotsDir + "/" + screenshotName)
				Settings.screenshotPathEditMode = "file:///" + screenshotsDir + "/" + screenshotName
				Settings.loaderEditMode.source = ""
				Settings.loaderEditMode.source = "qrc:/src/whiteboard/EditMode.qml"
				Settings.loaderEditMode.visible = true
				Settings.isEditMode = true
			})
		} else {
			if (Settings.loaderNewWindow.visible) {
				screenshotPathEditMode = screenshotPresentation
			} else if (Settings.loader2.visible) {
				screenshotPathEditMode = screenshotDav
			} else if (Settings.loader3.visible) {
				screenshotPathEditMode = screenshotMediaLibrary
			} else if (Settings.loader6.visible) {
				screenshotPathEditMode = screenshotScreenshots
			}
			Settings.loaderEditMode.source = ""
			Settings.loaderEditMode.source = "qrc:/src/whiteboard/EditMode.qml"
			Settings.loaderEditMode.visible = true
			Settings.isEditMode = true
		}
	}

	property FileMetaData fileMetaData: FileMetaData {}


}
