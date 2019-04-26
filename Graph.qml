import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtCharts 2.0

Item {
    id: graphpage
    //title: qsTr("Graph")
    implicitHeight: 480
    implicitWidth: 640


    property alias bedactual :bedactual
    property alias bedtarget : bedtarget
    property alias tool0actual:tool0actual
    property alias tool0target:tool0target
    property alias tool1actual:tool1actual
    property alias tool1target:tool1target
    property alias tool2actual:tool2actual
    property alias tool2target:tool2target
    property alias tool3actual:tool3actual
    property alias tool3target:tool3target


    property alias axisX : axisX




    function graphUpdate (heure) {
        // Graph update
        tool0actual.append(heure,OPS.temps.tool0.actual);
        tool0target.append(heure,OPS.temps.tool0.target);
        if (tool0actual.count>=octoprintclient.maxGraphHist ) {
            tool0actual.removePoints(0,1);
            tool0target.removePoints(0,1);
        }
        axisX.max=heure;


        if (printpage.tool1.visible) {
            tool1actual.append(heure,OPS.temps.tool1.actual);
            tool1target.append(heure,OPS.temps.tool1.target);
            if (tool1actual.count>=octoprintclient.maxGraphHist ) {
                tool1actual.removePoints(0,1);
                tool1target.removePoints(0,1);
            }
        }

        if (printpage.tool2.visible) {
            tool2actual.append(heure,OPS.temps.tool2.actual);
            tool2target.append(heure,OPS.temps.tool2.target);
            if (tool2actual.count>=octoprintclient.maxGraphHist ) {
                tool2actual.removePoints(0,1);
                tool2target.removePoints(0,1);
            }
        }
        if (printpage.tool3.visible) {
            tool3actual.append(heure,OPS.temps.tool3.actual);
            tool3target.append(heure,OPS.temps.tool3.target);
            if (tool3actual.count>=octoprintclient.maxGraphHist ) {
                tool3actual.removePoints(0,1);
                tool3target.removePoints(0,1);
            }
        }
        if (printpage.bed.visible) {
            bedactual.append(heure,OPS.temps.bed.actual);
            bedtarget.append(heure,OPS.temps.bed.target);
            if (bedactual.count>=octoprintclient.maxGraphHist ) {
                bedactual.removePoints(0,1);
                bedtarget.removePoints(0,1);
            }
        }
    }


    ChartView {
        id : chart
        anchors.fill: parent
        anchors.margins: 0
        antialiasing: true
        animationOptions :ChartView.NoAnimation
        legend {
            alignment : Qt.AlignBottom
            showToolTips : true
        }

        DateTimeAxis {
            property date  now : new Date()
            id: axisX
            titleText: "time"
            tickCount: 7
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

            // DateTimeAxis only updated on Tool0
            onPointRemoved: {
                axisX.min= new Date( at(0).x);
            }
            onPointsRemoved: {
                axisX.min= new Date( at(0).x);
            }
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
    }

    function init() {

        bedactual.visible=octoprintclient.heatedBed;
        bedtarget.visible=octoprintclient.heatedBed;

        tool1actual.visible=(octoprintclient.extrudercount>1);
        tool1target.visible=(octoprintclient.extrudercount>1);

        tool2actual.visible=(octoprintclient.extrudercount>2);
        tool2target.visible=(octoprintclient.extrudercount>2);

        tool3actual.visible=(octoprintclient.extrudercount>3);
        tool3target.visible=(octoprintclient.extrudercount>3);

    }

}
