import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.impl 2.2
import QtQuick.Layouts 1.3
import "Components"



Page {
    id: filespage
    title: qsTr("Files")
    implicitHeight: 480
    implicitWidth: 800

    property string originsel
    property string pathsel
    property bool showFocusHighlight: false
    property string  location: "local"
   // property var locale: Qt.locale()


    Component {
        id: highlight
        Rectangle {
            width: fileview.width
            height:  fontSize24
            color: Default.frameLightColor
            opacity: 0.5
            radius: 5
            y: (fileview.currentIndex>-1)?fileview.currentItem*fontSize12 : 0
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
    }



    Component {
        id : colHeader
        Rectangle {
            anchors { left: parent.left; right: parent.right }
            height:  Math.floor(rowheader.implicitHeight * 1.5)
            border.width: 2
            radius: 2
            Row  {
                id : rowheader
                anchors { fill: parent; margins: 2 }
                Text {
                    id: name
                    width: Math.floor(parent.width * 0.65)
                    font.bold: true
                    font.pixelSize: fontSize12
                    text: qsTr("Name")
                }

                Text {
                    id: size
                    font.bold: true
                    font.pixelSize: fontSize12
                    width: Math.floor(parent.width * 0.12)
                    text: qsTr("Size")
                }
                Text {
                    id: date
                    font.bold: true
                    font.pixelSize: fontSize12
                    width: Math.floor(parent.width * 0.23)
                    text: qsTr("Date")
                }
            }
        }
    }

    Component {
        id : filesDelegate
        Item {
            id:  wrappper
            anchors { left: parent.left; right: parent.right }
            height : fontSize12 *2

            Row {
                id :rowdelegate
                anchors { fill: parent; margins: 2 }
                Text {
                    id : filename
                    text: display
                    font.bold: (type!=='folder')?false:true
                    font.pixelSize: fontSize12
                    width: Math.floor(parent.width * 0.65)
                }

                Text {
                    id : filesize
                    text:(type!=='folder')?Math.round(size/1024) +"Kb":''
                    font.bold: false
                    font.pixelSize: fontSize12
                    width: Math.floor(parent.width * 0.12)
                }
                Text {
                    id : filedate
                    text: (type!=='folder')?new Date(date*1000).toLocaleString(locale,"yyyy/MM/dd HH:mm:ss"):""
                    font.bold: false
                    font.pixelSize: fontSize12
                    width: Math.floor(parent.width * 0.23)
                }
                Text {
                    id : reforigin
                    text: origin
                    visible: false
                }
                Text {
                    id : refpath
                    text: path
                    visible: false
                }

            }
            MouseArea {
                anchors.fill: parent
                onClicked:{
                    showFocusHighlight=true;
                    wrappper.ListView.view.currentIndex = index;
                    originsel=reforigin.text
                    pathsel=refpath.text;
                }
                onDoubleClicked: {
                    if (type==='folder') {
                        showFocusHighlight=false;
                        opc.getfilespath(location,refpath.text);
                        fileview.currentIndex=-1;
                    } else {
                        opc.fileselect(originsel,pathsel);
                    }

                }
            }
        }
    }


    ListView {
        id : fileview
        anchors.margins: 10
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: lbPath.top
        anchors.left: parent.left
        flickableDirection: Flickable.AutoFlickDirection
        highlight: highlight
        highlightFollowsCurrentItem: showFocusHighlight
        focus: true
        header: colHeader
        headerPositioning  : ListView.InlineHeader
        model:  opc.filesmodel
        delegate: filesDelegate

    }
    Label {
        id: lbPath
        height: fontSize14*2
        text: pathsel
        font.italic: true
        font.pixelSize:fontSize14
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.bottom:  parent.bottom
        anchors.margins: 10
    }

    footer:ToolBar {
        id: toolBar
        contentHeight: fontSize16 *3
        anchors.margins: fontSize16
        spacing: fontSize16


        RowLayout {
            id: rowLayout
            spacing: 0
            anchors.fill: parent
            anchors.leftMargin: fontSize16


            HeaderButton {
                id: tbSelect
                text: qsTr("Select")
                autoExclusive: false
                Layout.preferredWidth:  Math.floor(parent.width * 0.20)
                Layout.fillHeight: true
                Image {
                    source:"qrc:/Images/files/checked.svg"
                }
                font.pixelSize: fontSize12
                checked: false
                checkable: false
                onClicked: {

                    if (  pathsel !== "") {
                        opc.fileselect(originsel,pathsel);
                    } else {
                        //fileChoosed(false,"",0,0,0);
                    }
                }
            }


            HeaderButton {
                id: tbLocal
                Image {
                    source: "qrc:/Images/files/Local.svg"
                }
                text: qsTr("Local")
                Layout.preferredWidth:  Math.floor(parent.width * 0.20)
                Layout.fillHeight: true
                autoExclusive: true
                font.pixelSize: fontSize12
                checked: true
                checkable: true
                onClicked: {
                    location="local";
                    fileview.currentIndex=-1;
                    opc.getfilespath(location);
                }
            }
            HeaderButton {
                id: tbSdCard
                Image {
                    source: "qrc:/Images/files/sdcard.svg"
                }
                text: qsTr("SdCard")
                Layout.preferredWidth:  Math.floor(parent.width * 0.20)
                Layout.fillHeight: true
                autoExclusive: true
                font.pixelSize: fontSize12
                checked: false
                checkable: true
                onClicked: {
                    location="sdcard";
                    fileview.currentIndex=-1;
                    opc.getfilespath(location);
                }
            }
            HeaderButton {
                id: tbUsb
                Image {
                    source: "qrc:/Images/files/usb.svg"
                }
                text: qsTr("Usb")
                autoExclusive: true
                Layout.preferredWidth:  Math.floor(parent.width * 0.20)
                Layout.fillHeight: true
                font.pixelSize: fontSize12
                checked: false
                checkable: true
                onClicked: {
                    location="usb";
                    fileview.currentIndex=-1;
                    opc.getfilespath(location);
                }
            }
            HeaderButton {
                id: tbInfo
                Image {
                    source: "qrc:/Images/files/info.svg"
                }
                text: qsTr("Info")
                Layout.preferredWidth:  Math.floor(parent.width * 0.20)
                Layout.fillHeight: true
                autoExclusive: false
                font.pixelSize: fontSize12
                checked: false
                checkable: false
                onClicked: {
                    joginfo.openinfo();

                }
            }


        }
    }
    JobInfo {
        id : joginfo
    }

    function init(){
        opc.getfilespath(location);
    }
}

