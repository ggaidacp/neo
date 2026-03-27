import QtQuick 2.15
import QtQuick.Controls 2.15
import FileManager 1.0
import DVAGLogger 1.0
import QtWebEngine 6.7

import "../templates"
import "../settings"


MediaLibraryNcForm {
	id: mediaLibraryNcForm

	property FileManager filemanager: FileManager {}
    property WebEngineView webengine: WebEngineView {}

    /**
      *
      * WebView behavior and settings
      *
    */
    webengineview.onFullScreenRequested: function (request) {
        request.accept()
        if (request.toggleOn) {
            //            request.accept();
            webengineview.state = "FullScreen"
            //Settings.isFullscreen = true
        } else {
            //            request.accept();
            webengineview.state = ""
            //Settings.isFullscreen = false
        }
    }
    webengineview.onVisibleChanged: {
        DVAGLogger.log("********** Web Engine visibility changed *************")
        if (visible) urlField.text = webengineview.url
  /*          if (!visible) {
                webengineview.runJavaScript(`
                                    (function() {
                                        var video = document.querySelector('video');
                                        if (video && !video.paused) {
                                            video.pause();
                                        }
                                    })();
                `)
            }*/
    }


	Component.onCompleted: {
        webengineview.url = "qrc:/src/medialibraryNc/index.html"
        DVAGLogger.log("on completed medialibNC")
        Settings.webengineclouds = webengineview
        Settings.urlTextFieldClouds = urlField
        Settings.cloudsmodule = mediaLibraryNcForm
        // CSS für permanente Scrollbars
                    let css = `
                        ::-webkit-scrollbar {
                            width: 14px;
                            height: 14px;
                        }
                        ::-webkit-scrollbar-thumb {
                            background-color: rgba(100, 100, 100, 0.8);
                            border-radius: 7px;
                        }
                        ::-webkit-scrollbar-track {
                            background: rgba(200, 200, 200, 0.3);
                        }
                    `;
                    let js = `
                        var style = document.createElement('style');
                        style.type = 'text/css';
                        style.appendChild(document.createTextNode(\`${css}\`));
                        document.head.appendChild(style);
                    `;
                    webengineview.runJavaScript(js);
    }
    onVisibleChanged: {
        if (visible) Settings.isPresentationMode = presentationModeVisibility
    }
    // Second screen
    // received signals from Settings.embeddedWindow
    Connections {
        target: Settings.embeddedWindow
        onCurrentIndexChanged: {

            if (Settings.embeddedWindow.currentIndex === 2) {
                // Used for the second screen view
                Settings.contentArea = webengineview
                DVAGLogger.log("*********** CurrentIndex = " + Settings.embeddedWindow.currentIndex)
                //Settings.contentAreaEditMode = laserPointerArea
            }
        }
    }
    urlField.onEnterPressed: { startSearch()}
    searchIconArea.onClicked: { startSearch()}

    Component.onDestruction: {
        Settings.embeddedWindow.calculateIsCurrentIndexZero()
    }
    // received signals from DownloadManager
    Connections {
           target: downloadManager
           onDownloadCompleted: {
               filemanager.extractAllZipFiles(filemanager.getImportDir())
               Settings.mediaLibDownloadStarted = false
               Settings.downloadFinishedWin.visible = true

           }
    }
    /*WebEngineProfile {
		id: eprofile

        /*onDownloadRequested:  {
            var item = download
            item.path = filemanager.getImportDir() + "/" + item.downloadFileName
            DVAGLogger.log("********* ITEM PATH ****** " + filemanager.getImportDir() + "/" + item.downloadFileName)
            DVAGLogger.log("Settings.mediaLibDownloadStarted = " + ((Settings.mediaLibDownloadStarted) ? "true" : "false"))
            if (!Settings.mediaLibDownloadStarted) {
                Settings.mediaLibDownloadStarted = true
                DVAGLogger.log("******** ITEM ACCEPT **********")
                item.accept()
            }

            Settings.mediaLibDownloadStarted = true
        }
        onDownloadFinished: function (download) {
            var item = download
            Settings.mediaLibDownloadStarted = false
            Settings.downloadFinishedWin.visible = true
            DVAGLogger.log("********* VOR UNZIP ****** " + item.downloadFileName)
            //filemanager.unzip(item.downloadFileName)
        }

    }*/


    webengineview.enabled: {
        //presentationModeVisibility: true
        DVAGLogger.log("Web Engine Enabled")
        urlField.text = webengineview.url
    }
   /* webengine.Discarded : {
        presentationModeVisibility: true
        urlField.visible = true
        DVAGLogger.log("Web Engine discarded")
    }*/



    webengineview.onNewWindowRequested:  function (request) {

        presentationModeVisibility = true
        urlField.visible = true
        headerText = ""
        overviewButtonVisiblity = true
        buttonBackIcon.visible = true
        buttonForwardIcon.visible = true
        DVAGLogger.log("New Web Request:" + request)
        request.openIn(webengineview)
        //urlField.displayText = webengineview.url

    }

    webengineview.onJavaScriptConsoleMessage: function (message) {
        DVAGLogger.log("onJavaScriptConsoleMessage New Web Request:" + message)
    }

    webengineview.onClipChanged: reload()
   // webChannel.connectTo: webengineview
    // Navigation Button Back
    buttonBack.onClicked: {
        if (webengineview.canGoBack) {
            webengineview.goBack()
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
        if (webengineview.canGoForward) {
            webengineview.goForward()
        }
    }
    buttonForward.onPressed: {
        buttonForwardIcon.source = "qrc:/images/buttons/forward_gold.png"
    }
    buttonForward.onReleased: {
        buttonForwardIcon.source = "qrc:/images/buttons/forward.png"
    }

    /*buttonClose.onClicked: {
        DVAGLogger.log("On Close clicked")
        //webengineview.url = "https://login.live.com/logout.srf"
        //webengineview.update()
        /*filemanager.initWebEngine()
        filemanager.deleteBrowserStorage()

        //Settings.embeddedWindow.currentIndex = 0
        //Settings.loader2.active
        //webengineview.url = "qrc:/src/medialibraryNc/index.html"
        //goToOverview()
        webengineview.url = "qrc:/src/medialibraryNc/index.html"
        urlField.visible = false
        presentationModeVisibility = false
        buttonClose.visible = false
        buttonBackIcon.visible = false
        buttonForwardIcon.visible = false
        headerText = "Clouds"
    } */

    onOverviewClicked: {
        goToOverview()
    }

    function startSearch() {

        if (urlField.displayText.startsWith("http://") || urlField.displayText.startsWith("https://")) {
            Settings.url = urlField.displayText
        } else {
            Settings.url = "https://www.google.com/search?q=" + encodeURIComponent(urlField.displayText)
            //Settings.url = "https://" + urlField.displayText
        }
        webengineview.url = Settings.url
        DVAGLogger.log("GO TO : " + Settings.url)

    }

    function handleEnterPressed(text) {
        startSearch()
        DVAGLogger.log("Search icon clicked!")

    }
    function goToOverview() {
        /*Settings.loaderNewWindow.visible = false
        Settings.loaderNewWindow.source = ""*/
        //Settings.contentArea = Settings.embeddedWindow
        DVAGLogger.log("PPPPPPPPPPPPPPP goToOverview PPPPPPPPPPPPPPPP")

        if (Settings.loaderNewWindow.visible) {
            Settings.loaderNewWindow.visible = false
            Settings.loaderNewWindow.source = ""
        } else if (Settings.loader2.visible) {
            iniFirstPage()
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
            // Settings.loader4.source = "qrc:/src/onlineplatform/OnlinePlatform.qml"
            presentationModeVisibility = false
            Settings.isPresentationMode = false

    }

    function iniFirstPage() {
        DVAGLogger.log("+++++++++ initFirstPAge +++++++++")
        Settings.loader2.source = "qrc:/src/medialibraryNc/MediaLibraryNc.qml"
        webengineview.url = "qrc:/src/medialibraryNc/index.html"
        urlField.visible = false
        urlField.clear()
        presentationModeVisibility = false
        buttonBackIcon.visible = false
        buttonForwardIcon.visible = false
        headerText = Settings.textCloud
        overviewButtonVisiblity = false
        Settings.contentArea = webengineview
    }

    Timer {
        interval: 3000  // alle 30 Sekunden
        repeat: true
        running: true

        //DVAGLogger.log: ("******** Reload Timer schlägt zu! *************")
        onTriggered: {
            if (urlField.placeholderText.substring(0, 33) === "https://login.microsoftonline.com" && webengineview.visible === true) {
                Settings.embeddedWindow.currentIndex = 0
                Settings.lastIndex = 0
                Settings.embeddedWindow.currentIndex = 2
                Settings.lastIndex = 2

                handlePostMainButtonClick()
            }   
        }

    }

}
