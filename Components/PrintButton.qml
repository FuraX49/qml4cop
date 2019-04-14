import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.impl 2.2

Button  {
    id: control

    implicitHeight: 50
    implicitWidth: 50
    property int borderWidth: 2
    property int radius: 4
    property alias source :  image.source

    background:
        Rectangle {
        id : rectControl
        radius: radius
        border.width: borderWidth
        border.color: Default.textColor
        opacity:  control.down || control.highlighted || control.checked ? 0.5 : 1.0
        color: control.down || control.checked || control.highlighted ?    Default.buttonCheckedColor : Default.buttonColor

    }

    Image {
        id : image
        width: parent.width  - borderWidth *2
        height: parent.height - borderWidth * 2
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent
    }
}
