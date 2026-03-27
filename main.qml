import QtQuick.Window 6.2
import QtQuick.Controls
import QtQuick 6.2
import QtWebEngine 6.7
import QtQuick.VirtualKeyboard 6.0
import QtQuick.VirtualKeyboard.Components 6.0
import QtQuick.VirtualKeyboard.Plugins 6.0
import QtQuick.VirtualKeyboard.Styles 6.0
import QtQuick.VirtualKeyboard.Settings 6.1
import QtMultimedia 6.7
import FileManager 1.0
import DVAGLogger 1.0
import "./src/settings"
import "./src/templates"
import "./src/windowswitcher"
import "./src/medialibraryNc"


ApplicationWindow {
	id: mainWindow
    width: Settings.twoScreensWidth
    height: Settings.mainWindowHeight
    title: "DVAG Presenter"
	visible: true
    flags: Qt.FramelessWindowHint
    z:1

	property int adminCtr: 0

    // Onscreen virtual Keyboard
    InputPanel {
        id: inputPanel
        /*width: Settings.isFullscreen ? Settings.mainWindowWidth * 100 / 126 : Settings.embeddedWindowWidth * 100 / 126
        height: Settings.isFullscreen ? Settings.mainWindowWidth / 10 : Settings.embeddedWindowHeight / 10*/
        width:  ((Settings.mainWindowWidth / 9) * 6) * 100 / 126
        height: (((Settings.mainWindowHeight - Settings.toolBarHeight) / 12) * 10 - 2) / 10
        z: 3
        /*x: Settings.isFullscreen ? (Settings.mainWindowWidth - width) / 2 : column_buttons.width + 227
        y: Settings.isFullscreen ? Settings.mainWindowHeight - height : Settings.mainWindowHeight + height*3*/
        x: column_buttons.width + 227
        y: Settings.mainWindowHeight + height*3
        opacity: 1

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: (Settings.activeTextField != null && Settings.activeTextField.y > 520) ? Settings.activeTextField.y + (Settings.isFullscreen ? - 30 : 80)  :
                   (((Settings.mainWindowHeight - Settings.toolBarHeight) / 12) * 10 - 2) + height * 100 / 52
                //Settings.embeddedWindow.y: 0
            }
        }

        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }
            }
        }
        Component.onCompleted: {
               //VirtualKeyboardSettings.activeLocales = ["de_DE", "en_GB", "en_US"]
            //Qt.inputMethod.keyboard.style.previewsEnabled = false

        }

    }



	//visibility: Window.FullScreen
	Component.onCompleted: {
        //DVAGLogger.log("********* Current Dir " + filemanager.getCurrentDir())
        Settings.mainWindow = mainWindow
        Settings.embeddedWindow = embeddedWindow
        Settings.rootColumn = rootColumn
        Settings.loader1 = loader1
		Settings.loader2 = loader2
		Settings.loader3 = loader3
		Settings.loader4 = loader4
		Settings.loader5 = loader5
		Settings.loader6 = loader6
		Settings.loader7 = loader7
		Settings.loader8 = loader8
		Settings.loader9 = loader9
		Settings.loader10 = loader10
		Settings.loader11 = loader11
        Settings.loader12 = loader12
		Settings.loaderEditMode = loaderEditMode
		Settings.loaderNewWindow = loaderNewWindow

        var w1 = Qt.createComponent(
					"./src/windowswitcher/WindowSwitcher.qml").createObject(
					mainWindow)
        w1.show()
		var w2 = Qt.createComponent(
					"./src/mediacontrol/MediaControlWindow.qml").createObject(
					mainWindow)
        w2.show()

		Settings.mediaControlOverlay = w2
        Settings.mediaControlOverlay.visible = (Settings.embeddedWindow.currentIndex === 8)
        Settings.presentationSource = secondView
        Settings.presentationSourceEditMode = secondViewSource
        Settings.downloadFinishedWin = downloadFinishedWin
        Settings.presenterBgBlack = presenterScreenBgBlack
        Settings.presenterBgWhite = presenterScreenBgWhite
        Settings.stopWatch = stopWatch
        Settings.leftScreen = leftScreen
    }


	onClosing: {

	}

	FileManager {
		id: filemanager
	}

	Row {
		width: parent.width
		height: parent.height

		// Main Screen which showns the application
		Rectangle {
			id: leftScreen
			width: Settings.mainWindowWidth
            height: Settings.mainWindowHeight
            color: "white"
            // Background
            Image {
				id: background
				width: parent.width
				height: parent.height - Settings.toolBarHeight
                source: "qrc:/images/background.jpg"
				fillMode: Image.Stretch
				anchors.bottom: parent.bottom
            }


			Column {
				id: rootColumn
				width: parent.width
				height: parent.height

                ToolBar {
                    width: Settings.toolBarWidth
                    height: Settings.toolBarHeight
                    background: Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "transparent"
                    }


                    Row { // Logo-Row
                        id: rowLeft
                        width: Settings.mainWindowWidth / 2 + 50
                        height: parent.height
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 1

                        Rectangle {
                            id: leftspaceholder
                            width: 42
                            height: 75
                            color: "transparent"
                        }
                        Rectangle { // DVAG-Logo Rectangle
                            width: 91
                            height: 96 // hight of logo-Picture
                            color: "transparent"

                            Button {
                                y: 3
                                anchors.fill: parent
                                width: (parent.width / 10) * 4
                                height: parent.height /0.8
                                //focusPolicy: Qt.NoFocus
                                hoverEnabled: false

                                background: Rectangle {
                                    color: "transparent" //Qt.rgba(0, 0, 0, 0.0)
                                    //border.color: "black"
                                    border.width: 0
                                }
                                onClicked: {
                                    adminCtr++
                                }
                                Image {
                                    width: parent.width
                                    height: parent.height
                                    anchors.fill: parent
                                    source: "qrc:/images/logo.png"

                                    fillMode: Image.PreserveAspectFit
                                    mipmap: true
                                    anchors.verticalCenter: parent.verticalCenter
                                }
                            }
                        }
                    }

                    Row { // rechte Seite des Titelbalkens des hauptfensters
                        id: rowRight
                        width: parent.width / 3
                        height: 48//parent.height
                        spacing: width / 24
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        LayoutMirroring.enabled: true
                        Rectangle {// right side margin separator
                            width: 2
                            height: 2
                            color: "transparent"
                        }

                        // Time
                        Button {
                            width: parent.width / 4
                            height: parent.height
                            hoverEnabled: false
                            font.family: Settings.defaultFont
                            background: Rectangle {
                                color: Qt.rgba(0, 0, 0, 0.0)
                                //border.color: "black"
                                border.width: 0
                            }
                            onClicked: {
                                if (adminCtr > 3) {
                                    closeMediaCtrl();
                                    adminPanel.visible = true
                                }
                            }
                            Text {
                                id: time
                                anchors.fill: parent
                                color: Settings.blue120
                                font.pointSize: 20
                                font.family: Settings.defaultFont
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                anchors.verticalCenter: parent.verticalCenter

                                // Update the time
                                Timer {
                                    running: true
                                    interval: 500
                                    repeat: true
                                    onTriggered: {
                                        // No leading zero for the hour
                                        time.text = Qt.formatDateTime(
                                                    new Date(), "h:mm:ss")

                                    }
                                }
                            }
                        }
                         /* buttons zwischen  Uhrzeit und Suchfeld */

                            // Gong Button
                            Image {
                                id: buttonGongIcon
                                width: 32 //parent.width / 10
                                height: 32 //parent.height
                                source: !popUpBell.visible ? "qrc:/images/buttons/gong.png" : "qrc:/images/buttons/gong_gold.png"
                                fillMode: Image.PreserveAspectFit
                                mipmap: true
                                visible:  !stopWatch.visible
                                anchors.verticalCenter: parent.verticalCenter


                                /*
                                MediaPlayer {
                                    id: gong
                                    autoPlay: false
                                    source: "qrc:/audio/gong_DVAG.MP3"
                                    volume: 1.0
                                }
                                */
                                MouseArea {
                                    id: buttonGong
                                    width: parent.width
                                    height: parent.height
                                    onClicked: {
                                        //gong.play();

                                        closeMediaCtrl();
                                        popUpBell.visible = !popUpBell.visible
                                    }
                                   /* onPressed: {

                                        buttonGongIcon.source = "qrc:/images/buttons/gong_gold.png"
                                    }*/
                                    /*onReleased: {

                                        buttonGongIcon.source = "qrc:/images/buttons/gong.png"
                                    }*/
                                }
                            }

                            // Email Button
                            Image {
                                id: buttonEmailIcon
                                width: 32 //parent.width / 10
                                height: 32 //parent.height
                                source: Settings.embeddedWindow.currentIndex
                                        === 11 ? "qrc:/images/buttons/mail_gold.png" : "qrc:/images/buttons/mail.png"
                                fillMode: Image.PreserveAspectFit
                                mipmap: true
                                anchors.verticalCenter: parent.verticalCenter
                                visible: !stopWatch.visible

                                MouseArea {
                                    id: buttonEmail
                                    width: parent.width
                                    height: parent.height
                                    onClicked: {
                                        if (stopWatch.visible)
                                            return
                                        // If Email is not already visible
                                        if (Settings.embeddedWindow.currentIndex !== 11) {
                                            Settings.embeddedWindow.currentIndex = 11
                                            Settings.lastIndex = 11
                                            DVAGLogger.log("Creating new E-Mail...")
                                            Settings.isComposingEmail = true
                                            //Settings.attachmentsModel.clear()
                                            //Settings.exportForm.init()
                                            //Settings.contentArea = Settings.emailForm
                                        } else {
                                            // Close the embeddedWindow
                                            Settings.embeddedWindow.currentIndex = 0
                                            Settings.lastIndex = 0
                                            Settings.isComposingEmail = false
                                            //Settings.exportForm.init()
                                            buttonEmailIcon.source = "qrc:/images/buttons/mail.png"
                                        }
                                        handlePostMainButtonClick()
                                    }
                                    onPressed: {
                                        buttonEmailIcon.source =  "qrc:/images/buttons/mail_gold.png"
                                    }
                                   /* onReleased: {
                                        buttonEmailIcon.source =  "qrc:/images/buttons/mail.png"
                                    }*/
                                }
                            }

                            // Export Button
                            Image {
                                id: buttonExportIcon
                                width: 32 //parent.width / 10
                                height: 32 //parent.height
                                source: Settings.embeddedWindow.currentIndex
                                        === 10 ? "qrc:/images/buttons/export_png.png" : "qrc:/images/buttons/export.png"
                                fillMode: Image.PreserveAspectFit
                                mipmap: true
                                anchors.verticalCenter: parent.verticalCenter
                                visible: !stopWatch.visible

                                MouseArea {
                                    id: buttonExport
                                    width: parent.width
                                    height: parent.height
                                    onClicked: {
                                        if (stopWatch.visible)
                                            return
                                        // If Export is not already visible
                                        if (Settings.embeddedWindow.currentIndex !== 10) {
                                            Settings.isComposingEmail = false
                                            Settings.exportForm.init()
                                            Settings.embeddedWindow.currentIndex = 10
                                            Settings.lastIndex = 10
                                            //Settings.contentArea = Settings.exportForm
                                        } else {
                                            // Close the embeddedWindow
                                            Settings.embeddedWindow.currentIndex = 0
                                            Settings.lastIndex = 0
                                            buttonExportIcon.source = "qrc:/images/buttons/export.png"
                                        }
                                        handlePostMainButtonClick()
                                    }
                                    onPressed: {
                                        buttonExportIcon.source =  "qrc:/images/buttons/export_gold.png"
                                    }
                                /*    onReleased: {
                                        buttonExportIcon.source =  "qrc:/images/buttons/export.png"
                                    }*/
                                }


                            }
                            //  Abmelden Button
                            Image {
                                id: buttonLogoffIcon
                                width: 32 //parent.width / 10
                                height: 32 //parent.height
                                source:  "qrc:/images/buttons/logoff.png"
                                fillMode: Image.PreserveAspectFit
                                mipmap: true
                                anchors.verticalCenter: parent.verticalCenter
                                visible: !stopWatch.visible

                                MouseArea {
                                    id: buttonLogoff
                                    width: parent.width
                                    height: parent.height
                                    onClicked: {
                                        if (stopWatch.visible)
                                            return
                                        reloadApplication.visible = true
                                        closeMediaCtrl();
                                        buttonLogoffIcon.source =  "qrc:/images/buttons/logoff_gold.png"

                                    }

                                }

                            }
                        // Search with Button and Searchfield
                        Row {
                            id: search
                            width: parent.width
                            height: parent.height
                            LayoutMirroring.enabled: true
                            visible: !stopWatch.visible
                         /*   BorderImage {
                                id: name
                                source: "file"
                                width: 200; height: 100
                                border.left: 5; border.top: 5
                                border.right: 5; border.bottom: 5

                            }*/

                            // Searchfield
                            NeoTextField {
                                id: searchField
                                visible: true
                                width: parent.width
                                height: 48//parent.height
                                anchors.verticalCenter: parent.verticalCenter
                                font.pointSize: 14
                                placeholderText: "Übergreifende Suche"
                                rightPadding : 60

                                background: Rectangle {
                                    width: parent.width
                                    height: parent.height
                                    color: "white"
                                    //opacity: 0.75
                                    border.color: "#8D8D8D"
                                    radius: 25
                                }
                                onEnterPressed: {
                                    // Show or close the textfield
                                    //searchField.visible = !searchField.visible
                                    Settings.searchFieldText = searchField.text
                                    // Reload the search results
                                    Settings.loader9.source = ""
                                    Settings.loader9.source
                                            = "qrc:/src/mainwindow/GlobalSearch.qml"
                                    Settings.embeddedWindow.currentIndex = 9
                                    Settings.lastIndex = 9
                                }
                                // Search Button (Lupe)
                                Image {
                                    id: searchImg
                                    width: parent.width / 10
                                    height: 32 //parent.height
                                    source: searchField.visible ? "qrc:/images/buttons/search.png" : "qrc:/images/buttons/search_gold.png"
                                    fillMode: Image.PreserveAspectFit
                                    mipmap: true
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right

                                    MouseArea {
                                        id: buttonSearchIcon
                                        width: parent.width
                                        height: 32 //parent.height
                                        onClicked: {
                                            // Show or close the textfield
                                            //searchField.visible = !searchField.visible
                                            Settings.searchFieldText = searchField.text
                                            // Reload the search results
                                            Settings.loader9.source = ""
                                            Settings.loader9.source
                                                    = "qrc:/src/mainwindow/GlobalSearch.qml"
                                            Settings.embeddedWindow.currentIndex = 9
                                            Settings.lastIndex = 9
                                        }
                                    }
                                }


                                // Idle animation while the thread is searching
                                BusyIndicator {
                                    id: busyIndicator
                                    width: parent.width
                                    height: parent.height
                                    running: true
                                    visible: false
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }
				}
                // Content des Main Fensters
				Row {
					id: row
                    width: parent.width - 30
                    height: (parent.height / 30) * 28 - 5
                    spacing: 30
                    padding: 30
                    anchors.horizontalCenter: parent.horizontalCenter

                    // Main-Button Column on the left side of the EmbeddedWindow
					Column {
						id: column_buttons
                        height: 835 //(parent.height / 10) * 7
                        width: 223 //(parent.width / 7)
                        spacing: column_buttons.height / 9 - 2
                        anchors.verticalCenter : parent.verticalCenter
                        // buttons
						ButtonMainWindow {
							id: button_presentation
                            imgSource: "qrc:/images/main_presentation_white.png"
                            //textButton: "Präsentation"
							visible: !stopWatch.visible
							onClicked: {
								if (stopWatch.visible)
									return
								// If Presentation is not already visible
								if (Settings.embeddedWindow.currentIndex !== 1) {
									Settings.embeddedWindow.currentIndex = 1
									Settings.lastIndex = 1
								} else {
									// Close the embeddedWindow
									Settings.embeddedWindow.currentIndex = 0
									Settings.lastIndex = 0
								}
                                handlePostMainButtonClick()
							}
						}

						ButtonMainWindow {
							id: button_dav
                            imgSource: "qrc:/images/main_cloud_white.png"
                            //textButton: "Cloud"
							visible: !stopWatch.visible
							onClicked: {
								if (stopWatch.visible)
									return
								// If Dav is not already visible
                                if (Settings.embeddedWindow.currentIndex !== 2) {
                                    Settings.embeddedWindow.currentIndex = 2
                                    Settings.lastIndex = 2
                                    DVAGLogger.log("************ Clouds aktiviert ")
								} else {
									// Close the embeddedWindow
									Settings.embeddedWindow.currentIndex = 0
									Settings.lastIndex = 0
                                    DVAGLogger.log("************ Clouds deaktiviert ")
								}
                                handlePostMainButtonClick()
							}

						}

						ButtonMainWindow {
							id: button_medialibrary
                            imgSource: "qrc:/images/main_media-library_white.png"
                            //textButton: "Mediathek"
							visible: !stopWatch.visible
							onClicked: {
								if (stopWatch.visible)
									return
								// If MediaLibrary is not already visible
								if (Settings.embeddedWindow.currentIndex !== 3) {
									Settings.embeddedWindow.currentIndex = 3
									Settings.lastIndex = 3
								} else {
									// Close the embeddedWindow
									Settings.embeddedWindow.currentIndex = 0
									Settings.lastIndex = 0
								}
                               handlePostMainButtonClick()
							}
						}

						ButtonMainWindow {
							id: button_onlineplatform
                            imgSource: "qrc:/images/main_online-platforms_white.png"
                            //textButton: "Online Plattformen"
							visible: !stopWatch.visible
							onClicked: {
								if (stopWatch.visible)
									return
								// If OnlinePlatform is not already visible
								if (Settings.embeddedWindow.currentIndex !== 4) {
									Settings.embeddedWindow.currentIndex = 4
									Settings.lastIndex = 4
								} else {
									// Close the embeddedWindow
									Settings.embeddedWindow.currentIndex = 0
									Settings.lastIndex = 0
								}
                                handlePostMainButtonClick()
							}
						}
					}

                    // Spacer for the EmbeddedWindow
                    Rectangle {
                        id: embeddedWindowRect
                        width: Settings.embeddedWindowWidth + 45//(parent.width / 8) * 5
                        height: Settings.embeddedWindowHeight
                        color: "transparent"
                        //anchors.centerIn: parent
                    }

					// Column on the right side of the EmbeddedWindow
					Column {
						id: column_buttons2
                        height: 835 //(parent.height / 10) * 7
                        width: 223//(parent.width / 7)
                        spacing: column_buttons2.height / 9 - 2
                        anchors.verticalCenter: parent.verticalCenter

						ButtonMainWindow {
							id: button_whiteboard
                            imgSource: "qrc:/images/main_whiteboard_white.png"
                            //textButton: "Whiteboard"
							visible: !stopWatch.visible
							onClicked: {
								if (stopWatch.visible)
									return
								// If Whiteboard is not already visible
								if (Settings.embeddedWindow.currentIndex !== 5) {
									Settings.embeddedWindow.currentIndex = 5
									Settings.lastIndex = 5
								} else {
									// Close the embeddedWindow
									Settings.embeddedWindow.currentIndex = 0
									Settings.lastIndex = 0
								}
                                handlePostMainButtonClick()
							}
						}

						ButtonMainWindow {
							id: button_screenshot
                            imgSource: "qrc:/images/main_screenshots_white.png"
                            //textButton: "Screenshots"
							visible: !stopWatch.visible
							onClicked: {
                                if (stopWatch.visible)
                                    return
								// If Screenshots is not already visible
								if (Settings.embeddedWindow.currentIndex !== 6) {
									Settings.embeddedWindow.currentIndex = 6
									Settings.lastIndex = 6
                                    //Settings.contentArea = loader6
								} else {
									// Close the embeddedWindow
									Settings.embeddedWindow.currentIndex = 0
									Settings.lastIndex = 0
								}
                                handlePostMainButtonClick()
							}
						}

						ButtonMainWindow {
							id: button_usbimport
                            imgSource: "qrc:/images/main_usb-import_white.png"
                            //textButton: "USB Import"
							visible: !stopWatch.visible
							onClicked: {
								if (stopWatch.visible)
									return
								// If UsbImport is not already visible
								if (Settings.embeddedWindow.currentIndex !== 7) {
									Settings.embeddedWindow.currentIndex = 7
									Settings.lastIndex = 7
								} else {
									// Close the embeddedWindow
									Settings.embeddedWindow.currentIndex = 0
									Settings.lastIndex = 0
								}
                                handlePostMainButtonClick()
							}
						}

						ButtonMainWindow {
							id: button_mediacontrol
                            imgSource: "qrc:/images/main_media-control_white.png"
                            //textButton: "Mediensteuerung"
							visible: !stopWatch.visible
							onClicked: {
								if (stopWatch.visible)
									return
								// If MediaControl is not already visible


								/*
								var f = filemanager.getDataDir() + "/XPanel.c3p";
								filemanager.startProgram("mediacontrol", f);
								//filemanager.setMediaControlVisible(true);
								return;
								*/
								if (Settings.embeddedWindow.currentIndex !== 8) {
                                    Settings.embeddedWindow.currentIndex = 8
                                    Settings.lastIndex = 8

								} else {
									// Close the embeddedWindow
									Settings.embeddedWindow.currentIndex = 0
									Settings.lastIndex = 0
								}
                                handlePostMainButtonClick()
							}
						}
					}
				}
			}
		}

        // projection screen which showns on the Big-Screen
        Rectangle {
            id: rightScreen
            width: Settings.mainWindowWidth
            height: Settings.mainWindowHeight
            color: "white"

            Image {
                id: rightScreenBg
                anchors.fill: parent
                width: Settings.mainWindowWidth
                height: Settings.mainWindowHeight
                source: "qrc:/images/background.jpg"
                //fillMode: Image.PreserveAspectFit
                fillMode: Image.Stretch
                //anchors.bottom: parent.bottom

                //visible: ((Settings.isPresentationMode && !Settings.embeddedWindow.isCurrentIndexZero) || stopWatch.visible)
                visible: true
                // Presentation screen which only shows selected views of the application
                Rectangle {
                    id: presenterScreenBgBlack
                    anchors.fill: parent
                    //x: Settings.mainWindowWidth + 1
                    //y: 0
                    //z: 1
                    width: Settings.mainWindowWidth
                    height: Settings.mainWindowHeight
                    color: (!(Settings.isPresentationMode && !Settings.embeddedWindow.isCurrentIndexZero) || Settings.stopWatch.visible) ? "transparent" : "black"
                    //visible: Settings.isPresentationBgBlackVisible
                    onVisibleChanged: DVAGLogger.log("presenterScreenBgBlack.visible = " + visible)
                    Rectangle {
                        id: presenterScreenBgWhite
                        x: 0
                        y: 0 //(Settings.mainWindowHeight - Settings.embeddedWindowHeight) / 4
                        width: parent.width
                        //* 1.12
                        height: parent.height //(Settings.embeddedWindowContentHeight
                             //    / Settings.embeddedWindowContentWidth) * width
                        //* 1.12 // Scale the height to keep the aspect ratio of the contentArea in the embeddedWindow
                        //color: "white"
                        color: (!(Settings.isPresentationMode && !Settings.embeddedWindow.isCurrentIndexZero) || Settings.stopWatch.visible) ? "transparent" : "white"
                        visible: Settings.isPresentationBgWhiteVisible
                        onVisibleChanged: DVAGLogger.log("presenterScreenBgWhite.visible = " + visible)

                        function restoreColorBinding() {
                            presenterScreenBgWhite.color = Qt.binding(function(){
                                return (!(Settings.isPresentationMode && !Settings.embeddedWindow.isCurrentIndexZero) ||
                                          Settings.stopWatch.visible) ? "transparent" : "white"
                            }
                                                                     )
                        }

                        // Shows the component on the second screen
                        ShaderEffectSource {
                            id: secondView
                            width: parent.width
                            height: parent.height
                            sourceItem: Settings.contentArea
                            mipmap: false

                            anchors.centerIn: parent
                            visible: Settings.isPresentationMode && !Settings.embeddedWindow.isCurrentIndexZero // Only visible if the presentation mode was activated by the user
                            onVisibleChanged: DVAGLogger.log("*********** secondView.visible = " + visible +
                                                             " isPresentationMode " + Settings.isPresentationMode +
                                                             " isCurrentIndexZero = " + Settings.embeddedWindow.isCurrentIndexZero +
                                                             " content area = " + Settings.contentArea)

                            //property double aspectRatio: width / height

                            onXChanged: {
                                DVAGLogger.log("secondView.x = " + secondView.x)
                            }
                            // "Overlay" of the second view
                            // Shows the component which should be shown ontop of the contentArea on the second screen if necessary e.g. the LaserPointer in some cases
                            ShaderEffectSource {
                                id: secondViewSource
                                width: parent.width
                                height: (Settings.embeddedWindowContentHeight / Settings.embeddedWindowContentWidth) * parent.width // Scale the height to keep the aspect ratio of the contentArea in the embeddedWindow
                                sourceItem: Settings.contentAreaEditMode
                                //sourceItem: Settings.contentArea
                                mipmap: false
                                anchors.centerIn: parent
                                visible: Settings.isPresentationMode && !Settings.embeddedWindow.isCurrentIndexZero // Only visible if the presentation mode was activated by the user
                                onVisibleChanged: DVAGLogger.log("secondViewSource.visible = " + visible)
                                onXChanged: {
                                    DVAGLogger.log("secondViewSource.x = " + secondViewSource.x)
                                }
                            }
                        }
                    }
                }
            }
        }

    }

    // Keeps the embeddedWindow
	Item {
		id: embeddedWindow
        width: Settings.isFullscreen ? Settings.mainWindowWidth : Settings.embeddedWindowWidth
        height: Settings.isFullscreen ? Settings.mainWindowHeight : Settings.embeddedWindowHeight
		// Placed ontop of the Spacer inbetween the columns of main window buttons
        x: Settings.isFullscreen ? 0 : column_buttons.width + 97
        y: Settings.isFullscreen ? 0 : Settings.toolBarHeight + (row.height / 12) // (row.height / 10) => Space between the ToolBar and the columns of main window buttons

		// Stores the index of the currently visible loader(view/qml file)
		// 0 = no loader is shown
        property int currentIndex: Settings.embeddedWindow.currentIndex
        property bool isCurrentIndexZero: true

        onIsCurrentIndexZeroChanged: {
            DVAGLogger.log("isCurrentIndexZero = " + isCurrentIndexZero)
        }

        function calculateIsCurrentIndexZero() {
            // 2, 4, 5, 6, 10, 11
            // isCurrentIndexZero = true : hide presenter screen copy		
            DVAGLogger.log("currentIndex = " + currentIndex)

            isCurrentIndexZero = (currentIndex != 1) &&
                    (currentIndex != 2) &&
                    (currentIndex != 3) &&
                    (currentIndex != 4) &&
                    (currentIndex != 5) &&
                    (currentIndex != 6) &&
                    (currentIndex != 9) &&
                    (currentIndex != 10) &&
                    (currentIndex != 11) &&
                    (!stopWatch.visible)

			if (Settings.mediaControlOverlay !== undefined) {
                if (currentIndex == 8) {
                    //Settings.mediaControlOverlay.visible = (currentIndex == 8)
                    Settings.isEditMode = true
					isCurrentIndexZero = true;
                } else {
                    //Settings.mediaControlOverlay.visible = false
                    Settings.isEditMode = false
                }
            }
            //||  //(currentIndex == 2) ||
                            /*(currentIndex == 3) || (currentIndex == 4)*/
            if ( currentIndex == 1 || currentIndex == 9 || currentIndex == 3) {
                isCurrentIndexZero = true
                if ((Settings.loaderNewWindow.visible == true && Settings.loaderNewWindow.source != "") || Settings.isEditMode == true) {
                    isCurrentIndexZero = false
                }
         /*       if (currentIndex == 4) {
                    if (Settings.loader4.source == "qrc:/src/onlineplatform/WebViewPage.qml") {
                        isCurrentIndexZero = false
                    } else {
                        isCurrentIndexZero = true
                    }
                }*/
                if (Settings.mediaPlayerFileType == "audio") {
                    isCurrentIndexZero = true
                }
            }

            // Color the clicked button and reset the color of all other buttons
            colorButtons(currentIndex)
        }

		// If one of the main window buttons was clicked
        onCurrentIndexChanged: {
            calculateIsCurrentIndexZero()
            DVAGLogger.log("GGI ************ currentIndex = " + embeddedWindow.currentIndex + " IS currentIndexZero = " + embeddedWindow.isCurrentIndexZero)
            if (Settings.mediaControlOverlay !== undefined) {
                Settings.mediaControlOverlay.visible = (currentIndex == 8)
            }
		}

		// Presentation
        Loader {
			id: loader1
			visible: parent.currentIndex === 1
			source: "qrc:/src/presentation/Presentation.qml"
		}

		// Dav
		Loader {
			id: loader2
			visible: parent.currentIndex === 2
			//source: "qrc:/src/dav/Dav.qml"
            source: "qrc:/src/medialibraryNc/MediaLibraryNc.qml"
		}

		// MediaLibrary
		Loader {
			id: loader3
			visible: parent.currentIndex === 3
			//source: "qrc:/src/medialibraryNc/MediaLibraryNc.qml"
			source: "qrc:/src/medialibrary/MediaLibrary.qml"
		}

		// OnlinePlatform
		Loader {
			id: loader4
			visible: parent.currentIndex === 4
			source: "qrc:/src/onlineplatform/OnlinePlatform.qml"
		}

		// Whiteboard
		Loader {
			id: loader5
			visible: parent.currentIndex === 5
			source: "qrc:/src/whiteboard/Whiteboard.qml"
		}

		// Screenshots
		Loader {
			id: loader6
			visible: parent.currentIndex === 6
			source: "qrc:/src/screenshots/Screenshots.qml"
		}

		// UsbImport
		Loader {
			id: loader7
			visible: parent.currentIndex === 7
			source: "qrc:/src/usbimport/UsbImport.qml"
		}

		// MediaControl
		Loader {
			id: loader8
            visible: parent.currentIndex === 8 && false
            source: "qrc:/src/mediacontrol/MediaControl.qml"
		}

		// GlobalSearch
		Loader {
			id: loader9
			visible: parent.currentIndex === 9
			source: "qrc:/src/mainwindow/GlobalSearch.qml"
		}

        // Export
        Loader {
			id: loader10
			visible: parent.currentIndex === 10
			source: "qrc:/src/mainwindow/Export.qml"
		}

		// Email
		Loader {
			id: loader11
			visible: parent.currentIndex === 11
			source: "qrc:/src/mainwindow/Email.qml"
		}
        // Splash
        Loader {
            id: loader12
            visible: parent.currentIndex === 12
            source: "qrc:/src/mainwindow/splash.qml"
        }

	}

	// Used in cases where you want to keep the current visible page(in the corresponding loader) and still open a e.g. MediaPlayer on top
	Loader {
		id: loaderNewWindow
		width: Settings.isFullscreen ? Settings.mainWindowWidth : Settings.embeddedWindowWidth
		height: Settings.isFullscreen ? Settings.mainWindowHeight : Settings.embeddedWindowHeight
		// Placed ontop of the EmbeddedWindow
        x: Settings.isFullscreen ? 0 : embeddedWindow.x //column_buttons.width
        y: Settings.isFullscreen ? 0 :  embeddedWindow.y //Settings.toolBarHeight + (row.height / 10) // (row.height / 10) => Space between the ToolBar and the columns of main window buttons
		visible: false

        onVisibleChanged: embeddedWindow.calculateIsCurrentIndexZero()

		// Close the window if it was closed or the visible loader was changed
		Connections {
			target: Settings.embeddedWindow
            onCurrentIndexChanged: function () {
				if (Settings.embeddedWindow.currentIndex !== -1
						&& Settings.embeddedWindow.currentIndex !== -2
						&& Settings.embeddedWindow.currentIndex !== -3) {
                    Settings.loaderNewWindow.visible = false
                    Settings.loaderNewWindow.source = ""
				}
			}
		}
	}

	// Used for the edit mode which should be shown ontop of the current view
	// The current view should not be lost when the edit mode is started --> seperate loader
	Loader {
		id: loaderEditMode
		width: Settings.isFullscreen ? Settings.mainWindowWidth : Settings.embeddedWindowWidth
		height: Settings.isFullscreen ? Settings.mainWindowHeight : Settings.embeddedWindowHeight
		// Placed ontop of the EmbeddedWindow and the NewWindow loader
        x: Settings.isFullscreen ? 0 : embeddedWindow.x //column_buttons.width
        y: Settings.isFullscreen ? 0 :  embeddedWindow.y //Settings.toolBarHeight + (row.height / 10) // (row.height / 10) => Space between the ToolBar and the columns of main window buttons
        visible: false
	}




    /*
      *
      * PopUpWindow for initialize Application
      *
    */
    PopUpWindowWithTwoButtons {
        id: reloadApplication
        visible: false
        anchors.centerIn: embeddedWindow
        text: "Die Präsentationstimeline und alle Dateien in den Ordnern Screenshots und Import löschen?"
        height: 177
        textButton1: ""
        textButton2: "Noch nicht"
        yesButtonImage: "qrc:/images/buttons/logout.png"

        onButton1Clicked: {

            if (Settings.embeddedWindow.currentIndex !== 12) {
                Settings.isPresentationMode = true
                welcomesplash.visible = true
                rightScreenBg.source = "qrc:/images/welcomesplash.png"

                Settings.embeddedWindow.currentIndex = 12
                Settings.lastIndex = 12
                initPresentationForm()

                DVAGLogger.log("Logoff performed currrentindex was NOT 12")
            } else {
                // Close the embeddedWindow
                Settings.embeddedWindow.currentIndex = 0
                Settings.lastIndex = 0
                initPresentationForm()

                DVAGLogger.log("Logoff performed currrentindex was 12")
            }


        }

        onButton2Clicked: {
            // Enable the main window
            rootColumn.enabled = true
            embeddedWindow.enabled = true
            buttonLogoffIcon.source =  "qrc:/images/buttons/logoff.png"
        }
    }

	PopUpWindowBell {
		id: popUpBell
		visible: false
		anchors.centerIn: embeddedWindow
		text: "Gong abspielen in"
		textMin: "Minuten"


		Component.onCompleted: {
			popUpBell.buttonClicked.connect(startStopWatch)
            popUpBell.focus = false
		}

		function startStopWatch() {
			stopWatch.duration = popUpBell.inputValue * 60
			stopWatch.visible = true
			stopWatch.stopWatchTimer.start()

		}
	}

	PopUpWindowPIN {
		id: adminPanel
		x: Settings.mainWindowWidth / 2 - adminPanel.width / 2
		y: 200
		visible: false
		onButtonQuitClicked: {
			visible = false
            //DVAGLogger.log("inputValue = " + inputValue)
            //DVAGLogger.log("filemanager.getSettingQString('PIN') = " + filemanager.getSettingQString(
            //				"PIN"))
            if (inputValue === filemanager.getSettingQString("PIN"))
				Qt.callLater(Qt.quit)
		}
		onButtonCancelClicked: {
			visible = false
		}
	}

    Image {
        id: welcomesplash
        x: 0
        y: 0
        source: "qrc:/images/welcomesplash.png"
        visible: false
        MouseArea {
                id: splashScreen
                width: parent.width
                height: parent.height
                onClicked: {
                    parent.visible = false
                    //NeoManager.restartApplication()
                    rightScreenBg.source = "qrc:/images/background.jpg"
                    initPresentationForm()
                }

        }
    }

    PopUpWindowWithOneButton {
        id: downloadFinishedWin
        x: Settings.mainWindowWidth / 2 - downloadFinishedWin.width / 2
        y: Settings.mainWindowHeight / 2 - downloadFinishedWin.height / 2
        text: "Download beendet"
        visible: false
    }

    Image {
        id: stopWatchBgImg
        width: mainWindow.width / 2
        height: mainWindow.height - Settings.toolBarHeight - 7
        source: "qrc:/images/background.jpg"
        fillMode: Image.Stretch
        anchors.bottom: parent.bottom
        visible: stopWatch.visible
    }

    StopWatch {
        id: stopWatch
        visible: false
        anchors.horizontalCenter: embeddedWindow.horizontalCenter
        anchors.verticalCenter: embeddedWindow.verticalCenter
        anchors.verticalCenterOffset: -100
        width: Settings.mainWindowWidth / 2
        height: Settings.mainWindowHeight / 2
    }

    Rectangle {
		id: stopWatchControl
		width: Settings.mainWindowWidth / 2
		height: 50
		y: Settings.mainWindowHeight / 3 * 2
		anchors.horizontalCenter: embeddedWindow.horizontalCenter
		color: "transparent"
		visible: stopWatch.visible
		onVisibleChanged: {
			btnPause.text = "Pause"
		}

		ButtonEW {
			id: btnPause
			width: 150
			height: 40
			text: "Pause"
			x: btnCancel.x - 200
			onClicked: {
				if (btnPause.text == "Pause") {
					stopWatch.pause = true
					//stopWatch.stopWatchTimer.stop()
					btnPause.text = "Fortfahren"
				} else if (btnPause.text == "Fortfahren") {
					stopWatch.pause = false
					//stopWatch.stopWatchTimer.start()
					btnPause.text = "Pause"
				}
			}
		}

		ButtonEW {
			id: btnCancel
			width: 150
			height: 40
			text: "Abbrechen"
			anchors.horizontalCenter: parent.horizontalCenter
			onClicked: {
				stopWatch.duration = 1
				stopWatch.visible = false
				stopWatch.stopWatchTimer.stop()
				Settings.isPresentationMode = false
			}
		}

		ButtonEW {
			id: btnFinish
			width: 150
			height: 40
			text: "Beenden"
			x: btnCancel.x + 200
			onClicked: {
				// gong.play()
				stopWatch.duration = 1
				stopWatch.visible = false
				Settings.isPresentationMode = false
			}
		}
	}

	Timer {
		id: procMonStatTimer
		running: true
        interval: 1000
        repeat: true
		onTriggered: {
			filemanager.startPowerPointDetectionThread()
            filemanager.abortWindowsSecurityDialog()
		}
	}

	Timer {
		id: adminPanelTimer
		running: true
		interval: 2000
		repeat: true
		onTriggered: {
			adminCtr--
			adminCtr = (adminCtr < 0) ? 0 : adminCtr
		}
	}


	/*
	  *
	  * Functions
	  *
	*/

	function closeMediaCtrl() {
		if (Settings.embeddedWindow.currentIndex === 8) {
			// Close the embeddedWindow
			Settings.embeddedWindow.currentIndex = 0
			Settings.lastIndex = 0
		}
	}

	function colorButtons(currentIndex) {
		// color the clicked button
        var  activeColor = Settings.blue120
        var  inactiveColor = Settings.blue80

		switch (currentIndex) {
		case 1:
            //button_presentation.backgroundColor = activeColor
            button_presentation.imgSource = "qrc:/images/main_presentation.png"
            //button_presentation.textColor = "white"
			break
		case 2:
            //button_dav.backgroundColor = activeColor
            button_dav.imgSource = "qrc:/images/main_cloud.png"
            //button_dav.textColor = "white"
			break
		case 3:
            //button_medialibrary.backgroundColor = activeColor
            button_medialibrary.imgSource = "qrc:/images/main_media-library.png"
            //button_medialibrary.textColor = "white"
			break
		case 4:
            //button_onlineplatform.backgroundColor = activeColor
            button_onlineplatform.imgSource = "qrc:/images/main_online-platforms.png"
            //button_onlineplatform.textColor = "white"
			break
		case 5:
            //button_whiteboard.backgroundColor = activeColor
            button_whiteboard.imgSource = "qrc:/images/main_whiteboard.png"
            //button_whiteboard.textColor = "white"
			break
		case 6:
            //button_screenshot.backgroundColor = activeColor
            button_screenshot.imgSource = "qrc:/images/main_screenshots.png"
            //button_screenshot.textColor = "white"
			break
		case 7:
            //button_usbimport.backgroundColor = activeColor
            button_usbimport.imgSource = "qrc:/images/main_usb-import.png"
            //button_usbimport.textColor = "white"
			break
		case 8:
            //button_mediacontrol.backgroundColor = activeColor
            button_mediacontrol.imgSource = "qrc:/images/main_media-control.png"
            //button_mediacontrol.textColor = "white"
			break
        case 10:
            buttonExportIcon.source = "qrc:/images/buttons/export_gold.png"
            break
        case 11:
            buttonEmailIcon.source = "qrc:/images/buttons/mail_gold.png"
            break
		default:
			break
		}

        if( Settings.lastIndex === currentIndex )
			return;

		// Reset the last colored button to the default color
		switch (Settings.lastIndex) {
		case 1:
            //button_presentation.backgroundColor = inactiveColor
            button_presentation.imgSource = "qrc:/images/main_presentation_white.png"
            //button_presentation.textColor = "black"
			break
		case 2:
            //button_dav.backgroundColor = inactiveColor
            button_dav.imgSource = "qrc:/images/main_cloud_white.png"
            //button_dav.textColor = "black"
			break
		case 3:
            //button_medialibrary.backgroundColor = inactiveColor
            button_medialibrary.imgSource = "qrc:/images/main_media-library_white.png"
            //button_medialibrary.textColor = "black"
			break
		case 4:
            //button_onlineplatform.backgroundColor = inactiveColor
            button_onlineplatform.imgSource = "qrc:/images/main_online-platforms_white.png"
            //button_onlineplatform.textColor = "black"
			break
		case 5:
            //button_whiteboard.backgroundColor = inactiveColor
            button_whiteboard.imgSource = "qrc:/images/main_whiteboard_white.png"
            //button_whiteboard.textColor = "black"
			break
		case 6:
            //button_screenshot.backgroundColor = inactiveColor
            button_screenshot.imgSource = "qrc:/images/main_screenshots_white.png"
            //button_screenshot.textColor = "black"
			break
		case 7:
            //button_usbimport.backgroundColor = inactiveColor
            button_usbimport.imgSource = "qrc:/images/main_usb-import_white.png"
            //button_usbimport.textColor = "black"
			break
		case 8:
            //button_mediacontrol.backgroundColor = inactiveColor
            button_mediacontrol.imgSource = "qrc:/images/main_media-control_white.png"
            //button_mediacontrol.textColor = "black"
			break
        case 10:
            buttonExportIcon.source = "qrc:/images/buttons/export.png"
            break
        case 11:
            buttonEmailIcon.source = "qrc:/images/buttons/mail.png"
            break

		default:
			break
		}
	}


    Timer {
        id: logTimer
        running: true
        repeat: true
        interval: 2000
        onTriggered: {
            //DVAGLogger.log("Settings.contentArea = " + Settings.contentArea + " is Presentation = " + Settings.isPresentationMode)
            /*DVAGLogger.log("Settings.contentAreaEditMode = " + Settings.contentAreaEditMode)
            DVAGLogger.log("Settings.embeddedWindow.isCurrentIndexZero = " + Settings.embeddedWindow.isCurrentIndexZero)
            DVAGLogger.log("Settings.isEditMode = " + Settings.isEditMode)
            DVAGLogger.log("Settings.loader3.source = " + Settings.loader3.source)
            DVAGLogger.log("Settings.loader3.visible = " + Settings.loader3.visible)
            DVAGLogger.log("Settings.loader4.source = " + Settings.loader4.source)
            DVAGLogger.log("Settings.loader4.visible = " + Settings.loader4.visible)
            DVAGLogger.log("Settings.loader9.source = " + Settings.loader9.source)
            DVAGLogger.log("Settings.loader9.visible = " + Settings.loader9.visible)
            DVAGLogger.log("Settings.loaderNewWindow.source = " + Settings.loaderNewWindow.source)
            DVAGLogger.log("Settings.loaderNewWindow.visible = " + Settings.loaderNewWindow.visible)*/
        }
    }

    function initPresentationForm() {
        // Delete files in Import dir
        filemanager.deleteFilesInFolder(filemanager.getImportDir())
        // Delete files in Screenshot dir
        filemanager.deleteFilesInFolder(filemanager.getScreenshotDir())
        // Delete presentation timeline
        filemanager.deleteFile("storyboard.json", filemanager.getStoryboardDir())
        filemanager.deleteFilesInFolder(filemanager.getStoryboardDir())
        if (Settings.cloudsmodule !== null) Settings.cloudsmodule.iniFirstPage()
        if (Settings.emailForm !== null) Settings.emailForm.updateStatus()
        if (Settings.emailForm !== null) Settings.emailForm.initStatus()
        if (Settings.whiteboard !== null) Settings.whiteboard.clearWhiteBoard()
        if (Settings.editmode !== null) Settings.editmode.clearWhiteBoard()
        if (Settings.screenshotview !== null)Settings.screenshotview.clearView()
        Settings.screenshotPresentation = null
        Settings.screenshotName = null
        Settings.screenshotPathEditMode = null

        // Enable the main window
        rootColumn.enabled = true
        embeddedWindow.enabled = true

        // re-read content
        Settings.presentationModule.initModule()
        filemanager.deleteBrowserStorage()
        filemanager.deleteSession()
        filemanager.initWebEngine()


        DVAGLogger.log("&&&&&&& - initilalisierung ist fertig &&&&&&&&&&&&&")
    }



    function handlePostMainButtonClick() {
       
       /* if ( !mediaControlActive ) {
            DVAGLogger.log("!!!!!!!! - handlePostMainButtonClick: schalte presentation modus aus, es sei denn wir wollen nur Medien Control machen")
            Settings.isPresentationMode = false
            Settings.presentationSource.visible = false
        } else {
            DVAGLogger.log("!!!!!!!! - handlePostMainButtonClick: schalte presentation modus EIN")
            Settings.isPresentationMode = true
            Settings.presentationSource.visible = true
            Settings.presentationSourceEditMode.visible = true
            Settings.contentArea.visible = true

        }

        if ((Settings.embeddedWindow.currentIndex && !mediaControlActive )   ) {
            mediaControlActive = false
            Settings.presentationSource.visible = false
        }
        if ((Settings.embeddedWindow.currentIndex === 0  )   ) {
            Settings.presentationSource.visible = false
        }
        //InputPanel.update()*/
        //Settings.isPresentationMode = false
        DVAGLogger.log("Embedded Window has Presentation-Object = " + Settings.embeddedWindow.currentIndex)
    }


}
