//import QtQuick.Controls 2.15
import QtQuick 2.15
import QtWebEngine 6.7
import QtWebView 6.7

import QtWebChannel 6.7
import QtQuick.Controls 2.15
import FileManager 1.0
import DVAGLogger 1.0
import "../settings"
import "../functions"



WebViewPageForm {
    property FileManager filemanager: FileManager {}
    //property alias jsBridge : jsBridge
	Component.onCompleted: {
		// Used for the second screen view
		Settings.contentArea = webview
		Settings.contentAreaEditMode = laserPointerArea
        Settings.embeddedWindow.calculateIsCurrentIndexZero()

        searchIconArea.clicked.connect(function() {

            if (urlField.displayText.startsWith("http://") || urlField.displayText.startsWith("https://")) {
                Settings.url = urlField.displayText
            } else {
                Settings.url = "https://" + urlField.displayText
            }

            Settings.loader4.source = "qrc:/src/onlineplatform/WebViewPage.qml"
            DVAGLogger.log("OnlinePlatformForm loaded!")

        } )
        //webChannel.registerObjects([jsBridge])                 //([jsBridge])
        DVAGLogger.log("webviewForm loaded!")

	}

    urlField.onEnterPressed  :  startSearch()
    searchIconArea.onClicked : startSearch()

    Component.onDestruction: {
        Settings.embeddedWindow.calculateIsCurrentIndexZero()
    }


	// Second screen
	Connections {
		target: Settings.embeddedWindow
		onCurrentIndexChanged: {
			if (Settings.embeddedWindow.currentIndex === 4) {
				// Used for the second screen view
				Settings.contentArea = webview
				Settings.contentAreaEditMode = laserPointerArea
			}
		}
	}


	/*
	  *
	  * Header
	  *
	*/
	onOverviewClicked: {
        goToOverview();
        DVAGLogger.log("On Overview clicked")
    }

	/*
	  *
	  * Footer Left
	  *
	*/
	// Navigation Button Back
	buttonBack.onClicked: {
		if (webview.canGoBack) {
			webview.goBack()
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
		if (webview.canGoForward) {
			webview.goForward()
		}
	}
	buttonForward.onPressed: {
		buttonForwardIcon.source = "qrc:/images/buttons/forward_gold.png"
	}
	buttonForward.onReleased: {
        buttonForwardIcon.source = "qrc:/images/buttons/forward.png"
	}



	function goToOverview() {
		Settings.loaderNewWindow.visible = false
        Settings.loaderNewWindow.source = ""
        Settings.contentArea = Settings.embeddedWindow

        if (Settings.loaderNewWindow.visible) {
            Settings.loaderNewWindow.visible = false
            Settings.loaderNewWindow.source = ""
        } else if (Settings.loader2.visible) {
			Settings.loader2.source = "qrc:/src/medialibraryNc/MediaLibraryNc.qml"
        } else if (Settings.loader3.visible) {
            Settings.loader3.source = "qrc:/src/medialibrary/MediaLibrary.qml"
        } else if (Settings.loader4.visible) {
            Settings.loader4.source = "qrc:/src/onlineplatform/OnlinePlatform.qml"
        } else if (Settings.loader6.visible) {
            Settings.loader6.source = "qrc:/src/screenshots/Screenshots.qml"
        } else if (Settings.loader9.visible) {
            Settings.loader9.source = "qrc:/src/mainwindow/GlobalSearch.qml"
        }

		Settings.embeddedWindow.calculateIsCurrentIndexZero()
        Settings.loader4.source = "qrc:/src/onlineplatform/OnlinePlatform.qml"
        Settings.isFullscreen = false
        presentationModeVisibility = false
        Settings.isPresentationMode = false

	}

	/*
	  *
	  * Footer Right
	  *
	*/
	webview.enabled: {
		//presentationModeVisibility: true
		DVAGLogger.log("Web Engine Enabled")
		urlField.text = webview.url
	}

    webview.onLoadingChanged: {
        // Überprüfe, ob die Seite fertig geladen ist
                   // if (!loadRequest.isLoading) {
                        // Initialisiere den WebChannel in der Webseite
         //DVAGLogger.log("********* run java script **********")
                        //webview.runJavaScript("if (typeof qt != 'undefined') { new QWebChannel(qt.webChannelTransport, function(channel) {window.keyboardHandler = channel.objects.keyboardHandler;document.querySelectorAll('input[type=text], input[type=password], textarea').forEach(function(input) {input.addEventListener('focus', function() {window.inputHandler.showKeyboard();});input.addEventListener('blur', function() {window.inputHandler.hideKeyboard();});});});}");
        //   }
		/*onLoadingChanged: {
				if (loadRequest.status === WebEngineLoadRequest.LoadSucceededStatus) {
					webview.runJavaScript(
						"document.body.style.overflow = 'hidden';" +
						"document.documentElement.style.overflow = 'hidden';"
					)
				}
			}*/
    }
    webview.onVisibleChanged: {
        DVAGLogger.log("********** Web Engine visibility changed *************")
            if (!visible) {
                webview.runJavaScript(`
                    (function() {
                        var video = document.querySelector('video');
                        if (video && !video.paused) {
                            video.pause();
                        }
                    })();
                `)
            }
    }

    QtObject {
            id: keyboardHandler
            function showKeyboard() {
                Qt.inputMethod.show();
            }
            function hideKeyboard() {
                 Qt.inputMethod.hide();
            }
    }
	// Button Edit
	buttonEdit.onClicked: {
		Settings.startEditMode(true, webview)
	}
	buttonEdit.onPressed: {
		buttonEditIcon.source = "qrc:/images/buttons/edit_gold.png"
	}
	buttonEdit.onReleased: {
        buttonEditIcon.source = "qrc:/images/edit.png"
	}

	// Button Screenshot
	buttonScreenshot.onClicked: {
		webview.runJavaScript(`
			(function() {
				var video = document.querySelector('video');
				if (video && !video.paused) {
					video.pause();
				}
			})();
		`)
		Settings.makeScreenshot(webview)
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


	/**
	  *
	  * WebView behavior and settings
	  *
	*/
	webview.onFullScreenRequested: function (request) {
		request.accept()
		if (request.toggleOn) {
			//            request.accept();
			webview.state = "FullScreen"
            //DVAGLogger.log("********* Settings.isFullscreen = true **********")
            //Settings.isFullscreen = true
		} else {
			//            request.accept();
			webview.state = ""
            //DVAGLogger.log("********* Settings.isFullscreen = false **********")
            //Settings.isFullscreen = false
		}
	}

	webview.onNewWindowRequested: function (request) {
		//webview.NewViewInWindow: function (request) {
        request.openIn(webview)
		urlField.text = webview.url
		//Settings.embeddedWindow.visible = false
	}

    function startSearch() {

        if (urlField.displayText.startsWith("http://") || urlField.displayText.startsWith("https://")) {
            Settings.url = urlField.displayText
        } else {
            Settings.url = "https://" + urlField.displayText
        }

        Settings.loader4.source = "qrc:/src/onlineplatform/WebViewPage.qml"
        DVAGLogger.log("Search icon clicked!")

    }

   /* webview.onLoadingChanged:   {
        DVAGLogger.log("onLoadingChanged : ...Jetzt injektion von java script")
        webview.runJavaScript("var inputs = document.querySelectorAll('input[type=text], input[type=password], textarea'); var counter = 0; inputs.forEach(function(input) { input.addEventListener('focus', function() {  if (typeof qt !== 'undefined') { counter = couter +1; qt.webChannel.objects.jsBridge.onInputFieldFocused();}}); input.addEventListener('blur', function() { if (typeof qt !== 'undefined') { counter = couter +1; qt.webChannel.objects.jsBridge.onInputFieldBlurred();} });}); if (typeof qt !== 'undefined') { qt.webChannel.objects.jsBridge.onGetCounter(counter)}")
    }*/

    webview.profile.httpAcceptLanguage: "de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7"

	Timer {
		id: showTm
		running: false
		repeat: false
		interval: 100
		onTriggered: {
			Settings.embeddedWindow.visible = true
		}
	}
	Timer {
		interval: 3000  // alle 30 Sekunden
		repeat: true
		running: true

		//DVAGLogger.log: ("******** Reload Timer schlägt zu! *************")
		onTriggered: {
		  if (urlField.displayText.substring(0, 33) === "https://login.microsoftonline.com" && webview.visible === true) {
				Settings.embeddedWindow.currentIndex = 0
				Settings.lastIndex = 0
				Settings.embeddedWindow.currentIndex = 4
				Settings.lastIndex = 4
				//DVAGLogger.log("%%%%%%%%%%v rehresh meine.dvag v%%%%%%%%%%%%")
				handlePostMainButtonClick()
			}
		}
	}

}
