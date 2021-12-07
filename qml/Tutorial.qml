import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import ThemeEngine 1.0

Rectangle {
    width: 480
    height: 720
    anchors.fill: parent

    color: Theme.colorHeader

    property int lastPage: 2
    property string goBackTo: "MainScreen"

    function reopen(goBackScreen) {
        tutorialPages.currentIndex = 0
        appContent.state = "Tutorial"
        goBackTo = goBackScreen
    }

    SwipeView {
        id: tutorialPages
        anchors.fill: parent
        anchors.bottomMargin: 56

        currentIndex: 0
        onCurrentIndexChanged: {
            if (currentIndex < 0) currentIndex = 0
            if (currentIndex > lastPage) {
                currentIndex = 0 // reset
                appContent.state = goBackTo
            }
        }

        ////////

        Item {
            id: page1

            Column {
                id: column
                anchors.right: parent.right
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                spacing: 32

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 32

                    text: qsTr("Welcome to our <b>test application</b> !")
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    font.pixelSize: 18
                    color: Theme.colorIcon
                    horizontalAlignment: Text.AlignHCenter
                }
                ImageSvg {
                    width: 128
                    height: 128
                    anchors.horizontalCenter: parent.horizontalCenter

                    source: "qrc:/assets/icons_material/baseline-backup-24px.svg"
                    color: Theme.colorIcon
                }
                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 32
                    anchors.left: parent.left
                    anchors.leftMargin: 32

                    text: qsTr("rtseysrtuy!")
                    color: Theme.colorIcon
                    font.pixelSize: 18
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }
            }
        }
    }

    ////////

    Text {
        id: pagePrevious
        anchors.left: parent.left
        anchors.leftMargin: 32
        anchors.verticalCenter: pageIndicator.verticalCenter

        visible: (tutorialPages.currentIndex != 0)

        text: qsTr("Previous")
        color: Theme.colorHeaderContent
        font.bold: true
        font.pixelSize: 16

        Behavior on opacity { OpacityAnimator { duration: 100 } }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.opacity = 0.8
            onExited: parent.opacity = 1
            onClicked: tutorialPages.currentIndex--
        }
    }

    Text {
        id: pageNext
        anchors.right: parent.right
        anchors.rightMargin: 32
        anchors.verticalCenter: pageIndicator.verticalCenter

        text: (tutorialPages.currentIndex === lastPage) ? qsTr("Allright!") : qsTr("Next")
        color: Theme.colorHeaderContent
        font.bold: true
        font.pixelSize: 16

        Behavior on opacity { OpacityAnimator { duration: 100 } }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.opacity = 0.8
            onExited: parent.opacity = 1
            onClicked: tutorialPages.currentIndex++
        }
    }

    PageIndicator {
        id: pageIndicator
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 16

        count: 3
        currentIndex: tutorialPages.currentIndex

        delegate: Rectangle {
            implicitWidth: 12
            implicitHeight: 12

            radius: (width / 2)
            color: Theme.colorHeaderContent

            opacity: index === pageIndicator.currentIndex ? 0.95 : pressed ? 0.7 : 0.45

            Behavior on opacity { OpacityAnimator { duration: 100 } }
        }
    }
}
