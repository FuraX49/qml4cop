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
        id: gridLayout
        anchors.margins: fontSize10
        columnSpacing: fontSize10
        rowSpacing: fontSize10
        clip: false
        anchors.bottom: rowstep.top
        anchors.top: rowaxes.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        rows: 3
        columns: 6
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.fillHeight: true
        Layout.fillWidth: true

        // XY
        JogButton {
            id: mY
            text: qsTr("+Y")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            image :  "qrc:/Images/jog/up.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
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
            id: mZ
            text: qsTr("+Z")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            image  : "qrc:/Images/jog/up.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
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
            id: lX

            text: qsTr("-X")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            image  : "qrc:/Images/jog/left.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
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
            id: mX
            autoExclusive: true
            text: qsTr("+X")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            image  : "qrc:/Images/jog/right.svg"
            homebutton:  false
            autoRepeat: true
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
            id: lY
            text: qsTr("-Y")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            image  : "qrc:/Images/jog/down.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
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
            id: lZ
            text: qsTr("-Z")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            bottomPadding: 0
            topPadding: 0
            spacing: 0
            image : "qrc:/Images/jog/down.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
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
            id: homeX
            text: "X"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            homebutton:  true
            autoExclusive: true
            Layout.column : 5
            Layout.row : 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            image : "qrc:/Images/jog/home.svg"
            onClicked: {
                opc.homeprinter("x");
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
            id: homeall
            homebutton:  true
            text: "ALL"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            autoExclusive: true
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

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.margins: fontSize12
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        Layout.fillHeight: true
        Layout.fillWidth: true
        spacing: fontSize12 /2



        StepBox {
            id : step
            Layout.columnSpan: 2
            font.pixelSize: fontSize14
            font.bold: true
            Layout.fillHeight: true
            Layout.fillWidth: true

        }

        PrintButton {
            id : tbMotor
            text : "Motor OFF"
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
            Layout.columnSpan: 1
            text : "Dock"
            font.pixelSize: fontSize16
            font.weight: Font.ExtraBold
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.sendcommand("G32");
                opc.sendcommand("M114");
            }
        }

        PrintButton {
            id : tbUnDockff
            text : "UnDock"
            checkable: true
            font.pixelSize: fontSize16
            font.weight: Font.ExtraBold
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.sendcommand("G31");
                opc.sendcommand("M114");
            }
        }

    }


}











/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
 ##^##*/
