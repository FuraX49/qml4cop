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


/*
Button  {
    id: control

    implicitHeight: 50
    implicitWidth: 50
    property int borderWidth: 2
    property int radius: 4
    property bool homebutton: false
    property bool es1: false
    property bool es2: false

    property alias image :  image.source
    text: "Z"
    font.pixelSize:  fontSize24
    font.weight: Font.ExtraBold



    onEs1Changed: {
        esoc.color=Qt.rgba( (es1?1.0:0.0),0.0, (es2?1.0:0.0),1.0);
        esoc.visible=es1||es2;
    }
    onEs2Changed: {
        esoc.color=Qt.rgba( (es1?1.0:0.0),0.0, (es2?1.0:0.0),1.0);
        esoc.visible=es1||es2;
    }

    contentItem: Text {
        text: control.text
        font: control.font
//        opacity: enabled ? 1.0 : 0.3
        //color: control.down ?  Universal.accent : Universal.foreground
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }


    background:
        Rectangle {
        id : rectControl
        radius:   homebutton ? width /2 : width / 4
        border.width: borderWidth
//        opacity: control.down ? 0.5 : 1.0
//        color: control.down || control.checked || control.highlighted ?   Universal.accent :   Universal.foreground
    }

    Image {
        id : image
        width: parent.width  - borderWidth *2
        height: parent.height - borderWidth * 2
        fillMode: Image.PreserveAspectFit
        opacity: 0.3
        anchors.centerIn: parent

    }
    ColorOverlay {
        id : esoc
        anchors.fill: image
        source: image
        color: Qt.rgba( 0.0,0.0, 0.0,1.0);
        visible : false
    }

}
*/
