import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "Components"


Page {
    id: printpage
    property alias printprogress: printprogress
    property alias tool0: tool0
    property alias tool1: tool1
    property alias tool2: tool2
    property alias tool3: tool3
    property alias bed: bed


    property var heattype : { "pla" : 1, "abs" : 2}

    function allHeatExt(onOff,typeheat){
        var targets = "";
        if (onOff) {
            if (typeheat === heattype.abs) {
                if (tool0.visible) targets += ' "tool0" : ' + cfg_ExtABS.toString()   ;
                if (tool1.visible) targets += ', "tool1" : ' + cfg_ExtABS.toString()   ;
                if (tool2.visible) targets += ', "tool2" : ' + cfg_ExtABS.toString()   ;
                if (tool3.visible) targets += ', "tool3" : ' + cfg_ExtABS.toString()   ;
                opc.toolstarget(targets);
                opc.bedtarget(cfg_BedABS);


            } else {
                if (tool0.visible) targets += ' "tool0" : ' + cfg_ExtPLA.toString()   ;
                if (tool1.visible) targets += ', "tool1" : ' + cfg_ExtPLA.toString()   ;
                if (tool2.visible) targets += ', "tool2" : ' + cfg_ExtPLA.toString()   ;
                if (tool3.visible) targets += ', "tool3" : ' + cfg_ExtPLA.toString()   ;
                opc.toolstarget(targets);
                opc.bedtarget(cfg_BedPLA);
            }
        }  else {
            if (tool0.visible) targets += ' "tool0" : 0'     ;
            if (tool1.visible) targets += ', "tool1" : 0'   ;
            if (tool2.visible) targets += ', "tool2" : 0'   ;
            if (tool3.visible) targets += ', "tool3" : 0'   ;
            opc.toolstarget(targets);
            opc.bedtarget(0);
        }
    }

    ColumnLayout {
        anchors.fill: parent


        RowLayout {
            id: rl_haut
            Layout.fillHeight: true
            Layout.fillWidth: true

            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true

                PrintProgress {
                    id : printprogress
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

                RowLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    PrintButton {
                        id: btnOFF
                        text: qsTr("OFF")
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        onClicked: {
                            btnABS.checked = false;
                            btnPLA.checked = false;
                            allHeatExt(false,0);
                        }
                    }
                    PrintButton {
                        id: btnPLA
                        text: qsTr("PLA")
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        checkable: true
                        checked: false
                        onClicked: {
                            if ( btnABS.checked ) btnABS.checked = false;
                            if (checked) {
                                allHeatExt(true,heattype.pla)
                            } else {
                                allHeatExt(false,heattype.pla)
                            }
                        }
                    }
                    PrintButton {
                        id: btnABS
                        checkable: true
                        checked: false
                        text: qsTr("ABS")
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        onClicked: {
                            if ( btnPLA.checked ) btnPLA.checked = false;
                            if (checked) {
                                allHeatExt(true,heattype.abs)
                            } else {
                                allHeatExt(false,heattype.abs)
                            }
                        }
                    }

                    PrintButton {
                        id: btnResetTemp
                        checkable: false
                        checked: false
                        text: qsTr("T° alarm")
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        onClicked: {
                            opc.sendcommand("M562");
                        }
                    }


                }
            }
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                RateControl {
                    id : rcflow
                    title : "flow"
                    minRate: 75
                    maxRate: 125
                    stepsize: 1
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onRatechanged: {
                        opc.flowrate(factor);
                    }
                }

                RateControl {
                    id : speed
                    title : "feed"
                    minRate: 50
                    maxRate: 150
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onRatechanged: {
                        opc.sendcommand("M220 S"+ factor.toString());
                    }
                }

                FanControl {
                    id : fanscontrol
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    onChangedspeedfan: {
                        if (onoff) {
                            opc.sendcommand("M106 P"+fan.toString()+" S"+speed.toString());

                        } else {
                            opc.sendcommand("M107 P"+fan.toString());
                        }
                    }
                }
            }
        }

        RowLayout {
            id: rl_bas
            Layout.fillHeight: true
            Layout.fillWidth: true

            Heater {
                id : bed
                objectName: "bed"
                Layout.fillHeight: true
                Layout.fillWidth: true
                title: "Bed"
                maxTemp: 120
                defTemp: cfg_BedPLA
                onTargetChanged: {
                    if (heat) {
                        opc.bedtarget(target);
                    } else {
                        opc.bedtarget(0);
                    }
                }
                onHeatChanged: {
                    if (heat) {
                        opc.bedtarget(target);
                    } else {
                        opc.bedtarget(0);
                    }
                }
            }

            Heater {
                id : tool0
                objectName: "tool0"
                Layout.fillHeight: true
                Layout.fillWidth: true
                title: "tool0"
                defTemp: cfg_ExtPLA
                onTargetChanged: {
                    if (heat) {
                        opc.tooltarget(objectName,target);
                    } else {
                        opc.tooltarget(objectName,0);
                    }
                }
                onHeatChanged: {
                    if (heat) {
                        opc.tooltarget(objectName,target);
                    } else {
                        opc.tooltarget(objectName,0);
                    }
                }            }


            Heater {
                id : tool1
                objectName: "tool1"
                Layout.fillHeight: true
                Layout.fillWidth: true
                title: "tool1"
                defTemp: cfg_ExtPLA
                onTargetChanged: {
                    if (heat) {
                        opc.tooltarget(objectName,target);
                    } else {
                        opc.tooltarget(objectName,0);
                    }
                }
                onHeatChanged: {
                    if (heat) {
                        opc.tooltarget(objectName,target);
                    } else {
                        opc.tooltarget(objectName,0);
                    }
                }
            }

            Heater {
                id : tool2
                objectName: "tool2"
                Layout.fillHeight: true
                Layout.fillWidth: true
                title: "tool2"
                defTemp: cfg_ExtPLA
                onTargetChanged: {
                    if (heat) {
                        opc.tooltarget(objectName,target);
                    } else {
                        opc.tooltarget(objectName,0);
                    }
                }
                onHeatChanged: {
                    if (heat) {
                        opc.tooltarget(objectName,target);
                    } else {
                        opc.tooltarget(objectName,0);
                    }
                }
            }

            Heater {
                id : tool3
                objectName: "tool3"
                Layout.fillHeight: true
                Layout.fillWidth: true
                defTemp: cfg_ExtPLA
                title: "tool3"
                onTargetChanged: {
                    if (heat) {
                        opc.tooltarget(objectName,target);
                    } else {
                        opc.tooltarget(objectName,0);
                    }
                }
                onHeatChanged: {
                    if (heat) {
                        opc.tooltarget(objectName,target);
                    } else {
                        opc.tooltarget(objectName,0);
                    }
                }
            }

            Extruder {
                id: extruders
                Layout.fillHeight: true
                Layout.fillWidth: true

                onExtrude: {
                    opc.extrudetool(amount);
                }
                onSelecttool: {
                    opc.selecttool(tool);
                }
            }

        }
    }


    function init(){
        bed.visible=opc.heatedBed;
        tool1.visible=(opc.extrudercount>1);
        tool2.visible=(opc.extrudercount>2);
        tool3.visible=(opc.extrudercount>3);

        extruders.majNbToosl(opc.extrudercount);
        fanscontrol.majNbFans(mainpage.cfg_FanNb);
    }

}
