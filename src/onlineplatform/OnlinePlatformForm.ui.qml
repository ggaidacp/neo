import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtQuick.Shapes 1.15
import DVAGLogger 1.0
import "../settings"
import "../templates"

EmbeddedWindow {
    id: embeddedWindow
    // Header
    headerText: ""
    presentationModeVisibility: false
    property alias intranetTitle: intranetTitle
    property alias socialMediaTitle: socialMediaTitle
    property alias partnersTitle: partnersTitle

    property alias intranetGrid: intranetGrid
    property alias socialMediaGrid: socialMediaGrid
    property alias partnersGrid: partnersGrid
    property alias scrollView: scrollView

    //property alias socialMedia: socialMedia
    //property alias partners: partners
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
                visible: true
                width: 430
                height: 32
                anchors.centerIn: parent
                anchors.verticalCenter: parent.top
                font.pointSize: 14
                placeholderText: "Online Platformen"
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
                        color: "transparent"
                }

            }
        }
        // Content
        Rectangle {
            id: content
            width: embeddedWindow.width
            height: (embeddedWindow.height / 30) * 26
            color: "transparent"
            Rectangle {
                width: parent.width - 4
                height: parent.height - 4
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                ScrollView {
                    id: scrollView
                    width: parent.width
                    height: parent.height
                    contentWidth: parent.width - 20
                    contentHeight: parent.height  * 6 / 4
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                    ScrollBar.vertical.visible: false
                    ScrollBar.horizontal.visible: false
                    ScrollBar.vertical.interactive: true


                    contentItem: Flickable {
                               id: flickable
                               contentWidth: parent.width - 20
                               contentHeight: parent.height * 6 / 4

                               boundsBehavior: Flickable.StopAtBounds

                        Column {
                            width: parent.width
                            height: embeddedWindow.height //* 18 / 80
                            spacing: 15
                            x: 10
                            // Unsere Webseiten Text
                            Text {
                                id: intranetTitle
                                width: parent.width
                                height: parent.height / 9
                                //text: "Unsere Webseiten"
                                font.pixelSize: Settings.isFullscreen ? 48 : 30
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            // Unsere Webseiten Grid

                            GridView {
                                id: intranetGrid
                                width: parent.width * 13 / 30
                                height: embeddedWindow.height / 6
                                anchors.horizontalCenter: parent.horizontalCenter
                                cellWidth: (embeddedWindow.width / 8) + 16
                                interactive: false
                                cellHeight: height - 10
                                delegate: intranetDelegate
                                model: intranetModel
                            }

                            // Space keeper
                            Rectangle {
                                height: 1
                                width:  parent.width
                                color: "white"
                            }

                            // socialMedia Rectangle
                            Rectangle {
                                id: socialMediaTextRect
                                height: embeddedWindow.height * 20 / 100
                                width:  parent.width //embeddedWindow.width / 100 * 98
                                color: "#f8f8f8"
                                // socialmedia Text
                                Column {
                                    height: parent.height
                                    width:  parent.width //embeddedWindow.width / 100 * 98
                                    //anchors.horizontalCenter: parent.horizontalCenter
                                    Text {
                                        id: socialMediaTitle
                                        height: parent.height / 2
                                        width: parent.width
                                        font.pixelSize: Settings.isFullscreen ? 48 : 30
                                        horizontalAlignment: Text.AlignHCenter
                                        //verticalAlignment: Text.AlignVCenter
                                        //y: intranet.y + intranet.height
                                        text: "Die Deutsche Vermögensberatung auf Social Media"
                                        verticalAlignment: Text.verticalAlignment
                                        topPadding: 20
                                    }
                                    // socialmedia Grid
                                    GridView {
                                        id: socialMediaGrid
                                        width: parent.width * 79 / 100
                                        height: parent.height
                                        cellWidth: (embeddedWindow.width / 16) + 30
                                        interactive: false
                                        cellHeight: height
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        anchors.verticalCenter: parent.center
                                        delegate: socialMediaDelegate
                                        model: socialMediaModel
                                    }
                                }
                            }
                        //Partner Sites Text
                            Text {
                                id: partnersTitle
                                width: parent.width //embeddedWindow.width
                                height: embeddedWindow.height / 9
                                //text: "Link zu Partnerseiten"
                                font.pixelSize: Settings.isFullscreen ? 48 : 30
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            GridView {
                                id: partnersGrid
                                width: parent.width * 97 / 100
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                cellWidth: (embeddedWindow.width / 8) + 14
                                cellHeight: 155 //cellWidth * 1.2 // Zeilenabstand
                                interactive: false
                                delegate: partnersDelegate
                                model: partnersModel
                            }
                        }
                    }
                }

            }
        }
        // Footer
        Rectangle {
            width: embeddedWindow.width
            height: Settings.embeddedWindowFooterHeight
            color: "white"
            SeparatorLine {}
        }
    }

}

