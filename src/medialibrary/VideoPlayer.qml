import QtQuick 2.15
import QtMultimedia 6.7
import FileManager 1.0
import DVAGLogger 1.0
import "../settings"

VideoPlayerForm {
	property double durationH
	property double durationM
	property double durationS
	property string convertedNumber

	property string iconPath

    FileManager {
        id: filemanager
    }


    Component.onCompleted: {
        myAudio.volume = volumeSlider.value //Math.pow(volumeSlider.value, 1 / 3.0)/*QtMultimedia.convertVolume(
                    //volumeSlider.value, QtMultimedia.LogarithmicVolumeScale,
                    //QtMultimedia.LinearVolumeScale)*/


		// Used for the second screen view
        Settings.contentArea = myVideoOutput
        DVAGLogger.log("************** VideoPlayer on Completed *****************")

		if (Settings.loader1.visible) {
            myMediaPlayer.source = Settings.videoFilePresentation
			headerText = Settings.videoFilePresentation.substr(
						Settings.videoFilePresentation.lastIndexOf("/") + 1,
						Settings.videoFilePresentation.length)
		} else if (Settings.loader2.visible) {
            myMediaPlayer.source = Settings.videoFileDav
			headerText = Settings.videoFileDav.substr(
						Settings.videoFileDav.lastIndexOf("/") + 1,
						Settings.videoFileDav.length)
		} else if (Settings.loader3.visible) {
            myMediaPlayer.source = Settings.videoFileMediaLibrary
			headerText = Settings.videoFileMediaLibrary.substr(
						Settings.videoFileMediaLibrary.lastIndexOf("/") + 1,
						Settings.videoFileMediaLibrary.length)
		} else if (Settings.loader9.visible) {
            myMediaPlayer.source = Settings.videoFileGlobalSearch
			headerText = Settings.videoFileGlobalSearch.substr(
						Settings.videoFileGlobalSearch.lastIndexOf("/") + 1,
						Settings.videoFileGlobalSearch.length)
		}
        Settings.presenterBgWhite.color = "transparent"
        //myMediaPlayer.onError.connect(handlePlayerError)

	}
    myMediaPlayer.onErrorOccurred: {
        onErrorOccurred: {
               console.log("Fehler aufgetreten: " + error + ", " + errorString)
               // Hier können Sie entsprechend auf den Fehler reagieren
        }
    }

	Component.onDestruction: {
        Settings.presenterBgWhite.restoreColorBinding()
    }

	// Second screen
	Connections {
		target: Settings.embeddedWindow
		onCurrentIndexChanged: {
            //DVAGLogger.log("\\\\\\\\\\\\ CurrentIndex = " + Settings.embeddedWindow.currentIndex )
			if (Settings.embeddedWindow.currentIndex === 1
                    //|| Settings.embeddedWindow.currentIndex === 2
					|| Settings.embeddedWindow.currentIndex === 3
					|| Settings.embeddedWindow.currentIndex === 9) {
				// Only the instance which is visible should "send" its videoOutput
                if (myVideoOutput.visible) {
					// Used for the second screen view
                    Settings.contentArea = myVideoOutput
					Settings.presenterBgWhite.color = "transparent"
                } else {
                    Settings.presenterBgWhite.restoreColorBinding()
                }
			}
		}
	}


	/*
	  *
	  * Header
	  *
	*/
	onOverviewClicked: {
        Settings.loaderNewWindow.visible = false
        Settings.loaderNewWindow.source = ""
		//Settings.contentArea = Settings.embeddedWindow
		Settings.isPresentationMode = false
		Settings.presentationSource.visible = false
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
    }

	// Pause the video if the currently visible embedded window is not the video anymore


	Connections {
		target: Settings.embeddedWindow

		onCurrentIndexChanged: {
			if (myMediaPlayer.playbackState ===  MediaPlayer.PlayingState) {
				myMediaPlayer.pause()
				buttonPlayIcon.source = "qrc:/images/videoplayer/play.png"
			}
		}
	}
	onVisibleChanged: {

		if (!visible && Settings.embeddedWindow.currentIndex !== 8) {

			if (myMediaPlayer.playbackState ===  MediaPlayer.PlayingState) {
					DVAGLogger.log("############### + myMediaPlayer.playbackState " + myMediaPlayer.playbackState)
				myMediaPlayer.pause()
				buttonPlayIcon.source = "qrc:/images/videoplayer/play.png"

			}
		}

	}

	/*
	  *
	  * Content
	  *
	*/
    myMediaPlayer.onPlaybackStateChanged: {
		if (myMediaPlayer.playbackState === MediaPlayer.StoppedState) {
            DVAGLogger.log("onStopped status = " + myMediaPlayer.playbackState)
            buttonPlayIcon.source = "qrc:/images/videoplayer/play.png"
        }
        if (myMediaPlayer.playbackState === MediaPlayer.PausedState) {
            DVAGLogger.log("onPaused status = " + myMediaPlayer.playbackState)
            //buttonPlayIcon.source = "qrc:/images/videoplayer/play.png"
        }
		if (myMediaPlayer.playbackState === MediaPlayer.PlayingState) {
			DVAGLogger.log("onPlaying status = " + myMediaPlayer.playbackState)
            toVideoTime.text = getMsInTimeString(myMediaPlayer.duration)
            //buttonPlayIcon.source = "qrc:/images/videoplayer/pause.png"
        }
        if (myMediaPlayer.playbackState === MediaPlayer.EndOfMedia) {
            DVAGLogger.log("************ End OF MEDIA *************")
            toVideoTime.text = getMsInTimeString(myMediaPlayer.duration)
            //buttonPlayIcon.source = "qrc:/images/videoplayer/pause.png"
            myMediaPlayer.position = 0
            myMediaPlayer.pause()
            buttonPlayIcon.source = "qrc:/images/videoplayer/play.png"
            toVideoTime.text = getMsInTimeString(myMediaPlayer.duration)
            slider.value = 0

        }

    }
	// On autoPlay the duration is not know when the video starts
    myMediaPlayer.onDurationChanged: {
        DVAGLogger.log("onDurationChanged duration = " + myMediaPlayer.duration)
        toVideoTime.text = getMsInTimeString(myMediaPlayer.duration)
	}



	/*
	  *
	  * Footer Left
	  *
	*/
	// Button Play/Pause
	buttonPlay.onClicked: {
        //myMediaPlayer.play()
        if (myMediaPlayer.playbackState === MediaPlayer.PlayingState) {
            myMediaPlayer.pause()
            buttonPlayIcon.source = "qrc:/images/videoplayer/play.png"
		} else {
            myMediaPlayer.play()
            buttonPlayIcon.source = "qrc:/images/videoplayer/pause.png"
        }
	}

	buttonPlay.onPressed: {
		iconPath = buttonPlayIcon.source
		buttonPlayIcon.source = iconPath.substring(
					0, iconPath.length - 4) + "_gold.png"
	}
	buttonPlay.onReleased: {
		iconPath = buttonPlayIcon.source
		buttonPlayIcon.source = iconPath.substring(0,
												   iconPath.length - 9) + ".png"
	}

	// Button Stop
	buttonStop.onClicked: {
		myMediaPlayer.pause()
		myMediaPlayer.position = 0
        buttonPlayIcon.source = "qrc:/images/videoplayer/play.png"
	}
	buttonStop.onPressed: {
		buttonStopIcon.source = "qrc:/images/videoplayer/stop_gold.png"
	}
	buttonStop.onReleased: {
		buttonStopIcon.source = "qrc:/images/videoplayer/stop.png"
	}

	// Volume Slider
	volumeSlider.onValueChanged: {
        myAudio.volume = volumeSlider.value
        //Math.pow(volumeSlider.value, 1 / 3.0) /*QtMultimedia.convertVolume(
                    //volumeSlider.value, QtMultimedia.LogarithmicVolumeScale,
                    //QtMultimedia.LinearVolumeScale)*/
        DVAGLogger.log("Volume = " + myAudio.volume )
	}
    //volumeSliderKnob.onClicked: { }

	/*
	  *
	  * Footer Center
	  *
	*/
	// Used to set the position of the video manually
	slider.onPressedChanged: {
        if (myMediaPlayer.seekable) {
			// Slider has a stepsize of 1 sec., video is in millisec.
            myMediaPlayer.position = slider.value * 1000
            DVAGLogger.log("myMediaPlayer is Seekable ")
		}
	}
    myMediaPlayer.onPositionChanged: {

        currentVideoTime.text = getMsInTimeString(myMediaPlayer.position)
        if (myMediaPlayer.position >= myMediaPlayer.duration) {
            //DVAGLogger.log("onPositionChanged position = " +  " myMediaPlayer.position ******** ENDE ERREICHT *******")
            myMediaPlayer.pause()    // Pause das Video
            myMediaPlayer.position = 0  // Setze Position auf den Anfang
            buttonPlayIcon.source = "qrc:/images/videoplayer/play.png"
        }

    }


	/*
	  *
	  * Footer Right
	  *
	*/
	// Button Edit
	buttonEdit.onClicked: {
		myMediaPlayer.pause()
        buttonPlayIcon.source = "qrc:/images/videoplayer/play.png"
        Settings.startEditMode(true, myVideoOutput)
	}
	buttonEdit.onPressed: {
		buttonEditIcon.source = "qrc:/images/buttons/edit_gold.png"
	}
	buttonEdit.onReleased: {
        buttonEditIcon.source = "qrc:/images/edit.png"
	}

	// Button Screenshot
	buttonScreenshot.onClicked: {
		if (myMediaPlayer.playbackState === MediaPlayer.PlayingState) {
			myMediaPlayer.pause()
			buttonPlayIcon.source = "qrc:/images/videoplayer/play.png"
		}
        Settings.makeScreenshot(myVideoOutput)
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


	/*
	  *
	  * Functions
	  *
	*/
	function getLeadingZero(number) {
		convertedNumber = number
		if (convertedNumber.length < 2) {
			convertedNumber = 0 + convertedNumber
		}
		return convertedNumber
	}

	function getMsInTimeString(videoDuration) {
		durationH = Math.floor(videoDuration / 3600000)
		videoDuration -= durationH * 3600000
		durationM = Math.floor(videoDuration / 60000)
		videoDuration -= durationM * 60000
		durationS = Math.floor(videoDuration / 1000)
		return getLeadingZero(durationH) + ":" + getLeadingZero(
					durationM) + ":" + getLeadingZero(durationS)
	}
}
