import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.0
import QtQuick.Controls.Universal 2.2
import "Components/OctoPrintShared.js" as OPS

Page {
    id: graphpage
    implicitHeight: 480
    implicitWidth: 640

    property int maxGraphHist : 400
    property var  cptGraph: 0


    function graphUpdate (heure) {
        // Graph update 1/5 to reduce CPU (20% sur BBB)
        if (heure && cptGraph===0  ) {
            var maxpoint = false;
            chart.enabled=false;
            tool0actual.append(heure,OPS.temps.tool0.actual);
            tool0target.append(heure,OPS.temps.tool0.target);
            if (tool0actual.count>=maxGraphHist ) {
                tool0actual.remove(0);
                tool0target.remove(0);
                maxpoint=true;
            } else {
                maxpoint=false;
            }

            if (opc.extrudercount>1) {
                tool1actual.append(heure,OPS.temps.tool1.actual);
                tool1target.append(heure,OPS.temps.tool1.target);
                if (maxpoint ) {
                    tool1actual.remove(0);
                    tool1target.remove(0);
                }
            }

            if (opc.extrudercount>2) {
                tool2actual.append(heure,OPS.temps.tool2.actual);
                tool2target.append(heure,OPS.temps.tool2.target);
                if (maxpoint ) {
                    tool2actual.remove(0);
                    tool2target.remove(0);
                }
            }
            if (opc.extrudercount>3) {
                tool3actual.append(heure,OPS.temps.tool3.actual);
                tool3target.append(heure,OPS.temps.tool3.target);
                if (maxpoint) {
                    tool3actual.remove(0);
                    tool3target.remove(0);
                }
            }
            if (opc.heatedBed) {
                bedactual.append(heure,OPS.temps.bed.actual);
                bedtarget.append(heure,OPS.temps.bed.target);
                if (maxpoint ) {
                    bedactual.remove(0);
                    bedtarget.remove(0);
                }
            }
            axisX.max=new Date(heure);
            axisX.min=new Date( tool0actual.at(0).x);
            chart.enabled=true;
        }
        cptGraph++;
        if (cptGraph>5) cptGraph=0;

    }

    onVisibleChanged: {
        if (visible ) cptGraph=0;
    }


    ChartView {
        id : chart
        anchors.fill: parent
        enabled: graphpage.visible
        anchors.margins: 0
        antialiasing: true
        animationOptions :ChartView.NoAnimation
        backgroundColor: Universal.background
        legend {
            alignment : Qt.AlignBottom
            showToolTips : true
        }

        DateTimeAxis {
            id: axisX
            titleText: "time"
            format: "HH:mm"
            labelsFont.pointSize: fontSize8
            titleVisible: false
        }

        ValueAxis {
            id: axisY
            min: 0
            max: 300
            tickCount: 5
            titleText: "°C"
            labelsFont.pointSize: fontSize8
            titleVisible: false
        }

        ValueAxis {
            id: bedaxisY
            min: 0
            max: 120
            tickCount: axisY.tickCount
            labelsFont.pointSize: fontSize8
        }


        LineSeries {
            id: bedactual
            visible: false
            axisX: axisX
            axisYRight: bedaxisY
            name: "Bed"
        }

        LineSeries {
            id: bedtarget
            visible: false
            color: bedactual.color
            axisX: axisX
            axisYRight: bedaxisY
        }

        LineSeries {
            id: tool0actual
            visible: true
            axisX: axisX
            axisY: axisY
            name: "Tool0"

            /* DateTimeAxis only updated on Tool0  don't works ? !!
            onPointRemoved: {
                axisX.min= new Date( at(0).x);
            }
            onPointsRemoved: {
                axisX.min= new Date( at(1).x);
            }*/

        }

        LineSeries {
            id: tool0target
            visible: true
            style :  Qt.DashLine
            color: tool0actual.color
            axisX: axisX
            axisY: axisY
        }

        LineSeries {
            id: tool1actual
            visible: false
            axisX: axisX
            axisY: axisY
            name: "Tool1"

        }

        LineSeries {
            id: tool1target
            visible: false
            style :  Qt.DashLine
            color: tool1actual.color
            axisX: axisX
            axisY: axisY
        }



        LineSeries {
            id: tool2actual
            visible: false
            axisX: axisX
            axisY: axisY
            name: "Tool2"

        }

        LineSeries {
            id: tool2target
            visible: false
            style :  Qt.DashLine
            color: tool2actual.color
            axisX: axisX
            axisY: axisY
        }

        LineSeries {
            id: tool3actual
            visible: false
            axisX: axisX
            axisY: axisY
            name: "Tool3"

        }

        LineSeries {
            id: tool3target
            visible: false
            style :  Qt.DashLine
            color: tool3actual.color
            axisX: axisX
            axisY: axisY
        }

    }


    Component.onCompleted: {
        bedactual.clear();
        bedtarget.clear();
        tool0actual.clear();
        tool0target.clear();
        tool1actual.clear();
        tool1target.clear();
        tool2actual.clear();
        tool2target.clear();
        tool3actual.clear();
        tool3target.clear();
    }

    function init() {

        bedactual.visible=opc.heatedBed;
        bedtarget.visible=opc.heatedBed;

        tool1actual.visible=(opc.extrudercount>1);
        tool1target.visible=(opc.extrudercount>1);

        tool2actual.visible=(opc.extrudercount>2);
        tool2target.visible=(opc.extrudercount>2);

        tool3actual.visible=(opc.extrudercount>3);
        tool3target.visible=(opc.extrudercount>3);
        maxGraphHist=chart.plotArea.width-4;

    }

}
