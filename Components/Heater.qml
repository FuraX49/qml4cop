import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


PaneBase {
    id: control
    implicitHeight : 180
    implicitWidth:  80
    padding: 2
    property string title: "Ext 0"
    property int maxTemp : 300
    property int minTemp: 0
    property real stepsize : 5
    property bool humantouch : false


    QtObject {
        id: p
        property int actualTemp: 0
        property int targetTemp: maxTemp
    }

    signal targetChanged(bool heat,int target)
    signal heatChanged(bool heat,int target)

    function heatAt( onoff,target) {
        if (humantouch) {
            humantouch=false;
        } else {
            p.targetTemp=target;
            btnOnOff.checked  = onoff;
        }

    }

    function heatOnOff( onoff) {
        if (humantouch) {
            humantouch=false;
        } else {
            btnOnOff.checked  = onoff;
        }
    }


    function updateTemps( actual, target) {
        if (target>0) {
            p.targetTemp=target;
            btnOnOff.checked = true;
        } else {
            btnOnOff.checked = false;
        }
        p.actualTemp=actual;
    }



    ColumnLayout {
        id: colroot

        anchors.fill: parent
        spacing: 0
        Label {
            id: titre
            text: control.title
            padding: 0
            Layout.fillHeight: true
            Layout.maximumHeight: Math.floor(parent.height *0.10)
            Layout.fillWidth: true
            Layout.margins:  4
            font.bold: false
            font.pixelSize: fontSize14
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        RoundButton {
            id: more
            text: "+"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            hoverEnabled: true
            font.bold: true
            font.pixelSize: fontSize14
            wheelEnabled: false
            autoRepeat: true
            Layout.margins:  4
            Layout.maximumHeight: Math.floor(parent.height *0.20)
            Layout.preferredWidth: Math.floor(parent.width *0.8)
            Layout.preferredHeight:Math.floor( more.width *0.20)
            Layout.minimumHeight: 20
            flat : false
            onReleased: {
                if ( pressed )  {
                    if (p.targetTemp+stepsize<maxTemp){
                        p.targetTemp+=stepsize;
                    } else {
                        p.targetTemp=maxTemp;
                    }
                } else {
                    if (p.targetTemp<maxTemp){
                        p.targetTemp++;
                    }
                }
                timerSaisie.start();
                humantouch=true;
                targetChanged( btnOnOff.checked,p.targetTemp);
            }
        }

        RowLayout {
            Layout.maximumHeight: Math.floor(parent.height *0.30)
            Layout.preferredHeight:Math.floor( more.width *0.30)
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins:  4
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            spacing : 0

            Label {
                id : lab_Temps
                visible: true
                text: p.actualTemp.toString() + "/" +p.targetTemp.toString()
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: fontSize14
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            TextField {
                id: tf_Target
                visible: false
                padding: 0
                text:p.targetTemp.toString()
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator {bottom: control.minTemp; top: control.maxTemp;}
                font.pixelSize: fontSize14
                Layout.fillWidth: true
                Layout.fillHeight: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                onEditingFinished: {
                    if (acceptableInput) {
                        p.targetTemp=text.valueOf();
                    }
                    focus = false;

                    timerSaisie.start();
                }
            }

            Timer {
                id :timerSaisie
                triggeredOnStart : false
                interval: 4000
                running: false
                onTriggered: {
                    if (running) {
                        lab_Temps.visible=false;
                        tf_Target.visible=true;
                    } else {
                        lab_Temps.visible=true;
                        tf_Target.visible=false;
                    }
                }
            }

        }


        RoundButton {
            id: less
            text: "-"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            hoverEnabled: true
            font.bold: true
            font.pixelSize: fontSize14
            wheelEnabled: false
            autoRepeat: true
            Layout.margins:  4
            Layout.maximumHeight: Math.floor(parent.height *0.20)
            Layout.preferredWidth: Math.floor(parent.width *0.8)
            Layout.preferredHeight: Math.floor(more.width *0.20)
            Layout.minimumHeight: 20
            flat : false
            onReleased: {
                if ( pressed ) {
                    if (p.targetTemp+stepsize>minTemp) {
                        p.targetTemp-=stepsize;
                    } else {
                        p.targetTemp=minTemp;
                    }
                } else {
                    if (p.targetTemp>minTemp) {
                        p.targetTemp--;
                    }
                }
                timerSaisie.start();
                humantouch=true;
                targetChanged( btnOnOff.checked,p.targetTemp);
            }

        }

        Button {
            id: btnOnOff
            text: qsTr("ON")
            font.pixelSize: fontSize14
            Layout.minimumHeight:  Math.floor( parent.height *0.20)
            Layout.preferredHeight: 30
            Layout.maximumHeight: Math.floor( parent.height *0.20)
            Layout.fillHeight: true
            Layout.fillWidth: true
            hoverEnabled: true
            checked: false
            checkable: true
            flat : false
            Layout.margins:  4
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            onCheckedChanged: {
                if (checked==true) {
                    text = qsTr("Off")
                }   else {
                    text = qsTr("On")
                }
                humantouch=true;
                heatChanged(checked,p.targetTemp);
            }
        }
    }
}
