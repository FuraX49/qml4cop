import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "Components"



Page {
    id: jogpage
    property alias lbpX: lbpX
    property alias lbpY: lbpY
    property alias lbpZ: lbpZ


    onVisibleChanged: {
        if (visible)   opc.sendcommand("M114");
    }

    RowLayout {
        id: rowaxes
        height: fontSize12 * 2
        implicitHeight:  60
        implicitWidth:  400
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.margins: fontSize10
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        spacing : fontSize14

        // Coord
        Label {
            id: lbX
            text: qsTr("X:")
            horizontalAlignment: Text.AlignRight
            font.bold: false
            font.pixelSize: fontSize14
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.column : 0
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Label {
            id: lbpX
            text: "000"
            font.bold: true
            font.pixelSize: fontSize14
            horizontalAlignment: Text.AlignLeft | Qt.AlignVCenter
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.column : 1
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Label {
            id: lbY
            text: qsTr("Y:")
            horizontalAlignment: Text.AlignRight
            font.bold: false
            font.pixelSize: fontSize14
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.column : 2
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Label {
            id: lbpY
            text: "000"
            horizontalAlignment: Text.AlignLeft | Qt.AlignVCenter
            font.bold: true
            font.pixelSize: fontSize14
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.column : 3
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
        Label {
            id: lbZ
            text: qsTr("Z:")
            font.bold: false
            font.pixelSize: fontSize14
            horizontalAlignment: Text.AlignRight
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.column : 4
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        Label {
            id: lbpZ
            text: "000"
            font.bold: true
            font.pixelSize: fontSize14
            Layout.column : 5
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }


    GridLayout {
        id: joggrid
        rows: 3
        columns: 6
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        columnSpacing: fontSize12 /2
        rowSpacing: fontSize12 /2
        anchors.margins: fontSize12 /2
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: rowstep.top
        anchors.top: rowaxes.bottom


        // XY

        JogButton {
            id: lX
            text: qsTr("-X")
            image  : "qrc:/Images/jog/left.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 0
            Layout.row : 1
            Layout.fillHeight: true
            Layout.fillWidth: true

            onClicked: {
                opc.jogprinter("X",-step.jogsize);
                opc.sendcommand("M114");
            }
        }

        JogButton {
            id: mY
            text: qsTr("+Y")
            image :  "qrc:/Images/jog/up.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 1
            Layout.row : 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.jogprinter("y",+step.jogsize);
                opc.sendcommand("M114");
            }
        }

        JogButton {
            id: lY
            text: qsTr("-Y")
            image  : "qrc:/Images/jog/down.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 1
            Layout.row : 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.jogprinter("y",-step.jogsize);
                opc.sendcommand("M114");
            }
        }


        JogButton {
            id: mX
            autoExclusive: true
            text: qsTr("+X")
            image  : "qrc:/Images/jog/right.svg"
            homebutton:  false
            autoRepeat: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 2
            Layout.row : 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.jogprinter("X",step.jogsize);
                opc.sendcommand("M114");
            }
        }


        JogButton {
            id: mZ
            text: qsTr("+Z")
            image  : "qrc:/Images/jog/up.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 3
            Layout.row : 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.jogprinter("Z",step.jogsize);
                opc.sendcommand("M114");
            }
        }



        JogButton {
            id: lZ
            text: qsTr("-Z")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            topPadding: 0
            spacing: 0
            image : "qrc:/Images/jog/down.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
            bottomPadding: 0
            Layout.column : 3
            Layout.row : 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.jogprinter("Z",-step.jogsize);
                opc.sendcommand("M114");
            }
        }

        // home

        JogButton {
            id: homeall
            homebutton:  true
            text: "ALL"
            autoExclusive: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.column : 4
            Layout.row :  1
            Layout.fillHeight: true
            Layout.fillWidth: true
            image : "qrc:/Images/jog/home.svg"
            onClicked: {
                opc.homeprinter("XYZ");
                opc.sendcommand("M114");
            }
        }

        JogButton {
            id: homeX
            text: "X"
            padding: 0
            topPadding: 0
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            homebutton:  true
            autoExclusive: true
            Layout.column : 5
            Layout.row : 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            image : "qrc:/Images/jog/home.svg"
            onClicked: {
                opc.homeprinter("X");
                opc.sendcommand("M114");
            }
        }

        JogButton {
            id: homeY
            homebutton:  true
            text: "Y"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            autoExclusive: true
            Layout.column : 5
            Layout.row : 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            image : "qrc:/Images/jog/home.svg"
            onClicked: {
                opc.homeprinter("Y");
                opc.sendcommand("M114");
            }

        }



        JogButton {
            id: homeZ
            text: "Z"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            homebutton:  true
            autoExclusive: true
            Layout.column : 5
            Layout.row : 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            image : "qrc:/Images/jog/home.svg"
            onClicked: {
                opc.homeprinter("Z");
                opc.sendcommand("M114");
            }
        }

    }

    RowLayout {
        id: rowstep
        height: fontSize24 *2
        anchors.margins: 0
        anchors.rightMargin: fontSize12 / 2
        anchors.leftMargin: fontSize12 / 2
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        spacing: fontSize12 /2



        StepBox {
            id : step
            font.pixelSize: fontSize14
            font.bold: true
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        PrintButton {
            id : tbMotor
            text : "Motor OFF"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pixelSize: fontSize16
            font.weight: Font.ExtraBold
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.sendcommand("M84");
            }
        }

        PrintButton {
            id : tbResetESAlarm
            text : "ES Alarm"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pixelSize: fontSize16
            font.weight: Font.ExtraBold
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.sendcommand("M19");
            }
        }

        PrintButton {
            id : tbDockff
            text : "Dock"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pixelSize: fontSize16
            font.weight: Font.ExtraBold
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.sendcommand("G32");
            }
        }

        PrintButton {
            id : tbUnDockff
            text : "UnDock"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            font.pixelSize: fontSize16
            font.weight: Font.ExtraBold
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.sendcommand("G31");
            }
        }

    }

}





































/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:800}D{i:8;anchors_width:800}
}
 ##^##*/
