import QtQuick 2.0
import "../settings"

MouseArea {
	id: laserPointerArea
	width: parent.width
	height: parent.height
	visible: Settings.isPresentationMode

	// Second screen
	Connections {
		target: Settings.embeddedWindow
		onCurrentIndexChanged: {
			// Reset the Laser Pointer
			laserPointer.visible = false
			laserPointerTimer.stop()
		}
	}

	onPressed: {
		laserPointerTimer.stop()
		laserPointer.visible = true
	}
	onMouseXChanged: {
		// Bounding Box
		if (laserPointerArea.mouseX > laserPointerArea.width
				|| laserPointerArea.mouseX < 0) {
			laserPointer.visible = false
		}
		laserPointerTimer.stop()
	}
	onMouseYChanged: {
		// Bounding Box
		if (laserPointerArea.mouseY > laserPointerArea.height
				|| laserPointerArea.mouseY < 0) {
			laserPointer.visible = false
		}
		laserPointerTimer.stop()
	}
	onReleased: {
		laserPointerTimer.start()
	}

	Timer {
		id: laserPointerTimer
		interval: 2000
		running: false
		repeat: false
		onTriggered: {
			laserPointer.visible = false
		}
	}

	LaserPointer {
		id: laserPointer
		x: laserPointerArea.mouseX - (width / 2)
		y: laserPointerArea.mouseY - (height / 2)
		visible: false
	}
}
