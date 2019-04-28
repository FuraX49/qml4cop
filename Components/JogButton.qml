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
    property int radius:  4
    property bool homebutton: false
    property alias image :  image.source
    property bool useSystemFocusVisuals: true
    text: "Z"
    font.pixelSize:  fontSize24
    autoRepeat : homebutton ?  false : true


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
        radius : homebutton ? control.width /2 : control.width / 4

        visible: !control.flat || control.down || control.checked || control.highlighted
        color: control.down ? control.Universal.baseMediumLowColor :
               control.enabled && (control.highlighted || control.checked) ? control.Universal.accent :
                                                                             control.Universal.baseLowColor

        Rectangle {
            width: parent.width
            height: parent.height
            color: "transparent"
            border.width: borderWidth
            radius : homebutton ? control.width /2 : control.width / 4
            opacity: control.hovered ? 0.5 : 1.0
            border.color: control.Universal.foreground
        }
        Image {
            id : image
            width: parent.width  - borderWidth *2
            height: parent.height - borderWidth * 2
            fillMode: Image.PreserveAspectFit
            opacity: 0.3
            anchors.centerIn: parent

        }
    }
}

