import QtQuick 2.0
import QtMultimedia 6.7
import "../settings"

Item {
	id: stopWatch
	width: parent.width
	height: parent.height

	property Timer stopWatchTimer: stopWatchTimer
	property int duration: 0
	property bool pause: false

    property var tmpContentArea: null

    onVisibleChanged: {
        Settings.isPresentationMode = stopWatch.visible
        if (stopWatch.visible) {
            if (Settings.contentArea != timeLeft) {
                tmpContentArea = Settings.contentArea
            }
            Settings.contentArea = timeLeft
            Settings.presentationSource.visible = true
        } else {
            if (tmpContentArea != null) {
                Settings.contentArea = tmpContentArea
                tmpContentArea = null
            }
            Settings.presentationSource.visible = Qt.binding(function(){
                return Settings.isPresentationMode && !Settings.embeddedWindow.isCurrentIndexZero })
        }
    }

	Text {
		id: timeLeft
        anchors.fill: parent
		font.pixelSize: 128
        font.family: Settings.defaultFont
		text: ""
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

	Timer {
		id: stopWatchTimer
		interval: 1000
		running: false
		repeat: true

		function strpad(string) {
			return (new Array(3).join("0") + string).slice(-2)
		}

		onTriggered: {
			if (pause)
				return
			var h = Math.floor(duration / 3600)
			var m = strpad(Math.floor(duration / 60) - h * 60)
			var s = strpad(Math.floor(duration) - h * 3600 - m * 60)
			timeLeft.text = h + ":" + m + ":" + s
			if (duration == 0) {

			}
			if (duration <= 0) {
				gong.play()
				stopWatchTimer.stop()
				stopWatch.visible = false
				duration = 1
				return
			}
			duration--
		}

		onRunningChanged: {
			pause = false
            if (stopWatchTimer.running) {
				return
            }
			duration = 0
			var h = Math.floor(duration / 3600)
			var m = strpad(Math.floor(duration / 60) - h * 60)
			var s = strpad(Math.floor(duration) - h * 3600 - m * 60)
			timeLeft.text = h + ":" + m + ":" + s
		}
	}

	MediaPlayer {
		id: gong
		autoPlay: false
		source: "qrc:/audio/gong_DVAG.MP3"
        //volume: 1.0
        audioOutput: audio // Verknüpfung des AudioOutput
    }


    AudioOutput {
            id: audio
            volume: 1.0  // Setzt die Lautstärke auf 50%
    }
}
