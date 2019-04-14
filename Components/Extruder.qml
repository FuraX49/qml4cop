import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.impl 2.2


PaneBase {
    id: extruder
    padding: 3
    spacing: 3
    implicitHeight : 180
    implicitWidth:  80

    property int  tempminimal : 100

    signal extrude(string tool,real amount)
    //signal retract(string tools,string length)
    signal selecttool(string tool)

    function majNbToosl(nb) {
        for (var x = 1; x <nb; x++) {
            lmTools.append({"tool":"tool"+x.toString()});
        }
    }

    property var items: ["1", "5", "10","25","50"]
    property int index : 2


    ColumnLayout {
        id: colroot
        anchors.fill: parent
        spacing: 0

        ComboBox {
            id: cbTool
            Layout.maximumHeight: Math.floor(parent.height / 4)
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 3
            textRole: "tool"
            font.pixelSize: fontSize14
            model: ListModel {
                id: lmTools
                ListElement { tool: "tool0" }
            }
            onCurrentTextChanged: {
               extruder.selecttool(cbTool.currentText);
            }

        }

        RoundButton {
            id: roundButton1
            text: "\u2191 -"
            spacing: 0
            font.weight: Font.ExtraBold
            padding: 0
            font.bold: true
            font.pixelSize: fontSize16
            Layout.maximumHeight: Math.floor(parent.height / 4)
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 3
            onClicked: {
                extruder.extrude(cbTool.currentText,parseFloat("-"+sbLength.text));
            }
        }
        RowLayout {

            Button {
                Layout.fillHeight: true
                Layout.fillWidth: true
                enabled: index>0?true:false
                text: "-"
                onClicked: {
                    if (index>0) index--;
                }
            }
            Label {
                id : sbLength
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHcenter | Qt.AlignVCenter
                text : items[index]
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Button {
                Layout.fillHeight: true
                Layout.fillWidth: true
                text: "+"
                enabled: index<items.length-1
                onClicked: {
                    if (index<items.length-1) index++;
                }
            }
        }

        RoundButton {
            id: roundButton
            text: "\u2193 +"
            spacing: 0
            padding: 0
            font.weight: Font.ExtraBold
            font.bold: true
            font.pixelSize:  fontSize16
            Layout.maximumHeight: Math.floor(parent.height / 4)
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 3
            onClicked: {
                extruder.extrude(cbTool.currentIndex.toString(),sbLength.text);
            }
        }
    }
}
