import QtQuick 2.15
import QtQuick.Controls 2.2

import ThemeEngine 1.0

Item {
    id: aboutScreen
    width: 480
    height: 720
    anchors.fill: parent

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: rectangleHeader
        color: Theme.colorForeground
        height: 96
        z: 5

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        ImageSvg {
            id: imageLogo
            width: 80
            height: 80
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.verticalCenter: parent.verticalCenter

            source: "qrc:/assets/logos/logo.svg"
            //color: Theme.colorPrimary
        }

        Column {
            anchors.left: imageLogo.right
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: textName
                text: "Sharing is Caring"
                color: Theme.colorText
                font.pixelSize: 28
            }

            Text {
                id: textVersion
                text: qsTr("version %1 %2").arg(utilsApp.appVersion()).arg(utilsApp.appBuildMode())
                color: Theme.colorSubText
                font.pixelSize: 18
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    ScrollView {
        id: scrollView
        contentWidth: -1

        anchors.top: rectangleHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Column {
            anchors.fill: parent
            anchors.rightMargin: 16
            anchors.leftMargin: 16

            topPadding: 8
            bottomPadding: 8
            spacing: 8

            Row {
                id: buttonsRow
                height: 56

                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                visible: (isMobile || isDesktop)
                spacing: 16

                ButtonWireframeImage {
                    id: websiteBtn
                    width: ((parent.width - 16) / 2)
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("WEBSITE")
                    imgSize: 26
                    fullColor: true
                    primaryColor: Theme.colorHeaderContent
                    source: "qrc:/assets/icons_material/baseline-insert_link-24px.svg"
                    onClicked: Qt.openUrlExternally("https://emeric.io/")
                }
                ButtonWireframeImage {
                    id: supportBtn
                    width: ((parent.width - 16) / 2)
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("SUPPORT")
                    imgSize: 20
                    fullColor: true
                    primaryColor: Theme.colorHeaderContent
                    source: "qrc:/assets/icons_material/outline-mail_outline-24px.svg"
                    onClicked: Qt.openUrlExternally("https://emeric.io/")
                }
            }

            Item {
                id: desc
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    id: descImg
                    width: 32
                    height: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/outline-info-24px.svg"
                    color: Theme.colorText
                }

                TextArea {
                    id: description
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorText
                    text: qsTr("Warn other people automatically when you are walking in reverse!")
                    wrapMode: Text.WordWrap
                    readOnly: true
                    font.pixelSize: 16
                }
            }

            Item {
                id: authors
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    id: authorImg
                    width: 31
                    height: 31
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-supervised_user_circle-24px.svg"
                    color: Theme.colorText
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 48
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.verticalCenter: parent.verticalCenter

                    color: Theme.colorText
                    linkColor: Theme.colorText
                    font.pixelSize: 16
                    text: qsTr("Application by <a href=\"https://emeric.io\">Emeric Grange</a>")
                    onLinkActivated: Qt.openUrlExternally(link)

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.NoButton
                        cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                    }
                }
            }

            Item {
                id: rate
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                //visible: (Qt.platform.os === "android" || Qt.platform.os === "ios")

                ImageSvg {
                    id: rateImg
                    width: 31
                    height: 31
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-stars-24px.svg"
                    color: Theme.colorText
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 48
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Rate the application")
                    color: Theme.colorText
                    font.pixelSize: 16

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (Qt.platform.os === "android")
                                Qt.openUrlExternally("")
                            else if (Qt.platform.os === "ios")
                                Qt.openUrlExternally("")
                            else
                                Qt.openUrlExternally("")
                        }
                    }
                }
            }

            Item {
                id: tuto
                height: 48
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.right: parent.right
                anchors.rightMargin: 0

                ImageSvg {
                    id: tutoImg
                    width: 27
                    height: 27
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    anchors.verticalCenter: parent.verticalCenter

                    source: "qrc:/assets/icons_material/baseline-import_contacts-24px.svg"
                    color: Theme.colorText
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 48
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Open the tutorial")
                    color: Theme.colorText
                    font.pixelSize: 16

                    MouseArea {
                        anchors.fill: parent
                        onClicked: screenTutorial.reopen("About")
                    }
                }
            }

            ////////

            Rectangle {
                height: 1
                anchors.right: parent.right
                anchors.left: parent.left
                color: Theme.colorSeparator
            }

            ////////
        }
    }
}
