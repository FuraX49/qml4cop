import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.VirtualKeyboard 2.1
import Qt.labs.settings 1.0
import QtQml 2.2

import "Components"
import "Components/OctoPrintShared.js" as OPS


Item {
    id: mainpage
    visible: true
    width: 800
    height: 480
    rotation: 0

    property bool portrait : (height>width)

    property alias msgerror: msgerror


    // Based on Minimal Height of 480
    property int fontSize8  : Math.round(height / 60 );
    property int fontSize9  : Math.round(height / 53 );
    property int fontSize10 : Math.round(height / 48 );
    property int fontSize12 : Math.round(height / 40 );
    property int fontSize14 : Math.round(height / 34 );
    property int fontSize16 : Math.round(height / 30 );
    property int fontSize20 : Math.round(height / 24 );
    property int fontSize24 : Math.round(height / 20 );


    // ************ SETTINGS ***************************************
    property string cfg_Url : "http://127.0.0.1:5000"
    property string cfg_Api_Key :  "MODIFY"
    property string cfg_UserName :  "MODIFY"
    property string cfg_User_Key :  "MODIFY"
    property int    cfg_Cnx_Int  :  10

    property string cfg_printerPort :  "MODIFY"
    property string cfg_printerProfile :  "MODIFY"

    property int  cfg_ExtABS :  210
    property int  cfg_ExtPLA :  180
    property int  cfg_BedABS :  100
    property int  cfg_BedPLA :  60
    property int  cfg_FanNb  :  1


    Settings {
        id: octoSettings
        category : "OctoPrint"
        property alias url : mainpage.cfg_Url
        property alias apikey: mainpage.cfg_Api_Key
        property alias username: mainpage.cfg_UserName
        property alias userkey: mainpage.cfg_User_Key
        property alias printerProfile: mainpage.cfg_printerProfile
        property alias cnxInterval : mainpage.cfg_Cnx_Int
    }

    Settings {
        id: windowSettings
        category : "Window"
        property alias width: mainpage.width
        property alias height: mainpage.height
        property alias rotation: mainpage.rotation
    }


    Settings {
        id: printeSettings
        category : mainpage.cfg_printerProfile.toString()
        property alias printerPort : mainpage.cfg_printerPort
        property alias extABS  : mainpage.cfg_ExtABS
        property alias extPLA  : mainpage.cfg_ExtPLA
        property alias bedABS  : mainpage.cfg_BedABS
        property alias bedPLA  : mainpage.cfg_BedPLA
        property alias fanNb   : mainpage.cfg_FanNb
    }



    OctoPrintClient {
        id : opc
        debug: false
        url: cfg_Url
        apikey: cfg_Api_Key
        username: cfg_UserName
        userkey: cfg_User_Key
        printerProfile  : cfg_printerProfile
        printerPort : cfg_printerPort
        intervalcnx:  mainpage.cfg_Cnx_Int

        onTryConnect: {
            lbStatus.text= "Try connect "+cnttry.toString();
        }

        on_ConnectedChanged: {
            if (_connected) {
                configpage.btn_cnx.text="Disconnect";
                opc.getprinterprofiles();
                filespage.init();
            } else {
                configpage.btn_cnx.text="Connect";
            }
        }

        onProfileChanged: {
            printpage.init();
        }

        onStateTextChanged: {
            lbStatus.text=opc.stateText;
        }
        onStatePausedChanged: {
            console.debug("statePaused " + statePaused )
            if (statePaused) {
                tbPause.enabled=true;
                tbPause.checked=true;
            } else  {
                tbPause.checked=false;
            }
        }

        onStatePrintingChanged: {
            console.debug("statePrinting " + statePrinting )
            if (statePrinting) {
                tbStart.enabled=false;
                tbPause.enabled=true;
                tbCancel.enabled=true;
            } else {
                tbStart.enabled=true;
                tbPause.enabled=false;
                tbCancel.enabled=false;
            }
        }

        onStateOperationalChanged:  {console.debug("StateOperational " + stateOperational )}
        onStateCancellingChanged: {console.debug("stateCancelling " + stateCancelling )}
        onStatePausingChanged: {console.debug("statePausing " + statePausing )}
        onStateSdReadyChanged: {console.debug("stateSdReady " + stateSdReady )}
        onStateErrorChanged:  {console.debug("stateError " + stateError )}
        onStateReadyChanged: {console.debug("stateReady " + stateReady )}
        onStateClosedOrErrorChanged: {console.debug("stateClosedOrError " + stateClosedOrError )}

        onTempChanged: {
            if (!history) {
                printpage.tool0.updateTemps(OPS.temps.tool0.actual,OPS.temps.tool0.target);
                if (printpage.tool1.visible) printpage.tool1.updateTemps(OPS.temps.tool1.actual,OPS.temps.tool1.target);
                if (printpage.tool2.visible) printpage.tool2.updateTemps(OPS.temps.tool2.actual,OPS.temps.tool2.target);
                if (printpage.tool3.visible) printpage.tool3.updateTemps(OPS.temps.tool3.actual,OPS.temps.tool3.target);
                if (printpage.bed.visible) printpage.bed.updateTemps(OPS.temps.bed.actual,OPS.temps.bed.target);
            }
            /*
            // Graph update
            graphpage.tool0actual.append(heure,OPS.temps.tool0.actual);
            graphpage.tool0target.append(heure,OPS.temps.tool0.target);
            if (graphpage.tool0actual.count>=octoprintclient.maxGraphHist ) {
                graphpage.tool0actual.removePoints(0,1);
                graphpage.tool0target.removePoints(0,1);
            }
            graphpage.axisX.max=heure;


            if (printpage.tool1.visible) {
                graphpage.tool1actual.append(heure,OPS.temps.tool1.actual);
                graphpage.tool1target.append(heure,OPS.temps.tool1.target);
                if (graphpage.tool1actual.count>=octoprintclient.maxGraphHist ) {
                    graphpage.tool1actual.removePoints(0,1);
                    graphpage.tool1target.removePoints(0,1);
                }
            }

            if (printpage.tool2.visible) {
                graphpage.tool2actual.append(heure,OPS.temps.tool2.actual);
                graphpage.tool2target.append(heure,OPS.temps.tool2.target);
                if (graphpage.tool2actual.count>=octoprintclient.maxGraphHist ) {
                    graphpage.tool2actual.removePoints(0,1);
                    graphpage.tool2target.removePoints(0,1);
                }
            }
            if (printpage.tool3.visible) {
                graphpage.tool3actual.append(heure,OPS.temps.tool3.actual);
                graphpage.tool3target.append(heure,OPS.temps.tool3.target);
                if (graphpage.tool3actual.count>=octoprintclient.maxGraphHist ) {
                    graphpage.tool3actual.removePoints(0,1);
                    graphpage.tool3target.removePoints(0,1);
                }
            }
            if (printpage.bed.visible) {
                graphpage.bedactual.append(heure,OPS.temps.bed.actual);
                graphpage.bedtarget.append(heure,OPS.temps.bed.target);
                if (graphpage.bedactual.count>=octoprintclient.maxGraphHist ) {
                    graphpage.bedactual.removePoints(0,1);
                    graphpage.bedtarget.removePoints(0,1);
                }
            }
            */

            // update Progress
            if (opc.statePrinting) {
                printpage.printprogress.updateProgress();
            }


        }
        onCurrentZChanged: {
            jogpage.lbpZ.text= z.toPrecision(2);
        }

        onPositionUpdate:  {
            jogpage.lbpX.text= x.toPrecision(2);
            jogpage.lbpY.text= y.toPrecision(2);
            jogpage.lbpZ.text= z.toPrecision(2);
        }


        onFileSelected: {
            console.debug("onfileSelected");
            if (OPS.job.file.name) {
                printpage.printprogress.updateJob(OPS.job);
            }
        }

        onLogChanged: {
            terminalpage.addLogs(log);
        }


    }



    Menu {
        id : rootMenu
        spacing: fontSize24
        margins: fontSize24


        //cascade: true
        MenuItem {
            text: "Print"
            font.pixelSize: fontSize16*2

            onTriggered: {
                stackpages.currentIndex=0
            }
        }
        MenuItem {
            text: "Jog"
            font.pixelSize:  fontSize16*2
            onTriggered: {
                stackpages.currentIndex=1
            }
        }
        MenuItem {
            text: "Files"
            font.pixelSize:  fontSize16*2
            onTriggered: {
                stackpages.currentIndex=2
            }
        }

        MenuItem {
            text: "Terminal"
            font.pixelSize:  fontSize16*2
            onTriggered: {
                stackpages.currentIndex=3
            }
        }
        MenuItem {
            text: "Config"
            font.pixelSize:  fontSize16*2
            onTriggered: {
                stackpages.currentIndex=4
            }
        }
        /*
        MenuItem {
            text: "Graph"
            font.pixelSize:  fontSize16*2
            onTriggered: {
                stackpages.currentIndex=5
            }
        }*/
    }


    ToolBar {
        id: toolBar
        contentHeight: fontSize24 *2
        //height: contentHeight
        width: parent.width
        //position: ToolBar.Header
        anchors.margins: 0
        spacing: 0
        padding: 0

        z: 89


        RowLayout {
            anchors.leftMargin: fontSize16
            anchors.fill: parent
            HeaderButton {
                id: tbMenu
                ToolTip.text: qsTr("Menu")
                Layout.preferredWidth:   Math.floor(parent.width * 0.15)
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Image { source : "qrc:/Images/header/menu.svg"  }
                onClicked: {
                    rootMenu.open();
                }

            }

            HeaderButton {
                id: tbStart
                ToolTip.text: qsTr("Start")
                Layout.preferredWidth:  Math.floor(parent.width * 0.15)
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Image { source : "qrc:/Images/header/play_circle_filled.svg" }
                onClicked: {
                    opc.jobcommand("start")
                }
            }

            HeaderButton {
                id: tbPause
                ToolTip.text: qsTr("Pause")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredWidth:  Math.floor(parent.width * 0.15)
                Layout.fillHeight: true
                enabled: false
                checkable: true
                checked: false
                Image { source : "qrc:/Images/header/pause_circle_filled.svg" }
                onClicked: {
                    if (opc.statePaused) {
                        opc.jobcommand('"pause" ,"action": "resume"')
                    } else {
                        opc.jobcommand('"pause" ,"action": "pause"')
                    }
                }
            }

            HeaderButton {
                id: tbCancel
                ToolTip.text: qsTr("Cancel")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.preferredWidth:  Math.floor(parent.width * 0.15)
                Layout.fillHeight: true
                enabled: false
                Image {  source : "qrc:/Images/header/stop_circle.svg" }
                onClicked: {
                    opc.jobcommand("cancel")
                }
            }

            Label {
                id : lbStatus
                text : "Offline"
                font.pixelSize: fontSize14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode : Text.WordWrap
                elide : Text.ElideMiddle
                width: toolBar.width * 0.4
                Layout.preferredWidth:  Math.floor(parent.width * 0.4)
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }
    }


    StackLayout {
        id: stackpages

        anchors.margins: 0
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.top: toolBar.bottom
        currentIndex: 0


        Print {id: printpage; visible : true }
        Jog {  id: jogpage  ; visible : false}
        Files {id: filespage ; visible : false}
        Terminal {id: terminalpage ; visible : false }
        Configs {id: configpage  ; visible : false }
        //Graph {id: graphpage ; visible : false}
    }


    InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: mainpage.height
        width: mainpage.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: mainpage.height -( inputPanel.height + 1)
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }


    Pane {
        id: msgerror
        visible : false

        width:  parent.width - 100
        height: parent.height - 100


        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            color: "#c65050"
            radius: 3
            border.width: 4
            anchors.fill: parent

        }

        function open(title,msg) {
            ltitle.text=title;
            lmsg.text=msg;
            msgerror.visible=true;
        }



        ColumnLayout {
            id: columnLayout
            anchors.fill: parent
            anchors.margins: fontSize14 *2
            spacing:fontSize14 *2


            Label {
                id: ltitle
                text: qsTr("Label")
                horizontalAlignment: Text.AlignHCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.rowSpan: 1
                font.pointSize:  fontSize14
                wrapMode: Label.WordWrap
            }

            Label {
                id: lmsg
                text: qsTr("Label")
                font.pointSize:  fontSize14
                horizontalAlignment: Text.AlignHCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
                wrapMode: Label.WordWrap
                Layout.rowSpan: 3
            }

            Button {
                id: button
                text: qsTr("Close")
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                onClicked: {
                    msgerror.visible=false;
                }
            }
        }
    }





    Component.onCompleted: {
        update();
        if ((cfg_Api_Key==="MODIFY") ||  (cfg_printerProfile==="MODIFY") || (cfg_printerPort==="MODIFY")  || (cfg_UserName==="MODIFY")  || (cfg_User_Key==="MODIFY")   ) {
            msgerror.open("Configuration error","Edit /etc/qml4cop/qml4cop.conf and modify configuration. ");
        } else {
            msgerror.visible=false;
            opc.init();
        }
    }

}






