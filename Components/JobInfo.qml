import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import "OctoPrintShared.js" as OPS

Dialog {
    id: popup
    x: Math.round(parent.width *0.05)
    y: Math.round(parent.height *0.05)
    width:Math.round( parent.width *0.9)
    height:Math.round( parent.height *0.9)
    dim: false

    modal: true
    focus: true
    //closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
    standardButtons: Dialog.Ok

    property var  opsjob : null

    onAccepted: {
        close();
        visible=false;
    }

    function openinfo() {
        opsjob=OPS.job;
        lbfilament.text="";
        for ( var f in opsjob.filament ) {
            lbfilament.text += f +  ":" +  Math.round(opsjob.filament[f].length) + "mm\t"
        }
        popup.visible=true;
        popup.open();
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
    }


    GridLayout {
        id: grid
        columnSpacing: fontSize10
        rowSpacing: fontSize10

        rows: 5
        columns: 2
        anchors.fill: parent


        Label {
            id : lbfile
            text: "File :"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Label {
            id: txt_url
            text:  (opsjob!==null) ? opsjob.file.origin +"/"+ opsjob.file.path : ""
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            Layout.fillHeight: false
            Layout.fillWidth: true
        }

        Label {
            text: "Date :"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true

        }
        Label {
            text: (opsjob!==null)? new Date(opsjob.file.date*1000).toLocaleString(locale,"yyyy/MM/dd HH:mm:ss") :""
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            Layout.fillHeight: false
            Layout.fillWidth: true
        }

        Label {
            text: "Size :"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        Label {
            text: (opsjob!==null)?  Math.round(opsjob.file.size/1024) + "Kb" : ""
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            Layout.fillHeight: false
            Layout.fillWidth: true
        }


        Label {
            text: "Estimated print time :"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        Label {
            text: (opsjob!==null)?  OPS.formatMachineTimeString(opsjob.estimatedPrintTime) : ""
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            Layout.fillHeight: false
            Layout.fillWidth: true
        }

        Label {
            text: "Time of the last print :"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        Label {
            text: (opsjob!==null)?  OPS.formatMachineTimeString(opsjob.lastPrintTime):""
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            Layout.fillHeight: false
            Layout.fillWidth: true
        }

        Label {
            text: "filaments :"
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        Label {
            id : lbfilament
            text: "";
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            Layout.fillHeight: false
            Layout.fillWidth: true
        }
    }

}

