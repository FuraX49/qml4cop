import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.impl 2.2
import QtQuick.Controls.Universal 2.2

SpinBox {
    id: control
    property string jogsize: items[0]
    anchors.margins: 5
    spacing: 5
    padding: 0
    from: 0
    value: 0
    to:  items.length -1
    implicitWidth: 120
    implicitHeight: 40

    property int decimals: 1
    property real realValue: value / 10
    property var items: ["0.1", "0.5", "1","5","10","50"]

    textFromValue: function(value, locale) {
        jogsize=items[value];
        return Number(items[value]).toLocaleString(locale, 'f', control.decimals);
    }

    background: Rectangle {
        radius: 4
        color: control.Universal.background
        border.width: 2
        border.color: control.Universal.foreground
     }


}
