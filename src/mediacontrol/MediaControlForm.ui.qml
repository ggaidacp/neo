import QtQuick 2.15
import QtWebEngine
import QtQuick.Controls 2.15
import QtWebChannel


import QtWebView 2.15

import "../settings"
import "../templates"

EmbeddedWindow {
	id: embeddedWindow

	// Header
	headerText: "Mediensteuerung"
    closeButtonVisiblity: true
    fullScreenVisibility: false
	presentationModeVisibility: false
	// Content
	property alias webengineview: webengineview
    //Footer
    /*property alias buttonReloadMC: buttonReloadMC
    property alias buttonReloadMCIcon: buttonReloadMCIcon*/

	Column {
		width: parent.width
		height: parent.height

		// Header
		Rectangle {
			width: embeddedWindow.width
            height: Settings.embeddedWindowHeaderHeight
			color: "transparent"
		}

		// Content
		Rectangle {
			id: contentArea
			width: embeddedWindow.width
            height: (embeddedWindow.height / 30) * 26 +  Settings.embeddedWindowFooterHeight
            color: "transparent"

			BusyIndicator {
				id: busyIndicator
				width: parent.width / 3
				height: parent.height / 10
				running: true
				anchors.centerIn: parent
			}
            WebEngineView {
				id: webengineview
                width: parent.width
                height: parent.height

                settings.javascriptCanOpenWindows: true
                settings.javascriptEnabled: true
                settings.javascriptCanAccessClipboard: true
                settings.javascriptCanPaste: true
                settings.pluginsEnabled: true
                settings.autoLoadImages: true
                settings.allowWindowActivationFromJavaScript: true
                settings.fullScreenSupportEnabled: true
                settings.spatialNavigationEnabled: true
                settings.screenCaptureEnabled: true
                settings.localContentCanAccessFileUrls: true
                settings.localContentCanAccessRemoteUrls: true
                settings.hyperlinkAuditingEnabled: false
                settings.errorPageEnabled: true
                settings.allowRunningInsecureContent: true
                settings.playbackRequiresUserGesture: false
                settings.webGLEnabled: true
                settings.localStorageEnabled: true
                settings.showScrollBars: false
                url: "qrc:/images/mediacontroldummy.jpg"

            }
		}

		// Footer
    /*	Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowFooterHeight
            color: "white"
            SeparatorLine {}
			// Right
			Row {
				id: rowRight
				width: parent.width / 5
				height: parent.height
				spacing: width / 20
				anchors.left: parent.left
				LayoutMirroring.enabled: true
                rightPadding: 28

				Image {
					id: buttonReloadMCIcon
					width: parent.width / 6
					height: parent.height / 2
                    source: "qrc:/images/buttons/reload.png"
					fillMode: Image.PreserveAspectFit
                    //mipmap: true
                    anchors.verticalCenter: parent.verticalCenter

					MouseArea {
						id: buttonReloadMC
						width: parent.width
                        height: parent.height

					}
				}
			}
        }*/
    }
}
