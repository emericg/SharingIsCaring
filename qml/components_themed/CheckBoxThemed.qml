import QtQuick 2.12
import QtQuick.Controls 2.12

import ThemeEngine 1.0

CheckBox {
    id: control
    implicitHeight: Theme.componentHeight

    padding: 4
    spacing: 12
    font.pixelSize: Theme.fontSizeComponent

    indicator: Rectangle {
        x: control.leftPadding
        y: (parent.height / 2) - (height / 2)
        width: 24
        height: 24
        radius: Theme.componentRadius

        color: Theme.colorComponentBackground
        border.width: Theme.componentBorderWidth
        border.color: control.down ? Theme.colorSecondary : Theme.colorComponentBorder

        Rectangle {
            anchors.centerIn: parent
            width: 12
            height: 12
            radius: (Theme.componentRadius / 2)

            color: Theme.colorSecondary
            opacity: control.checked ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 133 } }
        }
    }

    contentItem: Text {
        leftPadding: control.indicator.width + control.spacing
        verticalAlignment: Text.AlignVCenter

        text: control.text
        textFormat: Text.PlainText
        font: control.font
        wrapMode: Text.WordWrap

        color: control.checked ? Theme.colorText : Theme.colorSubText
        opacity: enabled ? 1.0 : 0.33
    }
}
