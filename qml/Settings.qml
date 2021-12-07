import QtQuick 2.9
import QtQuick.Controls 2.2

import ThemeEngine 1.0

Item {
    id: settingsScreen
    width: 480
    height: 720
    anchors.fill: parent
    anchors.leftMargin: screenPaddingLeft
    anchors.rightMargin: screenPaddingRight

    Rectangle {
        id: rectangleHeader
        color: Theme.colorForeground
        height: 80
        z: 5

        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Text {
            id: textTitle
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.top: parent.top
            anchors.topMargin: 12

            text: qsTr("Change persistent settings here!")
            font.pixelSize: 18
            color: Theme.colorText
        }

        Text {
            id: textSubtitle
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 14

            text: qsTr("Because everyone love settings...")
            font.pixelSize: 16
            color: Theme.colorSubText
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    ScrollView {
        id: scrollView
        contentWidth: -1

        anchors.top: rectangleHeader.bottom
        anchors.topMargin: 12
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Column {
            id: column
            anchors.fill: parent
            spacing: 8

            ////////

            Item {
                id: element_theme
                height: 48
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

                ImageSvg {
                    id: image_theme
                    width: 24
                    height: 24
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16

                    color: Theme.colorText
                    source: "qrc:/assets/icons_material/duotone-style-24px.svg"
                }
                Text {
                    id: text_theme
                    height: 40
                    anchors.right: theme_selector.left
                    anchors.rightMargin: 16
                    anchors.left: image_theme.right
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Application theme")
                    font.pixelSize: 16
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                Row {
                    id: theme_selector
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    z: 1
                    spacing: 10

                    Rectangle {
                        id: rectangleLight
                        width: 64
                        height: 32
                        anchors.verticalCenter: parent.verticalCenter

                        radius: 2
                        color: (Theme.currentTheme === ThemeEngine.THEME_LIGHT) ? Theme.colorForeground : "#dddddd"
                        border.color: Theme.colorSecondary
                        border.width: (Theme.currentTheme === ThemeEngine.THEME_LIGHT) ? 2 : 0

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                settingsManager.appTheme = "light"
                            }
                        }

                        Text {
                            id: element1
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter

                            text: qsTr("light")
                            color: "#313236"
                            font.pixelSize: 14
                        }
                    }
                    Rectangle {
                        id: rectangleDark
                        width: 64
                        height: 32
                        anchors.verticalCenter: parent.verticalCenter

                        radius: 2
                        color: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? Theme.colorForeground : "#313236"
                        border.color: Theme.colorSecondary
                        border.width: (Theme.currentTheme === ThemeEngine.THEME_DARK) ? 2 : 0

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                settingsManager.appTheme = "dark"
                            }
                        }

                        Text {
                            id: element
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter

                            text: qsTr("dark")
                            color: "#dddddd"
                            font.pixelSize: 14
                        }
                    }
                }
            }

            ////////

            Item {
                id: element_appThemeAutomode
                height: 48
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

                visible: true

                ImageSvg {
                    id: image_appThemeAutomode
                    width: 24
                    height: 24
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16

                    color: Theme.colorText
                    source: "qrc:/assets/icons_material/duotone-brightness_4-24px.svg"
                }
                Text {
                    id: text_appThemeAutomode
                    height: 40
                    anchors.right: switch_appThemeAutomode.left
                    anchors.rightMargin: 16
                    anchors.left: image_appThemeAutomode.right
                    anchors.leftMargin: 16
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Automatic dark mode")
                    font.pixelSize: 16
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                SwitchThemedMobile {
                    id: switch_appThemeAutomode
                    z: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    Component.onCompleted: checked = settingsManager.appThemeAuto
                    onCheckedChanged: {
                        settingsManager.appThemeAuto = checked
                        Theme.loadTheme(settingsManager.appTheme)
                    }
                }
            }
            Text {
                id: legend_appThemeAutomode
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 16
                topPadding: -12
                bottomPadding: 8

                visible: (element_appThemeAutomode.visible)

                text: qsTr("Dark mode will switch on automatically between 9 PM and 9 AM.")
                wrapMode: Text.WordWrap
                color: Theme.colorSubText
                font.pixelSize: 14
            }

            ////////

            Rectangle {
                height: 1
                anchors.right: parent.right
                anchors.left: parent.left
                color: Theme.colorSeparator
            }

            ////////

            Item {
                id: element_debugMode
                height: 48
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0

                ImageSvg {
                    id: image_debugMode
                    width: 32
                    height: 24
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 12

                    color: Theme.colorText
                    source: "qrc:/assets/icons_material/duotone-bug_report-24px.svg"
                }
                Text {
                    id: text_debugMode
                    height: 40
                    anchors.right: switch_debugMode.left
                    anchors.rightMargin: 16
                    anchors.left: image_debugMode.right
                    anchors.leftMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    text: qsTr("Enable debug mode")
                    font.pixelSize: 16
                    color: Theme.colorText
                    wrapMode: Text.WordWrap
                    verticalAlignment: Text.AlignVCenter
                }

                SwitchThemedMobile {
                    id: switch_debugMode
                    z: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 12
                    anchors.verticalCenter: parent.verticalCenter

                    Component.onCompleted: checked = settingsManager.debugMode
                    onCheckedChanged: {
                        if (checked) utilsApp.getMobileStoragePermissions()
                        settingsManager.debugMode = checked
                    }
                }
            }
            Text {
                id: legend_debugMode
                anchors.left: parent.left
                anchors.leftMargin: 56
                anchors.right: parent.right
                anchors.rightMargin: 16
                topPadding: -12
                bottomPadding: 8
                visible: (element_debugMode.visible && settingsManager.debugMode)

                color: Theme.colorSubText
                text: qsTr("Traces are NOT saved.")
                wrapMode: Text.WordWrap
                font.pixelSize: 14
            }

            ////////

            Rectangle {
                height: 1
                anchors.right: parent.right
                anchors.left: parent.left
                color: Theme.colorSeparator
            }

            ////////

            // MORE HERE

            ////////
        }
    }
}
