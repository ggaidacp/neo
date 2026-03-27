import QtQuick 2.15
import "../settings"
import DVAGLogger 1.0



Item {
	id: embeddedWindow
    width: Settings.isFullscreen ? Settings.mainWindowWidth : Settings.embeddedWindowWidth
    height: Settings.isFullscreen ? Settings.mainWindowHeight : Settings.embeddedWindowHeight

	property string headerText
	property bool overviewButtonVisiblity: false
	property bool presentationModeVisibility: false
    property bool closeButtonVisiblity: true
    property bool fullScreenVisibility: false
    property bool localsearchavailable: false
	signal overviewClicked
	signal fullscreenClicked
	signal closeClicked
    signal presentationModeVisibility
    property string sliderblue: "qrc:/images/presentation-slider_blue.png"
    property string slidergrey: "qrc:/images/presentation.png"
    property alias buttonlocalSearch : buttonlocalSearch
    property alias buttonlocalSearchIcon : buttonlocalSearchIcon

    /*Connections {
        target: Settings.embeddedWindow
        onCurrentIndexChanged: {
            DVAGLogger.log("EMBEDDED WINDOW CONNECTION CurrentIndex = " +
                           Settings.embeddedWindow.currentIndex +
                           " Last Index = " +
                           Settings.lastIndex +
                           " PresentationVisibility = " + presentationImg.visible)
        }
    }*/

	Rectangle {
		id: root
        width: parent.width
        height: parent.height
		color: Qt.rgba(1, 1, 1, 0.75)
        //border.color: "red"
        //radius: 5
        //Header
		Item {
			width: embeddedWindow.width
            height: Settings.embeddedWindowHeaderHeight
            clip: true
			Rectangle {
				id: headerRect
                //color: Qt.rgba(166 / 255, 136 / 255, 61 / 255, 1) //#A6883D
                color: Qt.rgba(255,255,255,1)
                //radius: 5
				anchors.fill: parent
				anchors.bottomMargin: -radius
                // Zeichne eine blaue Linie unten
                Rectangle {
                    width: parent.width
                    height: 1 // Die Dicke der Linie
                    color: "#337A96"
                    anchors.bottom: parent.bottom
                }
                /*SeparatorLine {
                    anchors.bottom: parent.bottom
                }*/

				Rectangle {
					width: (parent.width / 25) * 2
                    height: parent.height - headerRect.radius
                    color: "transparent"
					visible: embeddedWindow.overviewButtonVisiblity
					anchors.top: parent.top
					anchors.left: parent.left

					MouseArea {
						width: parent.width
						height: parent.height
						onClicked: {
							overviewClicked()
						}
					}

					Row {
						width: parent.width
                        height: parent.height

						Image {
							id: backImg
							width: parent.width / 3
                            height: parent.height -20
							source: "qrc:/images/back_overview.png"
							fillMode: Image.PreserveAspectFit
							anchors.verticalCenter: parent.verticalCenter
						}

						Text {
							width: (parent.width / 3) * 2
                            height: parent.height / 1.2 -20
							text: "Übersicht"
							font.pointSize: Settings.isFullscreen ? 17 : 12
                            color: "#00587C"
							anchors.verticalCenter: parent.verticalCenter
							horizontalAlignment: Text.AlignLeft
							verticalAlignment: Text.AlignVCenter
						}
					}
				}
                // zentral im Titelbalken
				Rectangle {
					width: (parent.width / 25) * 18
					height: parent.height - headerRect.radius
                    color: "transparent"
					anchors.top: parent.top
					anchors.horizontalCenter: parent.horizontalCenter
                    // Window Title
					Text {
						id: headerText
						width: parent.width
						height: parent.height / 1.2
						text: embeddedWindow.headerText
						font.pointSize: Settings.isFullscreen ? 20 : 15
                        color: Settings.blue80
                        clip: true
						horizontalAlignment: (headerText.paintedWidth
											  > width) ? Text.AlignRight : Text.AlignHCenter
						verticalAlignment: Text.AlignVCenter
					}
				}

                Row {
                    width: (parent.width / 25) * 3
                    height: parent.height - headerRect.radius -20
                    anchors.top: parent.top
                    anchors.left: parent.left
                    //anchors.rightMargin: 10
                    LayoutMirroring.enabled: true
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10
                    Item {
                        id: spacekeeper
                        width: 10
                        height: 25
                    }

                    Image {
                        id: closeImg
                        width: 32
                        height: 32
                        source: "qrc:/images/close.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                        visible : closeButtonVisiblity
                        /*anchors.horizontalCenterOffset: 10
                        anchors.rightMargin: 10*/


                        MouseArea {
                            width: parent.width
                            height: parent.height
                            onClicked: {
                                if (Settings.isEditMode) {
                                    closeClicked()
                                    Settings.isEditMode = false
                                } else {
                                    Settings.contentArea = dummyItem
                                    Settings.embeddedWindow.currentIndex = 100
                                    Settings.embeddedWindow.currentIndex = 0
                                    embeddedContentRect.border.color = "transparent"
                                    embeddedContentRect.border.width = 0

                                    Settings.isPresentationMode = false
                                    if (Settings.isFullscreen) {
                                        Settings.isFullscreen = false
                                        Settings.rootColumn.visible = true
                                    }
                                }
                            }
                        }
                    }
					Image {
						id: fullScreenImg
                        width: 32
                        height: 32
                        source: Settings.isFullscreen ? "qrc:/images/default_screen.png" : "qrc:/images/fullscreen.png"
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                        visible : fullScreenVisibility

						MouseArea {
							width: parent.width
							height: parent.height
							onClicked: {
								if (!Settings.isFullscreen) {
									Settings.isFullscreen = true
									Settings.rootColumn.visible = false
								} else {
									Settings.isFullscreen = false
									Settings.rootColumn.visible = true
								}
								fullscreenClicked()
							}
						}
					}
					Image {
						id: presentationImg
                        width: 63
                        height: 32
                        visible: presentationModeVisibility
                        source: Settings.isPresentationMode ? sliderblue : slidergrey
                        fillMode: Image.PreserveAspectFit
						anchors.verticalCenter: parent.verticalCenter

						MouseArea {
                            id: sliderMouseArea
							width: parent.width
							height: parent.height
                            anchors.fill: parent
							onClicked: {
                                Settings.isPresentationMode = !Settings.isPresentationMode
                                if (Settings.isPresentationMode ) {
                                    //Settings.isPresentationMode = true
                                    //currentImage =  sliderblue

                                    Settings.presentationSource.visible = true

                                } else {
                                    //Settings.isPresentationMode = false
                                    //currentImage =  slidergrey

                                    Settings.presentationSource.visible = false
                                }
                                //presentationModeVisibility()
							}
						}
                    }
                    Image {
                        id: buttonlocalSearchIcon
                        width: 32 //parent.width
                        height: 32 //parent.height
                        visible: localsearchavailable
                        source: localsearchavailable.visible ? "qrc:/images/buttons/search_gold.png" : "qrc:/images/buttons/search.png"
                        mipmap: true
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea {
                            id: buttonlocalSearch
                            width: parent.width
                            height: parent.height
                        }
                    }
                }
			}
		}
        //Content
        Item {
            width: Settings.embeddedWindowContentWidth
            height: Settings.embeddedWindowContentHeight
            x: headerRect.x
            y: headerRect.y + headerRect.height
            Rectangle {
                id: embeddedContentRect
                width: parent.width
                height: parent.height
                border.width: Settings.isPresentationMode ? 2 : 0
                border.color: Settings.isPresentationMode ? Settings.blue80 : "transparent"
                anchors.centerIn: parent
                color: "white"
            }
        }
        // Footer
       Item {
			width: embeddedWindow.width
            height: Settings.embeddedWindowFooterHeight
			anchors.bottom: parent.bottom
            clip: true
            //SeparatorLine {}
		}

        // Dummy Item for presentation Mode
        Item {
			id: dummyItem
            width: 0 //Settings.mainWindowWidth
            height: 0 //Settings.mainWindowHeight
            Rectangle {
                width: parent.width
                height: parent.height
            }
        }
	}
}
