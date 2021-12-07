import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12

import ThemeEngine 1.0
import MobileUI 1.0

ApplicationWindow {
    id: appWindow
    minimumWidth: 400
    minimumHeight: 800

    visible: true
    color: Theme.colorBackground
    flags: Qt.Window | Qt.MaximizeUsingFullscreenGeometryHint

    property bool isHdpi: (utilsScreen.screenDpi > 128)
    property bool isDesktop: (Qt.platform.os !== "ios" && Qt.platform.os !== "android")
    property bool isMobile: (Qt.platform.os === "ios" || Qt.platform.os === "android")
    property bool isPhone: ((Qt.platform.os === "ios" || Qt.platform.os === "android") && (utilsScreen.screenSize < 7.0))
    property bool isTablet: ((Qt.platform.os === "ios" || Qt.platform.os === "android") && (utilsScreen.screenSize >= 7.0))

    // Mobile stuff ////////////////////////////////////////////////////////////

    // 1 = Qt.PortraitOrientation, 2 = Qt.LandscapeOrientation
    // 4 = Qt.InvertedPortraitOrientation, 8 = Qt.InvertedLandscapeOrientation
    property int screenOrientation: Screen.primaryOrientation
    property int screenOrientationFull: Screen.orientation
    onScreenOrientationChanged: handleNotchesTimer.restart()

    property int screenPaddingStatusbar: 0
    property int screenPaddingNotch: 0
    property int screenPaddingLeft: 0
    property int screenPaddingRight: 0
    property int screenPaddingBottom: 0

    Timer {
        id: handleNotchesTimer
        interval: 33
        repeat: false
        onTriggered: handleNotches()
    }

    function handleNotches() {
/*
        console.log("handleNotches()")
        console.log("screen width : " + Screen.width)
        console.log("screen width avail  : " + Screen.desktopAvailableWidth)
        console.log("screen height : " + Screen.height)
        console.log("screen height avail  : " + Screen.desktopAvailableHeight)
        console.log("screen orientation: " + Screen.orientation)
        console.log("screen orientation (primary): " + Screen.primaryOrientation)
*/
        if (Qt.platform.os !== "ios") return
        if (typeof quickWindow === "undefined" || !quickWindow) {
            handleNotchesTimer.restart();
            return;
        }

        // Statusbar text color hack
        mobileUI.statusbarTheme = (Theme.themeStatusbar === 0) ? 1 : 0
        mobileUI.statusbarTheme = Theme.themeStatusbar

        // Margins
        var safeMargins = utilsScreen.getSafeAreaMargins(quickWindow)
        if (safeMargins["total"] === safeMargins["top"]) {
            screenPaddingStatusbar = safeMargins["top"]
            screenPaddingNotch = 0
            screenPaddingLeft = 0
            screenPaddingRight = 0
            screenPaddingBottom = 0
        } else if (safeMargins["total"] > 0) {
            if (Screen.orientation === Qt.PortraitOrientation) {
                screenPaddingStatusbar = 20
                screenPaddingNotch = 12
                screenPaddingLeft = 0
                screenPaddingRight = 0
                screenPaddingBottom = 6
            } else if (Screen.orientation === Qt.InvertedPortraitOrientation) {
                screenPaddingStatusbar = 12
                screenPaddingNotch = 20
                screenPaddingLeft = 0
                screenPaddingRight = 0
                screenPaddingBottom = 6
            } else if (Screen.orientation === Qt.LandscapeOrientation) {
                screenPaddingStatusbar = 0
                screenPaddingNotch = 0
                screenPaddingLeft = 32
                screenPaddingRight = 0
                screenPaddingBottom = 0
            } else if (Screen.orientation === Qt.InvertedLandscapeOrientation) {
                screenPaddingStatusbar = 0
                screenPaddingNotch = 0
                screenPaddingLeft = 0
                screenPaddingRight = 32
                screenPaddingBottom = 0
            } else {
                screenPaddingStatusbar = 0
                screenPaddingNotch = 0
                screenPaddingLeft = 0
                screenPaddingRight = 0
                screenPaddingBottom = 0
            }
        } else {
            screenPaddingStatusbar = 0
            screenPaddingNotch = 0
            screenPaddingLeft = 0
            screenPaddingRight = 0
            screenPaddingBottom = 0
        }
/*
        console.log("total:" + safeMargins["total"])
        console.log("top:" + safeMargins["top"])
        console.log("left:" + safeMargins["left"])
        console.log("right:" + safeMargins["right"])
        console.log("bottom:" + safeMargins["bottom"])

        console.log("RECAP screenPaddingStatusbar:" + screenPaddingStatusbar)
        console.log("RECAP screenPaddingNotch:" + screenPaddingNotch)
        console.log("RECAP screenPaddingLeft:" + screenPaddingLeft)
        console.log("RECAP screenPaddingRight:" + screenPaddingRight)
        console.log("RECAP screenPaddingBottom:" + screenPaddingBottom)
*/
    }

    MobileUI {
        id: mobileUI
        property bool isLoading: true

        statusbarTheme: Theme.themeStatusbar
        statusbarColor: isLoading ? "white" : Theme.colorStatusbar
        navbarColor: {
            if (isLoading) return "white"
            if (appContent.state === "Tutorial") return Theme.colorHeader
            if ((appContent.state === "MainScreen") || tabletMenuScreen.visible) return Theme.colorForeground
            return Theme.colorBackground
        }
    }

    MobileHeader {
        id: appHeader
        width: parent.width
        anchors.top: parent.top
    }

    MobileDrawer {
        id: appDrawer
        width: (Screen.primaryOrientation === 1 || parent.width < 480) ? 0.80 * parent.width : 0.50 * parent.width
        height: parent.height
    }

    // Sharing handling ////////////////////////////////////////////////////////

    Connections {
        target: utilsShare
        onShareEditDone: {
            console.log("onShareEditDone + code " + requestCode)
        }
        onShareFinished: {
            console.log("onShareFinished + code " + requestCode)
        }
        onShareNoAppAvailable: {
            console.log("onShareNoAppAvailable + code " + requestCode)
        }
        onShareError: {
            console.log("onShareError + code " + requestCode + " + msg " + message)
        }

        onFileUrlReceived: {
            console.log("onFileUrlReceived + " + url)

            statusRect.visible = true
            if (utilsFiles.useAsQFile(url)) statusRect.color = "green"
            else statusRect.color = "red"
        }
        onFileReceivedAndSaved: {
            console.log("onFileReceivedAndSaved + " + url)

            statusRect.visible = true
            if (utilsFiles.useAsQFile(url)) statusRect.color = "green"
            else statusRect.color = "red"
        }
    }

    // Events handling /////////////////////////////////////////////////////////

    Component.onCompleted: {
        handleNotchesTimer.restart()
        mobileUI.isLoading = false
    }

    Connections {
        target: appHeader
        onLeftMenuClicked: {
            if (appHeader.leftMenuMode === "drawer")
                appDrawer.open()
            else
                appContent.state = "MainScreen"
        }
        onRightMenuClicked: {
            //
        }
    }

    Connections {
        target: Qt.application
        onStateChanged: {
            switch (Qt.application.state) {
            case Qt.ApplicationSuspended:
                //console.log("Qt.ApplicationSuspended")
                break
            case Qt.ApplicationHidden:
                //console.log("Qt.ApplicationHidden")
                break
            case Qt.ApplicationInactive:
                //console.log("Qt.ApplicationInactive")
                break
            case Qt.ApplicationActive:
                //console.log("Qt.ApplicationActive")

                // Check if we need an 'automatic' theme change
                Theme.loadTheme(settingsManager.appTheme);

                break
            }
        }
    }

    Timer {
        id: exitTimer
        interval: 3000
        repeat: false
        onRunningChanged: exitWarning.opacity = running
    }

    // QML /////////////////////////////////////////////////////////////////////

    FocusScope {
        id: appContent
        anchors.top: appHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: appTabletMenu.visible ? appTabletMenu.height : 0

        focus: true
        Keys.onBackPressed: {
            if (Qt.platform.os === "android" || Qt.platform.os === "ios") {
                if (appContent.state === "MainScreen") {

                    screenApplication.backPressed()

                    if (exitTimer.running) Qt.quit()
                    else exitTimer.start()
                } else {
                    appContent.state = "MainScreen"
                }
            }
        }

        Tutorial {
            anchors.fill: parent
            id: screenTutorial
        }
        MainScreen {
            anchors.fill: parent
            id: screenApplication
        }
        Settings {
            anchors.fill: parent
            id: screenSettings
        }
        About {
            anchors.fill: parent
            id: screenAbout
        }

        // Initial state
        state: settingsManager.firstLaunch ? "Tutorial" : "MainScreen"

        onStateChanged: {
            if (state === "MainScreen")
                appHeader.leftMenuMode = "drawer"
            else if (state === "Tutorial")
                appHeader.leftMenuMode = "close"
            else
                appHeader.leftMenuMode = "back"

            if (state === "Tutorial")
                appDrawer.interactive = false;
            else
                appDrawer.interactive = true;
        }

        states: [
            State {
                name: "Tutorial"
                PropertyChanges { target: appHeader; title: qsTr("Welcome"); }
                PropertyChanges { target: screenTutorial; enabled: true; visible: true; }
                PropertyChanges { target: screenApplication; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "MainScreen"
                PropertyChanges { target: appHeader; title: "Sharing is Caring"; }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenApplication; enabled: true; visible: true; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "Settings"
                PropertyChanges { target: appHeader; title: qsTr("Settings"); }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenApplication; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: true; enabled: true; }
                PropertyChanges { target: screenAbout; visible: false; enabled: false; }
            },
            State {
                name: "About"
                PropertyChanges { target: appHeader; title: qsTr("About"); }
                PropertyChanges { target: screenTutorial; enabled: false; visible: false; }
                PropertyChanges { target: screenApplication; enabled: false; visible: false; }
                PropertyChanges { target: screenSettings; visible: false; enabled: false; }
                PropertyChanges { target: screenAbout; visible: true; enabled: true; }
            }
        ]

        Rectangle {
            id: statusRect
            anchors.top: parent.top
            anchors.topMargin: 8
            anchors.left: parent.left
            anchors.leftMargin: 8

            width: 16
            height: 16
            radius: 16
            color: "grey"
            visible: false
        }
    }

    ////////////////
/*
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.BackButton | Qt.ForwardButton

        onClicked: {
            if (appContent.state === "Tutorial") return;

            if (mouse.button === Qt.BackButton) {
                appContent.state = "MainScreen"
            } else if (mouse.button === Qt.ForwardButton) {
                //
            }
        }
    }
*/
    Shortcut {
        sequence: StandardKey.Back
        onActivated: {
            if (appContent.state === "Tutorial" || appContent.state === "MainScreen") return;
            appContent.state = "MainScreen"
        }
    }
    Shortcut {
        sequence: StandardKey.Forward
        onActivated: {
            if (appContent.state !== "MainScreen") return;
            appContent.state = "MainScreen"
        }
    }

    ////////////////

    Rectangle {
        id: appTabletMenu
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        color: Theme.colorTabletmenu
        width: parent.width
        height: 48

        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 1
            opacity: 0.5
            color: Theme.colorTabletmenuContent
        }

        visible: isTablet && (appContent.state != "Tutorial" && appContent.state != "DeviceThermo")

        Row {
            id: tabletMenuScreen
            spacing: 24
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            visible: (appContent.state === "MainScreen" ||
                      appContent.state === "Settings" ||
                      appContent.state === "About")

            ItemMenuButton {
                id: menuMedias
                imgSize: 24

                colorBackground: Theme.colorTabletmenuContent
                colorContent: Theme.colorTabletmenuHighlight
                highlightMode: "text"

                menuText: qsTr("BackUp")
                selected: (appContent.state === "MainScreen")
                source: "qrc:/assets/logos/logo.svg"
                onClicked: appContent.state = "MainScreen"
            }
            ItemMenuButton {
                id: menuSettings
                imgSize: 24

                colorBackground: Theme.colorTabletmenuContent
                colorContent: Theme.colorTabletmenuHighlight
                highlightMode: "text"

                menuText: qsTr("Settings")
                selected: (appContent.state === "Settings")
                source: "qrc:/assets/icons_material/baseline-settings-20px.svg"
                onClicked: appContent.state = "Settings"
            }
            ItemMenuButton {
                id: menuAbout
                imgSize: 24

                colorBackground: Theme.colorTabletmenuContent
                colorContent: Theme.colorTabletmenuHighlight
                highlightMode: "text"

                menuText: qsTr("About")
                selected: (appContent.state === "About")
                source: "qrc:/assets/icons_material/outline-info-24px.svg"
                onClicked: appContent.state = "About"
            }
        }
/*
        Row {
            id: tabletMenuDevice
            spacing: 24
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            signal deviceDatasButtonClicked()
            signal deviceHistoryButtonClicked()
            signal deviceSettingsButtonClicked()

            visible: (appContent.state === "DeviceSensor")

            function setActiveDeviceDatas() {
                menuDeviceDatas.selected = true
                menuDeviceHistory.selected = false
                menuDeviceSettings.selected = false
            }
            function setActiveDeviceHistory() {
                menuDeviceDatas.selected = false
                menuDeviceHistory.selected = true
                menuDeviceSettings.selected = false
            }
            function setActiveDeviceSettings() {
                menuDeviceDatas.selected = false
                menuDeviceHistory.selected = false
                menuDeviceSettings.selected = true
            }

            ItemMenuButton {
                id: menuDeviceDatas
                imgSize: 24

                colorBackground: Theme.colorTabletmenuContent
                colorContent: Theme.colorTabletmenuHighlight
                highlightMode: "text"

                menuText: qsTr("My plants")
                selected: (appContent.state === "DeviceSensor" && appContent.state === "MediaList")
                source: "qrc:/assets/icons_material/duotone-insert_chart-24px.svg"
                onClicked: tabletMenuDevice.deviceDatasButtonClicked()
            }
            ItemMenuButton {
                id: menuDeviceHistory
                imgSize: 24

                colorBackground: Theme.colorTabletmenuContent
                colorContent: Theme.colorTabletmenuHighlight
                highlightMode: "text"

                menuText: qsTr("History")
                selected: (appContent.state === "About")
                source: "qrc:/assets/icons_material/baseline-date_range-24px.svg"
                onClicked: tabletMenuDevice.deviceHistoryButtonClicked()
            }
            ItemMenuButton {
                id: menuDeviceSettings
                imgSize: 24

                colorBackground: Theme.colorTabletmenuContent
                colorContent: Theme.colorTabletmenuHighlight
                highlightMode: "text"

                menuText: qsTr("Settings")
                selected: (appContent.state === "About")
                source: "qrc:/assets/icons_material/baseline-iso-24px.svg"
                onClicked: tabletMenuDevice.deviceSettingsButtonClicked()
            }
        }
*/
    }

    ////////////////////////////////////////////////////////////////////////////

    Text {
        id: exitWarning
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        anchors.horizontalCenter: parent.horizontalCenter

        opacity: 0
        Behavior on opacity { OpacityAnimator { duration: 233 } }

        text: qsTr("Press one more time to exit...")
        textFormat: Text.PlainText
        font.pixelSize: Theme.fontSizeContent
        color: Theme.colorForeground

        Rectangle {
            anchors.fill: parent
            anchors.margins: -8
            z: -1
            radius: 4
            color: Theme.colorSubText
        }
    }
}
