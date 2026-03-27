import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia 6.7
import "../settings"
import "../templates"

EmbeddedWindow {
	id: embeddedWindow
   /* x: 97
    y: -16*/
	property alias root: root

	// Header
    overviewButtonVisiblity: true
    presentationModeVisibility: true
    fullScreenVisibility: false

	// Content
    property alias myMediaPlayer: myMediaPlayer
    property alias myVideoOutput: myVideoOutput
    property alias myContentArea: myContentArea

    property alias playerbackgroudRect: playerbackgroudRect
    property alias myAudio : myAudio

	// Footer
	// Left
	property alias buttonPlay: buttonPlay
	property alias buttonPlayIcon: buttonPlayIcon
	property alias buttonStop: buttonStop
	property alias buttonStopIcon: buttonStopIcon
	property alias volumeSlider: volumeSlider
    //property alias volumeSliderKnob: volumeSliderKnob
	// Center
	property alias slider: slider
	property alias currentVideoTime: currentVideoTime
	property alias toVideoTime: toVideoTime
	// Right
	property alias buttonEdit: buttonEdit
	property alias buttonEditIcon: buttonEditIcon
	property alias buttonScreenshot: buttonScreenshot
	property alias buttonScreenshotIcon: buttonScreenshotIcon

	// PopUpWindow Screenshot Taken
	property alias popUpWindowScreenshotTaken: popUpWindowScreenshotTaken

	Column {
		id: root
		width: parent.width
		height: parent.height
        //spacing: 1

		// Header
		Rectangle {
			width: embeddedWindow.width
            height: Settings.embeddedWindowHeaderHeight
            color: "transparent"
		}

		// Content
		Rectangle {
            id: playerbackgroudRect
            width:  embeddedWindow.width
            height: (embeddedWindow.height / 30) * 26
            color: "transparent"
            Rectangle {
                id: myContentArea
                width: parent.width - 4
                height: parent.height - 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "transparent"
                    Image {
                        anchors.centerIn: parent
                        width: 353
                        height: 353
                        source: "qrc:/images/fileicons/audio-datei.png"
                        fillMode: Image.PreserveAspectFit
                    }
                }
                // Img is shown if an audio file is played
                Image {
                    id: audioImage
                    width: parent.width / 2
                    height: parent.height / 2
                    visible: Settings.mediaPlayerFileType === "audio"  ? true : false
                    source: "qrc:/images/fileicons/audio.png"
                    fillMode: Image.PreserveAspectFit
                    //mipmap: true
                    anchors.centerIn: parent
                }
                VideoOutput {
                    id: myVideoOutput
                    width: parent.width
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    // Laser Pointer
                    LaserPointerArea {
                        id: laserPointerArea
                        width: parent.width
                        height: parent.height
                        visible: Settings.isPresentationMode
                    }
                }
                MediaPlayer {
                    id: myMediaPlayer
                    autoPlay: true
                    videoOutput: myVideoOutput
                    audioOutput: myAudio
                }
                AudioOutput {
                    id: myAudio
                    volume: volumeSlider.value
                }
            }
		}

        // Footer
        Rectangle {
            width: Settings.embeddedWindowContentWidth
            height: Settings.embeddedWindowFooterHeight
            color: "white"
            SeparatorLine {}
            Row {
                width: parent.width
                height: parent.height
                // Left
                Row {
                    id: rowLeft
                    width: parent.width / 6
                    height: parent.height
                    spacing: width / 20
                    leftPadding : 28
                    anchors.left: parent.left
                    Image {
                        id: buttonPlayIcon
                        width: 32 //parent.width / 6
                        height: 32 //parent.height / 2
                        source: "qrc:/images/videoplayer/pause.png"
                        //fillMode: Image.PreserveAspectFit
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea {
                            id: buttonPlay
                            width: parent.width
                            height: parent.height
                        }
                    }
                    Image {
                        id: buttonStopIcon
                        width: 32 //parent.width / 6
                        height: 32 //parent.height / 2
                        source: "qrc:/images/videoplayer/stop.png"
                        //fillMode: Image.PreserveAspectFit
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter
                        MouseArea {
                            id: buttonStop
                            width: parent.width
                            height: parent.height
                        }
                    }
                }
                // Center
                Row {
                    width: parent.width * 4 / 6
                    height: parent.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 0
                    // Volume Slider
                    Slider {
                        id: volumeSlider
                        width: parent.width * 22 / 100
                        height: parent.height / 2
                        value: 0.5 
                        to: 1.0
                        from: 0.0
                        leftPadding: 0
                        rightPadding: 0
                        //anchors.left: parent.left
                        property real volume
                        handle: Rectangle {
                            x: Math.floor((parent.width - 35) * (volumeSlider.value / volumeSlider.to))
                            Image {
                                source: "qrc:/images/videoplayer/volume-slider-knob.png"  // der Griff
                                width: 35
                                height: 35
                                y: Settings.isFullscreen ? 1 : -1  // Zentriere den Griff vertikal
                            }
                        }
                        background: Rectangle {
                            y: Settings.isFullscreen ? 17 : 15
                            width: parent.width
                            height: 3
                            color: "#DDDDDD"
                            radius: 5
                            //anchors.verticalCenter: parent.verticalCenter
                            Rectangle {
                                width: Math.floor(parent.width * (volumeSlider.value / volumeSlider.to))
                                height: parent.height
                                color: Settings.blue80
                                radius: parent.radius
                            }
                        }
                        anchors.verticalCenter: parent.verticalCenter
                    }

                   // Video-Progress Slider and Text
                    Column {
                        id: columnCenter
                        width: parent.width * 2 / 3
                        height: parent.height / 2 //- 67
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        //topPadding: 40
                        // Play-Fortschrits-Slider
                        Slider {
                            id: slider
                            width: parent.width
                            height: (parent.height / 3) * 2
                            from: 0
                            to: Math.floor(myMediaPlayer.duration / 1000)
                            value: Math.floor(myMediaPlayer.position / 1000)
                            stepSize: 1


                            handle: Rectangle {
                                x: Math.floor(parent.width * (slider.value / slider.to)) //slider.leftPadding + slider.visualPosition * (slider.availableWidth - width) - 5
                                y: slider.topPadding + slider.availableHeight / 2 - height / 2 - 4
                               /* implicitWidth: 8
                                implicitHeight: 20*/
                                color: "transparent"
                                border.width: 0
                                border.color: "red"
                                Image {
                                    //id: handleImage
                                    source: "qrc:/images/whiteboard/slider-circle.png"  // der Griff
                                    width: 30
                                    height: 30
                                    y: -11  // Zentriere den Griff vertikal
                                }
                            }
                            background: Rectangle {
                                width: parent.width
                                height: 3
                                color: "#DDDDDD"
                                radius: 5
                                anchors.verticalCenter: parent.verticalCenter
                                Rectangle {
                                    width: Math.floor(parent.width * (slider.value / slider.to))
                                    height: parent.height
                                    color: Settings.blue80
                                    radius: parent.radius
                                    //y: 4
                                }
                            }
                           //anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Row {
                            width: parent.width
                            height: parent.height / 3
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter : parent.verticalCenter
                            topPadding: 10

                            Text {
                                id: currentVideoTime
                                width: parent.width / 2
                                height: parent.height
                                text: "00:00:00"
                                font.pointSize: 10
                                color: "#8D8D8D"
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignTop

                            }

                            Text {
                                id: toVideoTime
                                width: parent.width / 2
                                height: parent.height
                                text: "00:00:00"
                                font.pointSize: 10
                                color: "#8D8D8D"
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignTop

                            }
                        }
                    }
                }
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
                        width: 32 //parent.width / 6
                        height: 32 //parent.height / 2
                        source: "qrc:/images/buttons/screenshot.png"
                        //fillMode: Image.PreserveAspectFit
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
                        width: 32 //parent.width / 6
                        height: 32 //parent.height / 2
                        source: "qrc:/images/edit.png"
                        //fillMode: Image.PreserveAspectFit
                        mipmap: true
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea {
                            id: buttonEdit
                            width: parent.width
                            height: parent.height
                        }
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
