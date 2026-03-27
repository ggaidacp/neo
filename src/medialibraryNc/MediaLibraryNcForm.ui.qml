import QtQuick 2.15
import QtQuick.Controls 2.15
import QtWebView 6.7
import QtWebChannel 6.7
import QtWebEngine 6.7
// dont remove unused import. important for Touchscreens!
import QtWebEngine.ControlsDelegates
import "../settings"
import "../templates"

EmbeddedWindow {
	id: embeddedWindow
    fullScreenVisibility: false
	// Header
    headerText: Settings.textCloud
    urlField.text: Settings.url
    overviewButtonVisiblity: false
    presentationModeVisibility: false
    //TouchHandle: TouchHandle


    // Content
    property alias webengineview: webengineview
    //property alias webChannel: webChannel
    // Footer

    property alias buttonBack: buttonBack
    property alias buttonBackIcon: buttonBackIcon
    property alias buttonForward: buttonForward
    property alias buttonForwardIcon: buttonForwardIcon
    property alias buttonClose: buttonClose
    // Header
    property alias searchIconArea: searchIconArea
    property alias urlField : urlField



	Column {
		width: parent.width
		height: parent.height

		// Header
		Rectangle {
			width: embeddedWindow.width
            height: Settings.embeddedWindowHeaderHeight
			color: "transparent"
            NeoTextField {
                id: urlField
                visible: false
                width: 430
                height: 32
                anchors.centerIn: parent
                anchors.verticalCenter: parent.top
                font.pointSize: 14
                placeholderText: webengineview.url
                text: webengineview.url
                rightPadding : 40

                background: Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "white"
                    border.color: Settings.grey
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
                        color: "transparent"
                }

            }
		}

		// Content
		Rectangle {
            id: contentRectangle
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
            WebEngineProfile {
                    id: privateProfile
                    offTheRecord: true
                    isPushServiceEnabled: true
            }

            Rectangle {
                width: parent.width - 4
                height: parent.height - 4
                color: "transparent"

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                WebEngineView {
                    id: webengineview
                    width: parent.width
                    height: parent.height
                    property bool redirecting: false
                    //profile: privateProfile
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
                    settings.accelerated2dCanvasEnabled: true
                    settings.showScrollBars: false

                    WebChannel {
                       id: webChannel
                    }


                }
            }
		}

        // Footer
        Rectangle {
            width: (embeddedWindow.width / 20) * 20
            height: Settings.embeddedWindowFooterHeight
            color: "white"
            //anchors.horizontalCenter: parent.horizontalCenter
            SeparatorLine {}
            // Left
            Row {
                id: rowLeft
                width: parent.width / 4
                height: parent.height
                spacing: 12
                leftPadding: 28
                anchors.left: parent.left

                Image {
                    id: buttonBackIcon
                    width: 32
                    height: 32
                    source: "qrc:/images/buttons/back.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    visible: false
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
                    visible: false
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        id: buttonForward
                        width: parent.width
                        height: parent.height
                    }
                }
            }

            // Center
            ButtonEW {
                id: buttonClose
                width: (parent.width / 2) / 3
                height: parent.height / 2
                text: "Schließen"
                anchors.centerIn: parent
                visible: false
            }


        }
	}

}
