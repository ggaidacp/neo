import QtQuick 2.3
import QtQuick.Controls 2.15
import FileManager 1.0
import DVAGLogger 1.0
import QtWebEngine
import QtWebChannel
import "../settings"
import "../templates"
import QWebEngineCertificateError


ApplicationWindow {
    id: mediaCtrlWin
	x: Settings.twoScreensWidth / 4 - Settings.embeddedWindowWidth / 2
    y: Settings.mainWindowHeight / 2 - Settings.embeddedWindowHeight / 2 + 37
	width: Settings.embeddedWindowWidth
    height: Settings.embeddedWindowHeight
    title: "DVAG Presenter - Mediensteuerung"
	visible: true
	flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint

	property FileManager filemanager: FileManager {}
    //property QWebEngineCertificateError zertError
    property bool closeWindowConnected: false



   MediaControlForm {
		id: mediaControlForm
        width: parent.width
        height: parent.height

        property FileManager filemanager: FileManager {}

       
       //Component.url: filemanager.getSettingQString("URIs/MediaControl")
        Component.onCompleted: {
            DVAGLogger.log("ggi **************** MediaControlForm.completed")
            webengineview.url = filemanager.getSettingQString("URIs/MediaControl") //"qrc:/src/mediacontrol/mc_redirect.html" //
            //closeClicked.connect(closeWindow())
        }


        webengineview.onCertificateError: function(error) {
            DVAGLogger.log("Zertifikatsfehler: " + error.description+ "\n" + error.type)
            //console.log("Zertifikatsfehler:", error.description);
            /*popUpWindowCertError.text = error.description+ "\n" + error.type
            popUpWindowCertError.visible = true*/
            if (error.type === QWebEngineCertificateError.CertificateCommonNameInvalid ||
                error.type === QWebEngineCertificateError.CertificateAuthorityInvalid) {
                error.acceptCertificate();
            } else {
                popUpWindowCertError.text = error.description+ "\n" + error.type
                popUpWindowCertError.visible = true
            }
        }
        webengineview.onNewWindowRequested:  function (request) {
            DVAGLogger.log("ggi !!!!!!!!! onNewWindowRequested Media Control Browser !!!!!!!!")
            request.openIn(webengineview)
        }
   /*     buttonReloadMC.onClicked: {
            webengineview.url = filemanager.getSettingQString("URIs/MediaControl") //"qrc:/src/mediacontrol/mc_redirect.html" //
        }
        buttonReloadMC.onPressed: {
            buttonReloadMCIcon.source = "qrc:/images/buttons/reload_gold.png"
           // DVAGLogger.log : "buttonReloadMC.pressed"
        }

        buttonReloadMC.onReleased: {
            buttonReloadMCIcon.source = "qrc:/images/buttons/reload.png"
            //DVAGLogger.log("buttonReloadMC.released")
        }*/

    }
   onVisibleChanged: {
       if (visible) {
           DVAGLogger.log("MEDIA CONTROL Settings.isPresentationMode = " + Settings.isPresentationMode)
          // Settings.isPresentationMode ? Settings.isPresentationMode = true : Settings.isPresentationMode = false
           DVAGLogger.log("MEDIA CONTROL Settings.isPresentationMode = " + Settings.isPresentationMode)
       } else {

       }
   }

    Timer {
        running: true
        repeat: true
        interval: 2000
        onTriggered: {
           /* mediaControlForm.webengineview.url = filemanager.getSettingQString("URIs/MediaControl")
            DVAGLogger.log("MC Timer triggered reset URL")*/
            if (closeWindow != undefined) {
                if (typeof closeWindow == "function") {
                    //DVAGLogger.log("MC Timer triggered")
                    if (!closeWindowConnected) {
                        DVAGLogger.log("connecting close button's signals to window's close function.")
                        mediaControlForm.closeClicked.connect(closeWindow)
                        closeWindowConnected = true
                    }
                }
            }
        }
    }
    function closeWindow() {
        DVAGLogger.log("closeWindow() was called on media control window.")
        Settings.embeddedWindow.currentIndex = 0
        Settings.lastIndex = 0
        //mediaCtrlWin.visible = false
    }

    function deleteBrowserCache() {
        if( mediaControlForm.webengineview !== undefined ) {
            let lastStorage = mediaControlForm.webengineview.profile.storageName;

            mediaControlForm.webengineview.profile.clearHttpCache();
            mediaControlForm.webengineview.profile.storageName = filemanager.getRandomString();
            DVAGLogger.log("new browser-profile set: " + mediaControlForm.webengineview.profile.storageName );

            filemanager.deleteBrowserStorage( lastStorage );
        }
    }
    PopUpWindowWithOneButton {
        id: popUpWindowCertError

        textButton: "Ok"
        visible: false
        anchors.centerIn: parent
    }


}
