import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.impl 2.2
import QtQuick.Layouts 1.3
import "OctoPrintShared.js" as OPS

PaneBase {
    id : control
    property alias lbfilename: lbfilename
    property alias lbestimated: lbestimated
    property alias lbremaining: lbremaining
    property alias lbfinish: lbfinish

    implicitHeight : 80
    implicitWidth:  200


    function initProgress(file) {
        lbfilename.text=file.path;
        progressBar.value=0;
    }

    function updateProgress() {
        if (OPS.progress.completion) {
            progressBar.value=OPS.progress.completion;
            lbestimated.text= OPS.formatMachineTimeString(OPS.progress.printTime);
            lbremaining.text=  OPS.formatMachineTimeString(OPS.progress.printTimeLeft);
            lbfinish.text= OPS.formatMachineTimeString(OPS.progress.printTimeLeftOrigin);
        } else {
            progressBar.value=0;
        }
    }


    function updateJob() {
        if (OPS.job.file.path) {
            lbfilename.text= OPS.job.file.path;
            lbestimated.text= OPS.formatMachineTimeString(OPS.job.estimatedPrintTime);
            lbremaining.text=OPS.formatMachineTimeString(OPS.job.averagePrintTime);
            lbfinish.text=OPS.formatMachineTimeString(OPS.job.lastPrintTime);
        }
    }


    ColumnLayout {
        id: columnLayout
        spacing: 2
        anchors.fill: parent

        Label {
            id: lbfilename
            text: ""
            font.bold: true
            font.pixelSize: fontSize12
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
            //color: Default.textLightColor
        }

        ProgressBar {
            id: progressBar
            padding: 4
            font.pixelSize: fontSize12
            Layout.fillHeight: true
            Layout.fillWidth: true

            value: 0.0
            from : 0
            to : 100

            background: Rectangle {
                color: Default.focusColor
                width: parent.width
                height: columnLayout.height/4
                radius: 3
            }

            contentItem: Item {
                width:  parent.width
                height: parent.height/4

                Rectangle {
                    width: progressBar.visualPosition * parent.width
                    height: parent.height
                    radius: 2
                }

                Text {
                    id: name
                    text: progressBar.value.toLocaleString(Qt.locale("fr_FR"))+ "%";
                    verticalAlignment: Text.AlignVCenter
                    font.weight: Font.Light
                    //color: control.palette.buttonText
                    font.pixelSize: fontSize10
                    width : parent.width
                    height: parent.height
                }
            }
        }

        RowLayout {
            id: rowLayout
            spacing: 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            Label {
                id : lbestimated
                text: qsTr("0")
                font.bold: false
                font.pixelSize: fontSize10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                leftPadding: 5
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
            Label {
                id : lbremaining
                text: qsTr("0")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                font.bold: false
                font.pixelSize: fontSize10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                rightPadding: 5
                leftPadding: 5
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
            Label {
                id : lbfinish
                text: qsTr("0")
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                font.bold: false
                font.pixelSize: fontSize10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
                rightPadding: 5
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }

    }
}

