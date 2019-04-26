import QtQuick.Controls 2.2
import QtQuick 2.9
import QtQuick.Controls.impl 2.2
import QtQuick.Templates 2.2 as T
import QtQuick.Controls.Universal 2.2

T.Button {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    padding: 8
    topPadding: padding - 4
    bottomPadding: padding - 4
    property int borderWidth: 2
    property int radius: 4

    property bool useSystemFocusVisuals: true

    contentItem: Text {
        text: control.text
        font: control.font
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        opacity: enabled ? 1.0 : 0.2
        color: control.Universal.foreground
    }

    background: Rectangle {
        implicitWidth: 32
        implicitHeight: 32
        radius : radius

        visible: !control.flat || control.down || control.checked || control.highlighted
        color: control.down ? control.Universal.baseMediumLowColor :
               control.enabled && (control.highlighted || control.checked) ? control.Universal.accent :
                                                                             control.Universal.baseLowColor

        Rectangle {
            width: parent.width
            height: parent.height
            color: "transparent"
            border.width: borderWidth
            radius : radius
            opacity: control.hovered ? 0.5 : 1.0
            border.color: control.Universal.foreground
        }
    }
}
