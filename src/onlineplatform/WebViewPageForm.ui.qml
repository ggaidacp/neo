import QtQuick 2.15
import QtWebEngine 6.7
//import QtWebEngine 1.15
//import QtWebView 6.7
import QtWebChannel 6.7
import QtQuick.Controls 2.15

import QtQuick.VirtualKeyboard 6.2
//import QtQuick.Controls.Styles 1.4
import "../settings"
import "../templates"

EmbeddedWindow {
	id: embeddedWindow
    fullScreenVisibility: false
	property alias root: root

	// Header
    //headerText: webview.title
    urlField.text : Settings.url

	overviewButtonVisiblity: true
    presentationModeVisibility: true
    //currentImage: slidergrey
    // header
    property alias urlField: urlField
    property alias searchIconArea: searchIconArea

	// Content
	property alias webview: webview
    property alias webChannel: webChannel
    property alias laserPointerArea: laserPointerArea

	// Footer
	// Left
	property alias buttonBack: buttonBack
	property alias buttonBackIcon: buttonBackIcon
	property alias buttonForward: buttonForward
	property alias buttonForwardIcon: buttonForwardIcon
	// Center
    //property alias buttonClose: buttonClose
	// Right
	property alias buttonEdit: buttonEdit
	property alias buttonEditIcon: buttonEditIcon
	property alias buttonScreenshot: buttonScreenshot
	property alias buttonScreenshotIcon: buttonScreenshotIcon
	property alias buttonLaserPointer: buttonLaserPointer
	property alias buttonLaserPointerIcon: buttonLaserPointerIcon

	// PopUpWindow Screenshot Taken
	property alias popUpWindowScreenshotTaken: popUpWindowScreenshotTaken

	Column {
		id: root
		width: parent.width
		height: parent.height

		// Header
        Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowHeaderHeight
            color: "transparent"
            NeoTextField {
                id: urlField
                visible: true
                width: 430
                height: 32
                anchors.centerIn: parent
                anchors.verticalCenter: parent.top
                font.pointSize: 14
                placeholderText: "Hier URL eingeben"
                rightPadding : 40

                background: Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "white"
                    //opacity: 0.75
                    border.color: "#8D8D8D"
                    radius: 25
                }

                Image {
                        id: searchIcon
                        width: 24
                        height: 24
                        source: "qrc:/images/online-platforms/weltkugel.png"
                        anchors.right: spacekeeper.left
                        anchors.verticalCenter:   parent.verticalCenter

                        MouseArea {
                            id: searchIconArea
                            width: parent.width
                            height: parent.height
                        }
                }
                Rectangle {
                        id: spacekeeper
                        width: 12
                        height: 24
                        anchors.right: parent.right
                        anchors.verticalCenter:   NeoTextField.verticalCenter
                        //anchors.right: parent.right
                        color: "transparent"
                }
            }
        }

		// Content
		Rectangle {
			id: contentArea
            width: embeddedWindow.width
            height: (embeddedWindow.height / 30) * 26
            color: "transparent"
			BusyIndicator {
				id: busyIndicator
				width: parent.width / 3
				height: parent.height / 10
				running: true
				anchors.centerIn: parent
			}

            Rectangle {
                width: parent.width -4
                height: parent.height-4
                color: "transparent"
                //border.color: "yellow"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
				WebEngineProfile {
						id: privateProfile
						offTheRecord: true
				}

				WebEngineView {
                    id: webview
                    width: parent.width
                    height: parent.height
                    enabled: !buttonLaserPointer.isClicked
					profile: privateProfile

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
					settings.playbackRequiresUserGesture: true
					settings.webGLEnabled: true
					settings.localStorageEnabled: true
					settings.showScrollBars: false

                    url: Settings.url
                    WebChannel {
                       id: webChannel
                       //registeredObjects: {"keyboardHandler": jsBridge} // Register the object for communication
                    }
                   /* loadingChanged : {
                               // Inject JavaScript to detect focus events in input fields
                             //  webView.runJavaScript("var inputs = document.querySelectorAll('input[type=text], input[type=password], textarea'); inputs.forEach(function(input) { input.addEventListener('focus', function() {  if (typeof qt !== 'undefined') { qt.webChannel.objects.jsBridge.onInputFieldFocused();}}); input.addEventListener('blur', function() { if (typeof qt !== 'undefined') { qt.webChannel.objects.jsBridge.onInputFieldBlurred();} });}););"
                    }*/

                }
            }

			// Laser Pointer
        LaserPointerArea {
				id: laserPointerArea
				width: parent.width
				height: parent.height
				enabled: buttonLaserPointer.isClicked
				visible: Settings.isPresentationMode
			}
		}

		// Footer
		Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowFooterHeight
            color: "white"
            SeparatorLine {}
			// Left
			Row {
				id: rowLeft
				width: parent.width / 4
				height: parent.height
                spacing: 12
                leftPadding : 28
				anchors.left: parent.left

				Image {
					id: buttonBackIcon
                    width: 32
                    height: 32
                    source: "qrc:/images/buttons/back.png"
					fillMode: Image.PreserveAspectFit
					mipmap: true
					anchors.verticalCenter: parent.verticalCenter

					MouseArea {
						id: buttonBack
						width: parent.width
						height: parent.height
					}
				}

				Image {
					id: buttonForwardIcon
                    width: 32
                    height: 32
                    source: "qrc:/images/buttons/forward.png"
					fillMode: Image.PreserveAspectFit
					mipmap: true
					anchors.verticalCenter: parent.verticalCenter

					MouseArea {
						id: buttonForward
						width: parent.width
						height: parent.height
					}
				}
			}

            /* Center
			ButtonEW {
				id: buttonClose
				width: (parent.width / 2) / 3
				height: parent.height / 2
				text: "Schließen"
				anchors.centerIn: parent
            }*/

			// Right
			Row {
				id: rowRight
                width: parent.width / 6
				height: parent.height
				spacing: width / 18
				anchors.left: parent.left
				LayoutMirroring.enabled: true
                rightPadding: 28

				Image {
					id: buttonScreenshotIcon
					width: parent.width / 6
					height: parent.height / 2
					source: "qrc:/images/buttons/screenshot.png"
					fillMode: Image.PreserveAspectFit
					mipmap: true
					anchors.verticalCenter: parent.verticalCenter

					MouseArea {
						id: buttonScreenshot
						width: parent.width
						height: parent.height
					}
				}

				Image {
					id: buttonEditIcon
					width: parent.width / 6
					height: parent.height / 2
                    source: "qrc:/images/edit.png"
					fillMode: Image.PreserveAspectFit
					mipmap: true
					anchors.verticalCenter: parent.verticalCenter

					MouseArea {
						id: buttonEdit
						width: parent.width
						height: parent.height
					}
				}

				Image {
					id: buttonLaserPointerIcon
					width: parent.width / 6
					height: parent.height / 2
					source: buttonLaserPointer.isClicked ? "qrc:/images/buttons/laserpointer_gold.png" : "qrc:/images/buttons/laserpointer.png"
					fillMode: Image.PreserveAspectFit
					mipmap: true
					visible: Settings.isPresentationMode
					anchors.verticalCenter: parent.verticalCenter

					MouseArea {
						id: buttonLaserPointer
						width: parent.width
						height: parent.height

						property bool isClicked: false
					}
				}
			}
		}
	}


	/*
	  *
	  * PopUpWindow for the taken screenshot
	  *
	*/
	PopUpWindowWithOneButton {
		id: popUpWindowScreenshotTaken

		text: "Screenshot gespeichert."
		textButton: "Ok"
		visible: false
		anchors.centerIn: parent
	}

}
