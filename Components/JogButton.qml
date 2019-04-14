import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.impl 2.2
import QtGraphicalEffects 1.0


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
    font.pixelSize: fontSize24
    font.weight: Font.ExtraBold


    onEs1Changed: {
        esoc.color=Qt.rgba( (es1?1.0:0.0),0.0, (es2?1.0:0.0),1.0);
        esoc.visible=es1||es2;
    }
    onEs2Changed: {
        esoc.color=Qt.rgba( (es1?1.0:0.0),0.0, (es2?1.0:0.0),1.0);
        esoc.visible=es1||es2;
    }


    background:
        Rectangle {
        id : rectControl
        radius:   homebutton ? width /2 : width / 4
        border.width: borderWidth
        opacity: control.down ? 0.5 : 1.0
        color: control.down || control.checked || control.highlighted ?  Default.buttonCheckedColor : Default.buttonColor
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

