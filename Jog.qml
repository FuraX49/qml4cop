import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "Components"



Page {
    id: jogpage
    property alias lbpZ: lbpZ

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
        columnSpacing: 5
        rowSpacing: 5
        clip: false
        anchors.bottom: rowstep.top
        anchors.margins: fontSize12

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
            image :  "qrc:/Images/jog/up.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
            Layout.column : 1
            Layout.row : 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.jogprinter("y",+step.jogsize)
            }
        }

        JogButton {
            id: mZ
            text: qsTr("+Z")
            image  : "qrc:/Images/jog/up.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
            Layout.column : 3
            Layout.row : 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.jogprinter("Z",step.jogsize)
            }
        }


        JogButton {
            id: lX
            text: qsTr("-X")
            image  : "qrc:/Images/jog/left.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
            Layout.column : 0
            Layout.row : 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.jogprinter("X",-step.jogsize)
            }
        }

        JogButton {
            id: mX
            autoExclusive: true
            text: qsTr("+X")
            image  : "qrc:/Images/jog/right.svg"
            homebutton:  false
            autoRepeat: true
            Layout.column : 2
            Layout.row : 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.jogprinter("X",step.jogsize)
            }
        }



        JogButton {
            id: lY
            text: qsTr("-Y")
            image  : "qrc:/Images/jog/down.svg"
            homebutton:  false
            autoRepeat: true
            autoExclusive: true
            Layout.column : 1
            Layout.row : 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                opc.jogprinter("y",-step.jogsize)
            }
        }

        JogButton {
            id: lZ
            text: qsTr("-Z")
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
                opc.jogprinter("Z",-step.jogsize)
            }
        }

        // home
        JogButton {
            id: homeX
            text: "X"
            homebutton:  true
            autoExclusive: true
            Layout.column : 5
            Layout.row : 0
            Layout.fillHeight: true
            Layout.fillWidth: true
            image : "qrc:/Images/jog/home.svg"
            onClicked: {
                opc.homeprinter("x");
            }
        }

        JogButton {
            id: homeY
            homebutton:  true
            text: "Y"
            autoExclusive: true
            Layout.column : 5
            Layout.row : 1
            Layout.fillHeight: true
            Layout.fillWidth: true
            image : "qrc:/Images/jog/home.svg"
            onClicked: {
                opc.homeprinter("Y");
            }

        }

        JogButton {
            id: homeall
            homebutton:  true
            text: "ALL"
            autoExclusive: true
            Layout.column : 4
            Layout.row :  1
            Layout.fillHeight: true
            Layout.fillWidth: true
            image : "qrc:/Images/jog/home.svg"
            onClicked: {
                opc.homeprinter("XYZ");
            }
        }

        JogButton {
            id: homeZ
            text: "Z"
            homebutton:  true
            autoExclusive: true
            Layout.column : 5
            Layout.row : 2
            Layout.fillHeight: true
            Layout.fillWidth: true
            image : "qrc:/Images/jog/home.svg"
            onClicked: {
                opc.homeprinter("Z");
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
         //   topPadding: 5
          //  padding: 0
            Layout.columnSpan: 2
            font.pixelSize: fontSize12
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
                opc.sendcommand("M84")
            }
        }

        PrintButton {
            id : tbDockff
            text : checked?"Dock":"UnDock"
            checkable: true
            font.pixelSize: fontSize16
            font.weight: Font.ExtraBold
            Layout.fillHeight: true
            Layout.fillWidth: true
            onClicked: {
                if (checked) {
                    opc.sendcommand("G31")
                } else {
                    opc.sendcommand("G32")
                }
            }
        }

    }


}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:800}
}
 ##^##*/
