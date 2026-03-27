import QtQuick 2.0
import Qt5Compat.GraphicalEffects

Item {
	id: redFade
	width: 30
	height: width
    RadialGradient {
		opacity: 0.5
		anchors.fill: parent
		gradient: Gradient {
			GradientStop {
				position: 0.0
				color: "red"
			}
			GradientStop {
				position: 0.5
				color: "transparent"
			}
		}

		Rectangle {
			id: redCircle
			x: (redFade.width / 2) - (width / 2)
			y: (redFade.height / 2) - (height / 2)
			width: 10
			height: width
			radius: width / 2
			color: "red"

			Rectangle {
				id: whiteCircle
				x: (redCircle.width / 2) - (width / 2)
				y: (redCircle.height / 2) - (height / 2)
				width: 5
				height: width
				radius: width / 2
				color: "white"
			}
		}
	}
}

