import QtQuick 2.9
import QtQuick.Controls 2.2

ToolButton {
    text: ""
    font.pixelSize: fontSize16
    ToolTip.delay: 1000
    ToolTip.timeout: 5000
    ToolTip.text: ""
    ToolTip.visible: hovered

    Image {
        id : icon
        source : ""
        height : Math.round(parent.height *0.8)
        width : Math.round(parent.height *0.8)
    }
}
