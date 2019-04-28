import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.0
import "Components/OctoPrintShared.js" as OPS

Page {
    id: graphpage
    //title: qsTr("Graph")
    implicitHeight: 480
    implicitWidth: 640

    property int maxGraphHist : 400


    function graphUpdate (heure) {
        // Graph update 1/5 to reduce CPU (20% sur BBB)
        if (heure && OPS.cptGraph===0  ) {
            var maxpoint = false;
            tool0actual.append(heure,OPS.temps.tool0.actual);
            tool0target.append(heure,OPS.temps.tool0.target);
            if (tool0actual.count>=maxGraphHist ) {
                tool0actual.removePoints(0,1);
                tool0target.removePoints(0,1);
                maxpoint=true;

            } else {
                maxpoint=false;
            }

            if (printpage.tool1.visible) {
                tool1actual.append(heure,OPS.temps.tool1.actual);
                tool1target.append(heure,OPS.temps.tool1.target);
                if (maxpoint ) {
                    tool1actual.removePoints(0,1);
                    tool1target.removePoints(0,1);
                }
            }

            if (printpage.tool2.visible) {
                tool2actual.append(heure,OPS.temps.tool2.actual);
                tool2target.append(heure,OPS.temps.tool2.target);
                if (maxpoint ) {
                    tool2actual.removePoints(0,1);
                    tool2target.removePoints(0,1);
                }
            }
            if (printpage.tool3.visible) {
                tool3actual.append(heure,OPS.temps.tool3.actual);
                tool3target.append(heure,OPS.temps.tool3.target);
                if (maxpoint) {
                    tool3actual.removePoints(0,1);
                    tool3target.removePoints(0,1);
                }
            }
            if (printpage.bed.visible) {
                bedactual.append(heure,OPS.temps.bed.actual);
                bedtarget.append(heure,OPS.temps.bed.target);
                if (maxpoint ) {
                    bedactual.removePoints(0,1);
                    bedtarget.removePoints(0,1);
                }
            }

            axisX.max=new Date(heure);
            axisX.min=new Date(tool0actual.at(0).x);
        }
        OPS.cptGraph++;
        if (OPS.cptGraph>5) OPS.cptGraph=0;
    }


    ChartView {
        id : chart
        anchors.fill: parent
        enabled: graphpage.visible
        anchors.margins: 0
        antialiasing: true
        animationOptions :ChartView.NoAnimation
        titleFont: Qt.font({pointSize: fontSize12, bold:false});
        legend {
            alignment : Qt.AlignBottom
            showToolTips : true
        }

        DateTimeAxis {
            property date  now : new Date()
            id: axisX
            titleText: "time"
          //  tickCount: 7
            format: "HH:mm"
        }

        ValueAxis {
            id: axisY
            min: 0
            max: 300
            tickCount: 5
            titleText: "°C"
        }

        ValueAxis {
            id: bedaxisY
            min: 0
            max: 120
            tickCount: axisY.tickCount
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

            /* DateTimeAxis only updated on Tool0
            onPointRemoved: {
                axisX.min= new Date( at(0).x);
            }
            onPointsRemoved: {
                axisX.min= new Date( at(0).x);
            }
            */
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
        maxGraphHist / 30 * 12

    }

}
