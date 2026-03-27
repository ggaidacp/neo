import QtQuick 2.15
import QtQuick.Controls 2.15

import "../settings"
import "../templates"
import DVAGLogger 1.0

EmbeddedWindow {
    id: embeddedWindow
    // Header
    headerText: "Edit Screenshot"
    overviewButtonVisiblity: true
    presentationModeVisibility: true
    // Content
    property alias canvas: canvas
    property alias canvasHidden: canvasHidden
    property var ctx
    property var ctxHidden
    property var history: []
    // Saves the current tool for the mouse events
    property string tool: "pencil"
    // Saves the selected color
    property string currentColor: "black"
    property string borderColor: Settings.grey
    property string borderActiveColor: Settings.blue80
    property int xPosition: canvas.width / 2
    property int yPosition: canvas.height / 2
    property int radius: 20
    property int counter: 0
    property int position

    // For the inital paint of the background picture
    property bool backgroundPainted: false
    // Button overview
    onOverviewClicked: {
        popUpWindowSave.visible = true
        root.enabled = false
    }
    onCloseClicked: {
        popUpWindowSave.visible = true
        root.enabled = false
    }

    // Second screen
    Component.onCompleted: {
        // Used for the second screen view
        Settings.contentAreaEditMode = canvasBackground
        Settings.editmode = embeddedWindow
        Settings.presentationSourceEditMode.visible = true
    }

    // Open the PopUpWindow to give users the option to save their edits before discarding the window
    Connections {
        target: Settings.embeddedWindow
        onCurrentIndexChanged: {
            popUpWindowSave.visible = true
            root.enabled = false
            }
        }

    onFullscreenClicked: {
        position = counter
        loadFromHistory()
    }
    Column {
        id: root
        width: parent.width
        height: parent.height
        // Header
    Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowHeaderHeight
            color: "transparent"
        }
        Rectangle {
            id: canvasBackground
            width: embeddedWindow.width
            height: (embeddedWindow.height / 30) * 26
            color: "transparent"
            Canvas {
                id: canvasHidden
                width: canvas.width
                height: canvas.height
                visible: false
            }
            Rectangle {
                width: parent.width - 4
                height: parent.height - 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                Canvas {
                    id: canvas
                    width: parent.width
                    height: parent.height
                    antialiasing: true
                    smooth: true
                    onPaint: {
                        ctx = canvas.getContext("2d")
                        ctxHidden = canvasHidden.getContext("2d")
                        ctx.miterLimit = 0.1
                        if (!backgroundPainted) {
                            canvas.loadImage(Settings.screenshotPathEditMode)
                           return
                        }
                    }
                    // Gets triggered if history is used
                    onImageLoaded: {
                        // Clear the canvas
                        ctxHidden.clearRect(0, 0, canvasHidden.width,
                                            canvasHidden.height)
                        ctx.clearRect(0, 0, canvas.width, canvas.height)
                        if (!backgroundPainted) {
                                    // Originale Bildmaße ermitteln
                                    //if (Settings.screenshotPathEditMode === "") Settings.screenshotPathEditMode =  Settings.screenshotMediaLibrary
                                    var img = ctx.createImageData(Settings.screenshotPathEditMode)
                                    var originalWidth = img.width
                                    var originalHeight = img.height

                                    DVAGLogger.log("img = " + img + "bild width = " + originalWidth + " bild height = " + originalHeight +
                                                   " Image From File: " + Settings.screenshotPathEditMode )
                                    // Skalierungsfaktor berechnen
                                    var scaleX = parent.width / originalWidth
                                    var scaleY = parent.height / originalHeight
                                    var scaleFactor = Math.min(scaleX, scaleY, 1.0) // 1.0 = nicht größer als Original
                                    DVAGLogger.log("scale X = " + scaleX + " scale Y = " + scaleY)
                                    // Neue Dimensionen berechnen
                                    var drawWidth = originalWidth * scaleFactor
                                    var drawHeight = originalHeight * scaleFactor

                                    // Bild zentriert zeichnen (optional)
                                    var x = (canvas.width - drawWidth) / 2
                                    var y = (canvas.height - drawHeight) / 2

                                    // Bild mit berechneten Dimensionen zeichnen
                                    ctx.drawImage(Settings.screenshotPathEditMode,
                                                  x, y,           // Position
                                                  drawWidth, drawHeight)  // Skalierte Größe

                            //ctx.drawImage(Settings.screenshotPathEditMode, 0, 0)
                            backgroundPainted = true
                            counter = -1
                            saveToHistory()
                        } else {
                        // Draw the loaded img onto the canvas
                        ctx.drawImage(history[position], 0, 0)
                    }
                    }
                    Rectangle {
                        id: eraserCircle
                        visible: false
                        width: slider.value * 2 + 20
                        height: width
                        x: getEraserCircleX()
                        y: getEraserCircleY()
                        color: "transparent"
                        border.color: "black"
                        border.width: 1
                        radius: eraserCircle.width / 2
                    }

                    MouseArea {
                        width: parent.width
                        height: parent.height

                        onPressed: {
                            switch (tool) {
                            case "pencil":
                                ctx.beginPath()
                                ctx.moveTo(mouseX, mouseY)
                                break
                            case "marker":
                                ctx.beginPath()
                                ctx.moveTo(mouseX, mouseY)
                                break
                            case "eraser":
                                ctx.beginPath()
                                ctx.arc(getEraserCircleX() + (eraserCircle.width / 2),
                                        getEraserCircleY() + (eraserCircle.width / 2),
                                        eraserCircle.width / 2,
                                        0, 2 * Math.PI, false)
                                ctx.fillStyle = "white"
                                ctx.fill()
                                break
                            case "textField":
                                textField.visible = true
                                textField.x = mouseX
                                textField.y = mouseY
                                textFieldBox.visible = true
                                textFieldBox.x = mouseX + textField.width
                                textFieldBox.y = mouseY
                                ctx.fillStyle = currentColor
                                tool = "text"
                                break
                            case "text":
                                buttonText.isClicked = false
                                ctx.font = fontSizeModel.get(
                                            textFieldBox.currentIndex).size + "px Arial"
                                ctx.textBaseline = "top"
                                ctx.fillText(textField.text,
                                             textField.x + textField.leftPadding,
                                             textField.y + textField.topPadding)
                                textField.text = ""
                                textField.visible = false
                                textFieldBox.visible = false
                                saveToHistory()
                                break
                            default:
                                break
                            }
                        }

                        onPositionChanged: {
                            switch (tool) {
                                case "pencil":
                                    ctx.globalCompositeOperation = "source-over"
                                    ctx.lineTo(mouseX, mouseY)
                                    ctx.stroke()
                                    break
                                case "marker":
                                    ctx.globalCompositeOperation = "destination-over"
                                    ctx.lineTo(mouseX, mouseY)
                                    ctx.stroke()
                                    break
                                case "eraser":
                                    ctx.beginPath()
                                    ctx.globalCompositeOperation = "destination-out"
                                    ctx.arc(getEraserCircleX() + (eraserCircle.width / 2),
                                            getEraserCircleY() + (eraserCircle.width / 2),
                                            eraserCircle.width / 2,
                                            0, 2 * Math.PI, false)

                                    ctx.fill()
                                    xPosition = mouseX
                                    yPosition = mouseY
                                    break
                                default:
                                    break
                            }

                            canvas.requestPaint()
                            canvasHidden.requestPaint()
                        }

                        onReleased: {
                            switch (tool) {
                                case "pencil":
                                    ctx.closePath()
                                    saveToHistory()
                                    break
                                case "marker":
                                    ctx.closePath()
                                    saveToHistory()
                                    break
                                case "eraser":
                                    ctx.closePath()
                                    saveToHistory()
                                    break
                                default:
                                    break
                            }
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
                }
                NeoTextField {
                    id: textField
                    visible: false
                    bottomPaddingVal: 0
                    width: 200
                    height: font.pixelSize + 10
                    placeholderText: "Text"
                    color: currentColor
                    verticalAlignment : Text.AlignVCenter
                    font.family: Settings.defaultFontLight
                    font.pixelSize: fontSizeModel.get(
                                        textFieldBox.currentIndex).size
                    horizontalAlignment: TextInput.AlignLeft
                    background: Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "white"
                        border.color: Settings.grey
                    }
                }

                ListModel {
                id: fontSizeModel
                ListElement {
                    size: 15
                }
                ListElement {
                    size: 20
                }
                ListElement {
                    size: 25
                }
                ListElement {
                    size: 30
                }
                ListElement {
                    size: 35
                }
                ListElement {
                    size: 40
                }
                ListElement {
                    size: 45
                }
                ListElement {
                    size: 50
                }
            }

                ComboBox {
                id: textFieldBox
                width: 80
                height: textField.height
                visible: false
                font.pixelSize: textField.font.pixelSize
                font.family: Settings.defaultFontLight
                model: fontSizeModel
                currentIndex: 1 //20px
                background:  Rectangle {
                    width: parent.width
                    height: parent.height
                    color: "transparent"
                    border.color: "#8D8D8D"
                   /* Image {
                        width: parent.width /2
                        height: parent.height
                        source: "qrc:/images/buttons/sort_gold.png"
                        anchors.right: parent.right
                    }*/
                }
                popup: Popup {
                    y: parent.height
                    width: parent.width
                    height: contentItem.implicitHeight
                    topPadding: 0
                    bottomPadding: 0
                    contentItem: ListView {
                        id: listView
                        implicitHeight: contentHeight
                        model: fontSizeModel
                        delegate: Component {
                            id: listDelegate
                            Item {
                                width: parent.width
                                height: textList.paintedHeight + 25
                                 MouseArea {
                                    width: parent.width
                                    height: parent.height
                                    onClicked: {
                                        textFieldBox.currentIndex = index
                                        textFieldBox.popup.close()
                                    }
                                }
                                Text {
                                    id: textList
                                    width: parent.width
                                    height: parent.height
                                    text: size
                                    font.pointSize: 12
                                    font.family: Settings.defaultFontLight
                                    color: "black"
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }
                        }
                    }
                    background: Rectangle {
                        width: parent.width
                        height: parent.height
                        color: "transparent"
                        border.color: "#8D8D8D"
                    }
                }
            }

        }

        // Footer
        Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowFooterHeight
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            SeparatorLine {}
            // Left
            Row {
                id: rowLeft
                width: parent.width / 4
                height: parent.height
                spacing: 12
                leftPadding: 28
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                Image {
                    id: buttonBack
                    width: 32 //parent.width / 6
                    height: 32 //parent.height / 2
                    source: "qrc:/images/buttons/back.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        id: ma_back
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            if (counter > 0) {
                                // Get the last but one element of the history array
                                position = counter - 1
                                loadFromHistory()
                                counter--
                            }
                        }
                onPressed: {
                            buttonBack.source = "qrc:/images/buttons/back_gold.png"
                }
                        onReleased: {
                            buttonBack.source = "qrc:/images/buttons/back.png"
                        }
                    }
                }

                Image {
                    id: buttonForward
                    width: 32 //parent.width / 6
                    height: 32 //parent.height / 2
                    source: "qrc:/images/buttons/forward.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        id: ma_forward
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            if (counter + 1 < history.length) {
                                position = counter + 1
                                loadFromHistory()
                                counter++
                            }
                        }
                        onPressed: {
                            buttonForward.source = "qrc:/images/buttons/forward_gold.png"
                        }
                onReleased: {
                            buttonForward.source = "qrc:/images/buttons/forward.png"
                }
                    }
                }
            }

            // Center
            Row {
                id: rowCenter
                width: parent.width / 2
                height: parent.height
                spacing: width / 72
                anchors.centerIn: parent

                NeoSlider {
                    id: slider
                    onValueChanged: {
                        ctx.lineWidth = value
                        eraserCircle.width = value * 2 + 20
                        }
                }

                Image {
                    id: buttonPencil
                    width: 32 //parent.width / 12
                    height: 32 //parent.height / 2
                    source: isClicked ? "qrc:/images/whiteboard/pencil_gold.png" : "qrc:/images/whiteboard/pencil.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                    property bool isClicked: true

                    MouseArea {
                        id: ma_pencil
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            if (!buttonPencil.isClicked) {
                                buttonPencil.isClicked = !buttonPencil.isClicked
                                buttonMarker.isClicked = false
                                buttonText.isClicked = false
                                buttonEraser.isClicked = false
                                tool = "pencil"
                                ctx.lineWidth = 1
                                eraserCircle.visible = false
                                textField.visible = false
                                textFieldBox.visible = false
                                slider.value = 1
                    }
                }
            }
        }

                Image {
                    id: buttonMarker
                    width: 32 //parent.width / 12
                    height: 32 //parent.height / 2
                    source: (tool == "marker") ? "qrc:/images/whiteboard/marker_gold.png" : "qrc:/images/whiteboard/marker.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                    property bool isClicked: false

                    MouseArea {
                        id: ma_marker
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            if (!buttonMarker.isClicked) {
                                buttonPencil.isClicked = false
                                buttonMarker.isClicked = !buttonMarker.isClicked
                                buttonText.isClicked = false
                                buttonEraser.isClicked = false
                                tool = "marker"
                                ctx.lineWidth = 10
                                eraserCircle.visible = false
                                textField.visible = false
                                textFieldBox.visible = false
                                slider.value = 10
                            }
                        }
                    }
                }
                Image {
                    id: buttonEraser
                    width: 32 //parent.width / 12
                    height: 32 //parent.height / 2
                    source: isClicked ? "qrc:/images/whiteboard/eraser_gold.png" : "qrc:/images/whiteboard/eraser.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                    property bool isClicked: false

                    MouseArea {
                        id: ma_eraser
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            if (!buttonEraser.isClicked) {
                                buttonPencil.isClicked = false
                                buttonMarker.isClicked = false
                                buttonText.isClicked = false
                                buttonEraser.isClicked = !buttonEraser.isClicked
                                tool = "eraser"
                                eraserCircle.visible = true
                                textField.visible = false
                                textFieldBox.visible = false
                            }
                        }
                    }
                }
                Image {
                    id: buttonText
                    width: 32 //parent.width / 12
                    height: 32 //parent.height / 2
                    source: isClicked ? "qrc:/images/whiteboard/text_gold.png" : "qrc:/images/whiteboard/text.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter
                    property bool isClicked: false

                    MouseArea {
                        id: ma_text
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            if (!buttonText.isClicked) {
                                buttonPencil.isClicked = false
                                buttonMarker.isClicked = false
                                buttonText.isClicked = !buttonText.isClicked
                                buttonEraser.isClicked = false
                                tool = "textField"
                                eraserCircle.visible = false
                                textField.visible = false
                                textFieldBox.visible = false
                            }
                        }
                    }
                }
                Rectangle { // Farbpalette
                    width: (parent.width / 12) * 3
                    height: (parent.height * 2) / 3
                    color: Qt.rgba(1, 1, 1, 0.5)
                    visible: true
                    anchors.verticalCenter: parent.verticalCenter

        Row {
                        width: (parent.width / 20) * 19
                        height: 32 //(parent.height / 11) * 5
                        spacing: width / 35
            anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter:  parent.verticalCenter
            Rectangle {
                            height: parent.height
                            width: (parent.width / 35) * 12
                color: "white"

                        }
                        // Erste Farbe black
                        Rectangle {
                            id: pal1
                            width: 32 //(parent.width / 35) * 5
                            height: parent.height
                            color: "black"
                            border.color: borderColor
                            border.width: 1
                            radius: 3

                MouseArea {
                                width: parent.width
                                height: parent.height
                                onClicked: {
                                    currentColor = "black"
                                    changeColor(currentColor)
                                    parent.border.color = borderActiveColor
                                    parent.border.width = 2

                    }
                }
            }

            Rectangle {
                            id: pal2
                            width: 32 //(parent.width / 35) * 5
                            height: parent.height
                color: "white"
                            border.color: borderColor
                            border.width: 1
                            radius: 3

                MouseArea {
                                width: parent.width
                                height: parent.height
                                onClicked: {
                                    currentColor = "white"
                                    changeColor(currentColor)
                                    parent.border.color = borderActiveColor
                                    parent.border.width = 2
                    }
                }
            }
            Rectangle {
                            id: pal3
                            width: 32 //(parent.width / 35) * 5
                            height: parent.height
                            color: "#FF1A66"
                            border.color: borderColor
                            border.width: 1
                            radius: 3

                MouseArea {
                                width: parent.width
                                height: parent.height
                                onClicked: {
                                    currentColor = "#FF1A66"
                                    changeColor(currentColor)
                                    parent.border.color = borderActiveColor
                                    parent.border.width = 2
                                }
                            }
                        }
                        Rectangle {
                            id: pal4
                            width: 32 //(parent.width / 35) * 5
                            height: parent.height
                            color: "#FFDD33"
                            border.color: borderColor
                            border.width: 1
                            radius: 3

                            MouseArea {
                                width: parent.width
                                height: parent.height
                                onClicked: {
                                    currentColor = "#FFDD33"
                                    changeColor(currentColor)
                                    parent.border.color = borderActiveColor
                                    parent.border.width = 2
                                }
                            }
                        }
                        Rectangle {
                            id: pal5
                            width: 32 //(parent.width / 35) * 5
                            height: parent.height
                            color: "#00587C"
                            border.color: borderColor
                            border.width: 1
                            radius: 3

                            MouseArea {
                                width: parent.width
                                height: parent.height
                                onClicked: {
                                    currentColor = "#00587C"
                                    changeColor(currentColor)
                                    parent.border.color = borderActiveColor
                                    parent.border.width = 2
                                }
                            }
                        }
                        Rectangle {
                            id: pal6
                            width: 32 //(parent.width / 35) * 5
                            height: parent.height
                            color: "#7A9A01"
                            border.color: borderColor
                            border.width: 1
                            radius: 3

                            MouseArea {
                                width: parent.width
                                height: parent.height
                                onClicked: {
                                    currentColor = "#7A9A01"
                                    changeColor(currentColor)
                                    parent.border.color = borderActiveColor
                                    parent.border.width = 2
                                }
                            }
                        }


                        Rectangle {
                            id: pal7
                            width: 32 //(parent.width / 35) * 5
                            height: parent.height
                            color: "#9D2235"
                            border.color: borderColor
                            border.width: 1
                            radius: 3

                            MouseArea {
                                width: parent.width
                                height: parent.height
                                onClicked: {
                                    currentColor = "#9D2235"
                                    changeColor(currentColor)
                                    parent.border.color = borderActiveColor
                                    parent.border.width = 2
                                }
                            }
                        }

                        Rectangle {
                            id: pal8
                            width: 32 //(parent.width / 35) * 5
                            height: parent.height
                            color: "#5C068C"
                            border.color: borderColor
                            border.width: 1
                            radius: 3

                            MouseArea {
                                width: parent.width
                                height: parent.height
                                onClicked: {
                                    currentColor = "#5C068C"
                                    changeColor(currentColor)
                                    parent.border.color = borderActiveColor
                                    parent.border.width = 2
                                }
                            }
                        }
                    }
                }
            }

            // Footer Right
            Row {
                id: rowRight
                width: parent.width / 4
                height: parent.height
                spacing: 12
                rightPadding: 28
                anchors.left: parent.left
                LayoutMirroring.enabled: true

                Image {
                    id: buttonScreenshot
                    width: 32
                    height: 32
                    source: "qrc:/images/buttons/screenshot.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        id: ma_screenshot
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            eraserCircle.visible = false
                            Settings.makeScreenshot(canvasBackground)
                            // Show the screenshot taken popUpWindow
                            popUpWindowScreenshotTaken.visible = true
                            // Disable everything "under" the popup
                            root.enabled = false
                        }
                        onPressed: {
                            buttonScreenshot.source = "qrc:/images/buttons/screenshot_gold.png"
                        }
                        onReleased: {
                            buttonScreenshot.source = "qrc:/images/buttons/screenshot.png"
                        }
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

                        onClicked: {
                                buttonLaserPointer.isClicked = !buttonLaserPointer.isClicked
                            }
                        }
                    }
                }
            }
        }


    /*
      *
      * PopUpWindow if the edit mode was closed, to maybe save the annotations
      *
    */
    PopUpWindowWithTwoButtons {
        id: popUpWindowSave

        onCloseClicked: {
            Settings.loaderEditMode.visible = false
            Settings.loaderEditMode.source = ""
        }
     
        text:  "Möchten Sie ihre Anmerkungen\nals Screenshot speichern?"
        textButton1: "Ja"
        onButton1Clicked: {
            // Makes a screenshot and closes the edit mode in the callback
            // Otherwise there is the possibility that the edit mode is closed before the callback makes the screenshot -> no screenshot
            Settings.makeScreenshotEditMode(canvasBackground)
        }
        textButton2: "Nein"
        onButton2Clicked: {
            Settings.loaderEditMode.visible = false
            Settings.loaderEditMode.source = ""
        }
        visible: false
        anchors.centerIn: parent
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
        onCloseClicked: {
            // Enable everything "under" the popup
            root.enabled = true
        }

        onButtonClicked: {
            // Enable everything "under" the popup
            root.enabled = true
        }
    }

    // Timer for the repaint of the canvas
    Timer {
        id: timer
        interval: 100
        repeat: true
        running: true
        onTriggered: {
            canvas.requestPaint()
        }
    }


    /*
      *
      * Functions
      *
    */
    function saveToHistory() {
        // Increase counter
        counter++
        // Save the img-url into the history array
        history[counter] = canvas.toDataURL()
        // Reset counter if something new was drawn
        position = counter
        // Clear old img-urls in the array
        history = history.slice(0, counter + 1)
    }
    function clearHistory() {
         for (var i = 0; i < counter; i++) {
             history = history.slice(0, i)
         }
         counter = 0
         position = 0
    }

    function loadFromHistory() {
        if (canvas.isImageLoaded(history[position]) || canvas.isImageError(
                    history[position])) {
            ctxHidden.clearRect(0, 0, canvasHidden.width, canvasHidden.height)
            ctx.clearRect(0, 0, canvas.width, canvas.height)
            ctx.drawImage(history[position], 0, 0, canvas.width, canvas.height)
        } else {
            canvas.loadImage(history[position])
        }
    }

    function changeColor(color) {
        ctx.strokeStyle = color
        pal1.border.width = 1
        pal1.border.color = borderColor
        pal2.border.width = 1
        pal2.border.color = borderColor
        pal3.border.width = 1
        pal3.border.color = borderColor
        pal4.border.width = 1
        pal4.border.color = borderColor
        pal5.border.width = 1
        pal5.border.color = borderColor
        pal6.border.width = 1
        pal6.border.color = borderColor
        pal7.border.width = 1
        pal7.border.color = borderColor
        pal8.border.width = 1
        pal8.border.color = borderColor
    }

    // Bounding Box
    // Keep the circle inside of the canvas
    function getEraserCircleX() {
        if (((xPosition - (eraserCircle.width / 2)) <= canvas.x)) {
            return canvas.x
        } else if ((xPosition + (eraserCircle.width / 2)) >= (canvas.x + canvas.width)) {
            return canvas.x + canvas.width - eraserCircle.width
        } else {
            return xPosition - (eraserCircle.width / 2)
        }
    }

    // Bounding Box
    // Keep the circle inside of the canvas
    function getEraserCircleY() {
        if (((yPosition - (eraserCircle.width / 2)) <= canvas.y)) {
            return canvas.y
        } else if ((yPosition + (eraserCircle.width / 2)) >= (canvas.y + canvas.height)) {
            return canvas.y + canvas.height - eraserCircle.width
        } else {
            return yPosition - (eraserCircle.width / 2)
        }
    }
    function clearWhiteBoard () {
        ctxHidden.clearRect(0, 0, canvasHidden.width, canvasHidden.height)
        ctx.clearRect(0, 0, canvas.width, canvas.height)
        clearHistory()
    }
}
