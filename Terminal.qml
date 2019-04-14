import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.impl 2.2

Page {
    id: pageterminal
    // 100 lines for log ?
    property int  maxloglines : 100

    function addLogs( log) {
        if (!cb_log.checked ) {



            var regex = /(Send: (N\d+\s+)?M105)|(Recv:\s+(ok\s+)?.*\s(T\d*):\d+)/;
            var regTemp = new RegExp(regex);
            var  mt = log.match(regTemp) ;

            regex = /Recv: (wait)|(ok)$/;
            var regOk = new RegExp(regex);
            var  mo = log.match(regOk) ;


            if ( (mt) &&  (!cb_temp.checked) ) {
                modellog.append({"line": log });
            } else {
                if ( (mo)  && (!cb_ok.checked)) {
                    modellog.append({"line": log });
                } else {
                    if ((!mo) && (!mt)) {
                        modellog.append({"line": log });
                    }
                }
            }

            if (modellog.count>maxloglines) {
                modellog.remove(0);
                scrollBar.position=1.0;
            }

        }
    }


    RowLayout {
        id: rowLayout
        spacing: 10
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 5
        height: fontSize16*2

        z : 99

        TextField {
            id: textcmd
            text: "M115"
            Layout.rowSpan: 1
            Layout.columnSpan: 3
            Layout.fillWidth: true
        }

        Button {
            id: toolButton
            text: qsTr("Send")
            highlighted: false
            Layout.fillHeight: true
            Layout.fillWidth: true

            onClicked: {
                opc.sendcommand(textcmd.text.toString())
            }
        }


        CheckBox {
            id: cb_log
            text: qsTr("log")
            checked: true
            Layout.fillHeight: true
            Layout.fillWidth: true
            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            ToolTip.text: "Suppress all log message"
            ToolTip.visible: hovered
            onCheckedChanged: {
                cb_temp.enabled=!cb_log.checked;
                cb_ok.enabled=!cb_log.checked;
            }
        }

        CheckBox {
            id: cb_temp
            text: qsTr("Temp")
            checked: true
            enabled: false
            Layout.fillHeight: true
            Layout.fillWidth: true
            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            ToolTip.text: "Suppress only temperatures message"
            ToolTip.visible: hovered
        }
        CheckBox {
            id: cb_ok
            text: qsTr("Ok")
            checked: true
            enabled: false
            Layout.fillHeight: true
            Layout.fillWidth: true
            ToolTip.delay: 1000
            ToolTip.timeout: 5000
            ToolTip.text: "Suppress only ok"
            ToolTip.visible: hovered
        }
    }

    ListModel {
        id : modellog
        ListElement {
            line: ""
        }
    }


    ListView {
        id: logList
        anchors.margins: 5
        boundsBehavior: Flickable.StopAtBounds
        clip: true
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: rowLayout.bottom
        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            active: true
            interactive : true

        }
        model: modellog
        delegate:
            Text {
            id: textLogs_Id
            text: {text: line }
            font.pixelSize: fontSize12
            //color: Default.textLightColor
            wrapMode: Text.WordWrap
            width: parent.width
        }
    }


}
