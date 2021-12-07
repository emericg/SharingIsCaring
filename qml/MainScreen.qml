import QtQuick 2.15
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.3

import ThemeEngine 1.0

Item {
    id: mainScreen
    width: 480
    height: 720
    anchors.fill: parent
    anchors.leftMargin: screenPaddingLeft
    anchors.rightMargin: screenPaddingRight

    function backPressed() {
        if (fileDialogQML.visible) {
            fileDialogQML.visible = false
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    FileDialog {
        id: fileDialogQt
        title: "Please choose a file"
        folder: shortcuts.home

        onAccepted: {
            console.log("fileDialogQt::onAccepted() " + fileDialogQt.fileUrl)

            utilsFiles.useAsQFile(fileDialogQt.fileUrl)

            imgPick.source = fileDialogQt.fileUrl
            //textPick.text = fileDialogQt.fileUrl
        }
        onRejected: {
            console.log("fileDialogQt::onRejected()")
        }
    }

    FileDialogQML {
        id: fileDialogQML
        title: "Please choose a file"
        //folder: shortcuts.home

        onAccepted: {
            console.log("fileDialogQt::onAccepted() " + fileDialogQt.fileUrl)

            utilsFiles.useAsQFile(fileDialogQt.fileUrl)

            imgPick.source = fileDialogQt.fileUrl
            //textPick.text = fileDialogQt.fileUrl
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Rectangle {
        id: rectangleContent
        color: Theme.colorForeground

        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: settingsManager.debugMode ? 48 : 0

        Row {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 24
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 24
            height: 40

            ButtonWireframe {
                text: "Qt picker"
                fullColor: true

                onClicked: fileDialogQt.open()
            }

            ButtonWireframe {
                text: "QML picker"
                fullColor: true

                onClicked: fileDialogQML.open()
            }

            ButtonWireframe {
                text: "Java picker"
                fullColor: true
            }
        }

        ////////////////

        Item {
            width: 480
            height: 480
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -28

            Image {
                id: imgPick
                width: 480
                height: 480

                source: ""
                fillMode: Image.PreserveAspectFit

                Rectangle {
                    anchors.fill: parent
                    z: -1
                    color: "#eee"
                }
            }

            TextArea {
                id: textPick
                width: 480
                height: 480
                enabled: text
            }
        }

        ////////////////
/*
        Item {
            width: 256
            height: 256
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -28

            Rectangle {
                id: circleBackground
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: 256
                height: 256
                radius: 128
                color: Theme.colorBackground
            }

            ImageSvg {
                id: imageStill
                width: 180
                height: 180
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -16

                opacity: 1
                source: "qrc:/assets/logos/logo.svg"
                fillMode: Image.PreserveAspectFit
            }
        }
*/
    }

    ////////////////////////////////////////////////////////////////////////////
}
