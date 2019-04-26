import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Templates 2.2 as T
import QtQuick.Controls.Universal 2.2

T.ToolButton {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 6

    property bool useSystemFocusVisuals: true

    font.pixelSize: fontSize14
    ToolTip.delay: 1000
    ToolTip.timeout: 5000
    ToolTip.text: ""
    ToolTip.visible: hovered

    contentItem: Text {
        text: control.text
        font: control.font
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter

        opacity: enabled ? 1.0 : 0.2
        color: control.Universal.foreground
    }

    background: Rectangle {
        implicitWidth: 68
        implicitHeight: 48 // AppBarThemeCompactHeight

        color: control.enabled && (control.highlighted || control.checked) ? control.Universal.accent : "transparent"

        Rectangle {
            width: parent.width
            height: parent.height
            visible: control.down || control.hovered
            color: control.down ? control.Universal.listMediumColor : control.Universal.listLowColor
        }
    }
}

