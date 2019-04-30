import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Universal 2.2


Page {
    id: pageconfigs
    width: 640
    height: 480
    property alias btn_cnx: btn_cnx
    padding: fontSize12
    spacing: fontSize12

    title: qsTr("Settings")

    GridLayout {
        id: grid
        columnSpacing: fontSize12
        rowSpacing: fontSize12

        rows: portrait?14:7
        columns: portrait?1:2
        anchors.fill: parent

        Label {
            id: label
            text: qsTr("QML for Client OctoPrint")
            font.italic: true
            font.bold: true
            font.pointSize: fontSize12
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            Layout.columnSpan: portrait?1:2
        }


        Label {
            id : lbUrl
            width: 100
            text: "Url :"
            horizontalAlignment: portrait? Text.AlignLeft:Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        TextEdit {
            id: txt_url
            text: cfg_Url
            horizontalAlignment: Text.AlignLeft
            font.bold: true
            color: Universal.accent
            Layout.fillHeight: false
            Layout.fillWidth: true
        }

        Label {
            id : lbapiKey
            width: 100
            text: "ApiKey :"
            horizontalAlignment: portrait? Text.AlignLeft:Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        TextEdit {
            id: txt_api_key
            text:cfg_Api_Key.toString()
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            color: Universal.accent
            Layout.fillHeight: false
            Layout.fillWidth: true
        }

        Label {
            id : lusername
            width: 100
            text: "User Name :"
            horizontalAlignment:portrait? Text.AlignLeft:Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        TextEdit {
            id: txt_username
            text:cfg_UserName.toString()
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            color: Universal.accent
            Layout.fillHeight: false
            Layout.fillWidth: true
        }


        Label {
            id : lbuserKey
            width: 100
            text: "UserKey :"
            horizontalAlignment: portrait? Text.AlignLeft:Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        TextEdit {
            id: txt_user_key
            text:cfg_User_Key.toString()
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.bold: true
            color: Universal.accent
            Layout.fillHeight: false
            Layout.fillWidth: true
        }

        Label {
            id : lb_ports
            width: 100
            text: "Printer Port :"
            horizontalAlignment: portrait? Text.AlignLeft:Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
        }


        TextEdit {
            id: txt_port
            text: cfg_printerPort
            font.bold: true
            color: Universal.accent
            Layout.fillHeight: false
            Layout.fillWidth: true
        }



        Label {
            id : lb_profils
            width: 100
            text: "Profile Identifier : "
            horizontalAlignment: portrait? Text.AlignLeft:Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        TextEdit {
            id: txt_profil
            text: cfg_printerProfile
            font.bold: true
            color: Universal.accent
            Layout.fillHeight: false
            Layout.fillWidth: true
        }

        Button {
            id: btn_cnx
            text: "Connect "
            Layout.columnSpan: portrait?1:2
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.fillWidth: false
            Layout.fillHeight: false
            font.pointSize:fontSize12
            onClicked: {
                if (opc._connected) {
                    opc.disconnect();
                } else {
                    cfg_Url= txt_url.text  ;
                    cfg_Api_Key=txt_api_key.text;
                    cfg_UserName=txt_username.text;
                    cfg_User_Key=txt_user_key.text;
                    cfg_printerPort=txt_port.text;
                    cfg_printerProfile=txt_profil.text;
                    opc.init();
                }
            }

        }
    }



    function init(){
        if (octoprintclient.opcConnected) {
            btn_cnx.text="Disconnect";
        } else {
            btn_cnx.text="Connect";
        }
    }
}



