import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQml 2.2
import QtWebSockets 1.0

import "OctoPrintShared.js" as OPS

Item {

    id: octoprintclient
    property string url:   'http://127.0.0.1:5000'
    property string apikey : ''
    property string username : ''
    property string userkey : ''
    property string printerProfile   : ''
    property string printerPort : ''
    property bool   debug: false

    property bool _connected : false

    property real intervalcnx: 10
    property int retrycpt : 0

    property string stateText : '';
    property bool stateOperational: false
    property bool statePaused : false
    property bool statePrinting : false
    property bool stateCancelling: false
    property bool statePausing : false
    property bool stateSdReady: false
    property bool stateError: false
    property bool stateReady: false
    property bool stateClosedOrError: false
    property bool stateFileSelected: false
    property bool stateViewJob: false

    property bool heatedBed: false
    property int extrudercount: 1

    signal tempChanged(bool history, date heure)
    signal logChanged(string log)
    signal profileChanged()

    signal tryConnect(int cnttry)
    signal currentZChanged(real z)
    signal positionUpdate(real x, real y , real z)

    property alias filesmodel: filesmodel
    ListModel {
        id : filesmodel
    }


    function sendRequest(method,api,data,callback ){
        var xhr = new XMLHttpRequest;
        var cmdurl= url+api;


        xhr.onreadystatechange = (function(myxhr) {
            return function() {
                if(myxhr.readyState === XMLHttpRequest.DONE)
                {
                    if (debug) {
                        console.debug("XMLHttpRequest.readyState : " +myxhr.readyState);
                        console.debug("XMLHttpRequest.statusText : " +myxhr.statusText);
                        console.debug("XMLHttpRequest.status : " +myxhr.status);
                        console.debug("XMLHttpRequest.responseText : " +myxhr.responseText);
                    }
                    callback(myxhr);
                }
            }
        })(xhr);
        xhr.open(method,cmdurl,false);
        xhr.setRequestHeader('Content-Type', 'application/json; charset=utf-8');
        xhr.setRequestHeader('X-Api-Key',apikey);
        xhr.setRequestHeader('Content-Lenght',String(data).length);
        if (debug){
            console.debug('OctoPintClient url :',cmdurl);
            console.debug('OctoPintClient POST:',data);
            console.debug('OctoPintClient Length :' ,String(data).length);
        }
        xhr.send(data);
    }

    /* CONNECTION HANDLING
           * http://docs.octoprint.org/en/master/api/connection.html#issue-a-connection-command
           * Issue a connection command. Currently available command are: connect, disconnect, fake_ack
           * Status Codes:
           * 204 No Content – No errorresponseText
           * 400 Bad Request – If the selected port or baudrate for a connect command are not part of the available options.
    */

    function  connectprofile(){
        if (_connected) return;
        var params=' { "command": "connect" , "printerProfile": "'+printerProfile +'" , "port": "'+printerPort+'" }';
        sendRequest('POST','/api/connection',params,
                    function (o) {
                        if (o.status === 204)
                        {
                            // _connected=true;
                            wsocket.connect();
                            cnxtimer.stop();
                        } else  {
                            console.log("Error connecting " +o.responseText);
                            _connected=false;
                        }
                    }
                    ) ;
    }

    function  disconnect(){
        if (!_connected) return;
        var params=' { "command": "disconnect" }';
        sendRequest('POST','/api/connection',params,
                    function (o) {
                        if (o.status === 204)
                        {
                            _connected=false;
                            cnxtimer.stop();
                        }
                    }
                    ) ;
    }

    function  getprinterprofiles(){
        if (!_connected) return;
        var params='';
        sendRequest('GET','/api/printerprofiles',params,
                    function (p) {
                        var jsonrep =JSON.parse(p.responseText);
                        var profiles = jsonrep.profiles;
                        for (var i in profiles) {
                            if (profiles[i].id===printerProfile) {
                                extrudercount=profiles[i].extruder.count;
                                heatedBed=profiles[i].heatedBed;
                                profileChanged();
                            }
                        }

                        if (!p.status === 200)
                        {
                            console.log(" error get list Printer profiles " );
                        }
                    }
                    ) ;
    }


    function  tooltarget( tool,target){
        if (!_connected) return;
        tool=tool.toLowerCase();
        var params = ' { "command": "target" ,  "targets": { "' + tool +'":'+  target + '}}'  ;
        sendRequest('POST','/api/printer/tool',params,
                    function (p) {
                        if (p.status !== 204)
                        {
                            console.log(" error target cmd" +p.responseText);
                        }
                    }
                    ) ;
    }

    function  toolstarget( targets){
        if (!_connected) return;
        var params = ' { "command": "target" ,  "targets": { ' + targets + '}}'  ;
        sendRequest('POST','/api/printer/tool',params,
                    function (p) {
                        if (p.status !== 204)
                        {
                            console.log(" error targets cmd" +p.responseText);
                        }
                    }
                    ) ;
    }


    function  bedtarget(target){
        if (!_connected) return;
        var params = ' { "command": "target" ,  "target": '+  target + '}'  ;
        sendRequest('POST','/api/printer/bed',params,
                    function (p) {
                        if (p.status !== 204)
                        {
                            console.log(" error bed target cmd" +p.responseText);
                        }
                    }
                    ) ;
    }


    function  sendcommand(command){
        if (!_connected) return;
        var params = ' { "command": "'+  command + '"}'  ;
        sendRequest('POST','/api/printer/command',params,
                    function (p) {
                        if (p.status !== 204)
                        {
                            console.log(" error sendcommand  :" +p.responseText);
                        }
                    }
                    ) ;
    }

    function  flowrate(factor){
        if (!_connected) return;
        var params = ' { "command": "flowrate" ,  "factor": '+  factor + '}'  ;
        sendRequest('POST','/api/printer/tool',params,
                    function (p) {
                        if (p.status !== 204)
                        {
                            console.log(" error flowrate cmd :" +p.responseText);
                        }
                    }
                    ) ;
    }

    function  selecttool(tool){
        if (!_connected) return;
        tool=tool.toLowerCase();
        var params = ' { "command": "select" ,  "tool": "'+  tool + '"}'  ;
        sendRequest('POST','/api/printer/tool',params,
                    function (p) {
                        if (p.status !== 204)
                        {
                            console.log(" error select tool cmd" +p.responseText);
                        }
                    }
                    ) ;
    }

    function  extrudetool(amount){
        if (!_connected) return;
        var params = ' { "command": "extrude" ,  "amount": '+  amount + '}'  ;
        sendRequest('POST','/api/printer/tool',params,
                    function (p) {
                        if (p.status !== 204)
                        {
                            console.log(" error extrude cmd :" +p.responseText);
                        }
                    }
                    ) ;
    }

    function  jogprinter( axe,valeur){
        if (!_connected) return;
        axe= axe.toUpperCase();
        var params = ' { "command": "jog" ';
        params=params.concat( ' , "x":');
        params=params.concat((axe==="X")? valeur: 0) ;
        params=params.concat( ' , "y":');
        params=params.concat((axe==="Y")? valeur: 0) ;
        params=params.concat( ', "z":');
        params=params.concat((axe==="Z")? valeur: 0) ;
        params=params.concat('}');
        sendRequest('POST','/api/printer/printhead',params,
                    function (p) {
                        if (p.status !== 204)
                        {
                            console.log(" error jog cmd" +p.responseText);
                        }
                    }
                    ) ;
    }


    function  homeprinter(axe){
        if (!_connected) return;
        axe= axe.toLowerCase();
        if (axe==='xyz' ) {
            axe='x","y","z';
        }
        var params = ' { "command": "home"  , "axes": ["' + axe + '"] }';
        sendRequest('POST','/api/printer/printhead',params,
                    function (p) {
                        if (p.status !== 204)
                        {
                            console.log(" error home cmd" +p.responseText);
                        }
                    }
                    ) ;
    }

    function  getfilespath(location,path){
        if (!_connected) return;
        var params = ' { "command": "files" ,  "recursive":"false"}'  ;
        var api = '/api/files';

        if (typeof location === "undefined") {
            location='local';
        }
        api=api.concat('/',location)

        if (typeof path !== "undefined") {
            api=api.concat('/',path)
        }
        api=api.concat('?recursive=false')
        sendRequest('GET',api,params,
                    function (p) {
                        if (p.status === 200)
                        {
                            var jsonrep =JSON.parse(p.responseText);
                            //console.debug(p.responseText);
                            filesmodel.clear();
                            var files =jsonrep.files;
                            for (var i in files ) {
                                filesmodel.append(files[i]);
                            }
                            var childrens =jsonrep.children;

                            if (typeof childrens !== "undefined") {
                                for (var  j in childrens ) {
                                    filesmodel.append(childrens[j]);
                                }
                            }
                        } else {
                            console.log(" error getfilespath  :" +p.responseText);
                        }
                    }
                    ) ;
    }


    function  fileselect(origin,path){
        if (!_connected) return;
        var params = ' { "command" : "select" }'  ;
        //var api = 'onClicked: {';
        var api = '/api/files';
        api=api.concat('/',origin,'/',path);
        sendRequest('POST',api,params,
                    function (p) {
                        if (p.status !== 204)
                        {
                            console.log(" error fileselect  :" +p.responseText);
                            msgerror.open("Error file",p.responseText);
                        }
                    }
                    ) ;
    }



    function  jobcommand(command){
        if (!_connected) return;
        command=command.toLowerCase();
        var params = ' { "command": '+  command + '}'  ;
        console.debug(params);
        sendRequest('POST','/api/job',params,
                    function (p) {
                        if (p.status !== 204)
                        {
                            console.log(" error jobcommand  :" +p.responseText);
                        }
                    }
                    ) ;
    }

    function  actioncore(command){
        if (!_connected) return;
        command=command.toLowerCase();
        var params = '';
        sendRequest('POST','/api/system/commands/core/'+command,params,
                    function (p) {
                        if (p.status !== 204)
                        {
                            console.log(" error jobcommand  :" +p.responseText);
                        }
                    }
                    ) ;
    }


    /*============================================================================================= */
    WebSocket {
        id: wsocket
        property var statusNames: ({})
        property int advisedTimeout: 30000



        function connect(){
            active=false; active=true; // toggle status to force reconnect if URL doesn't change
            var socketURL = octoprintclient.url.replace( /^(?:\w+:\/\/)/, 'ws://' );
            url = socketURL+'/sockjs/websocket';
        }


        onTextMessageReceived: {
            if (debug) console.log('OPC websock recv:',message);
            var rmsg=message;
            //console.debug('OPC websock recv:',message);
            if ("string"===typeof message) message=JSON.parse(message);

            // =========================== CONNECTED PAYLOAD ===========================
            if (message.connected) {
                var msg = '{ "auth" : "' + username + ':' + userkey + '" }'
                if (debug) console.debug('OPC WebSocket send apikey connected !');
                wsocket.sendTextMessage(msg);
            }

            var temps = null;
            var t = null;
            var now = null;
            var logs = null;


            // =========================== HISTORY PAYLOAD ===========================
            if (message.history)  {

                if (message.history.logs) {
                    logs =message.history.logs ;
                    for ( t in logs ) {
                        logChanged(logs[t]);
                    }
                }

                if (message.history.temps)  {
                    temps =message.history.temps ;
                    for ( t in temps ) {
                        now = new Date(temps[t].time*1000);

                        if (temps[t].bed) {
                            OPS.temps.bed.actual = temps[t].bed.actual;
                            OPS.temps.bed.target = temps[t].bed.target;
                        }
                        if (temps[t].tool0) {
                            OPS.temps.tool0.actual = temps[t].tool0.actual;
                            OPS.temps.tool0.target = temps[t].tool0.target;
                        }

                        if (temps[t].tool1) {
                            OPS.temps.tool1.actual = temps[t].tool1.actual;
                            OPS.temps.tool1.target = temps[t].tool1.target;
                        }
                        if (temps[t].tool2) {
                            OPS.temps.tool2.actual = temps[t].tool2.actual;
                            OPS.temps.tool2.target = temps[t].tool2.target;
                        }
                        if (temps[t].tool3) {
                            OPS.temps.tool3.actual = temps[t].tool3.actual;
                            OPS.temps.tool3.target = temps[t].tool3.target;
                        }
                        tempChanged(true,now);
                    }

                }
            }

            // =========================== CURRENT PAYLOAD ===========================
            if (message.current) {
                if (debug) console.debug('message current !');

                if (message.current.temps)  {
                    temps =message.current.temps ;
                    for ( t in temps ) {
                        now = new Date(temps[t].time);
                        if (temps[t].bed) {
                            OPS.temps.bed.actual = temps[t].bed.actual;
                            OPS.temps.bed.target = temps[t].bed.target;
                        }
                        if (temps[t].tool0) {
                            OPS.temps.tool0.actual = temps[t].tool0.actual;
                            OPS.temps.tool0.target = temps[t].tool0.target;
                        }

                        if (temps[t].tool1) {
                            OPS.temps.tool1.actual = temps[t].tool1.actual;
                            OPS.temps.tool1.target = temps[t].tool1.target;
                        }
                        if (temps[t].tool2) {
                            OPS.temps.tool2.actual = temps[t].tool2.actual;
                            OPS.temps.tool2.target = temps[t].tool2.target;
                        }
                        if (temps[t].tool3) {
                            OPS.temps.tool3.actual = temps[t].tool3.actual;
                            OPS.temps.tool3.target = temps[t].tool3.target;
                        }
                    }
                    tempChanged(false,now);
                }


                if (message.current.logs) {
                    logs =message.current.logs ;
                    for (t in logs ) {
                        logChanged(logs[t]);
                    }
                }



                if (message.current.state) {
                    stateText        = message.current.state.text;
                    stateOperational =  message.current.state.flags.operational;
                    statePaused =  message.current.state.flags.paused;
                    statePrinting =  message.current.state.flags.printing;
                    stateCancelling=  message.current.state.flags.cancelling;
                    statePausing =  message.current.state.flags.pausing;
                    stateSdReady=  message.current.state.flags.sdReady;
                    stateError=  message.current.state.flags.error;
                    stateReady=  message.current.state.flags.ready;
                    stateClosedOrError=  message.current.state.flags.closedOrError;
                }

                if (message.current.job) {
                    OPS.job=message.current.job;
                    if  (stateFileSelected) stateViewJob=true;
                }

                if (message.current.progress) {
                    OPS.progress=message.current.progress;
                }
                if (message.current.messages) {
                    OPS.messages=message.current.messages;
                }
                if (message.current.serverTime) {
                    OPS.serverTime = new Date(message.current.serverTime*1000);
                }

            }

            // =========================== EVENT PAYLOAD ===========================
            if (message.event) {
                if (message.event.type==='ZChange') {
                    currentZChanged( message.event.payload.new);

                } else if (message.event.type==='PositionUpdate') {
                    positionUpdate(message.event.payload.x,message.event.payload.y,message.event.payload.z)

                } else if (message.event.type==='Home') {
                    sendcommand("M114");
                } else if (message.event.type==='ToolChange') {
                    // tool changed
                } else if (message.event.type==='FirmwareData') {
                    // M115 asked

                } else if (message.event.type==='FileSelected') {
                    stateViewJob=false;
                    stateFileSelected=true;

                } else if (message.event.type==='ClientOpened') {
                    logChanged("Client opened from remote address "+ message.event.payload.remoteAddress);


                } else if (message.event.type==='PrintResumed') {
                    statePrinting=true;
                    statePaused =false;

                } else if (message.event.type==='PrintCancelled') {
                    statePrinting=true;
                    statePaused =false;

                } else if (message.event.type==='ClientClosed') {
                    logChanged("Client closed from remote address "+ message.event.payload.remoteAddress);


                } else if (message.event.type==='PrinterStateChanged') {
                    console.log("PrinterStateChanged : " + message.event.payload.state_id);
                    switch (message.event.payload.state_id) {


                    case "OFFLINE":
                        break;

                    case "STARTING":
                        break;

                    case "OPERATIONAL":
                        statePrinting=false;
                        break;

                    case "PRINTING":
                        statePrinting=true;
                        stateReady=false;
                        break;

                    case "PAUSING":
                        statePausing=true;
                        break;

                    case "PAUSED":
                        statePaused=true;
                        statePrinting=false;
                        break;

                    case "RESUMING":
                        statePaused=false;
                        statePrinting=true;
                        stateReady=false;
                        break;

                    case "CANCELLING":
                        stateCancelling=true;
                        break;


                    }


                } else {
                    console.debug(" ==== EVENT PAYLOAD =>  " +message.event.type );
                    console.debug(rmsg);
                }
            }

        }

        onStatusChanged: {
            if (!wsocket) return debug && console.debug('OctoPrintClient has been deleted'); // Happens when the app is shutting down
            if (debug) console.debug('OPC WebSocket status:',statusNames[wsocket.status]);
            switch(wsocket.status){
            case WebSocket.Open:
                if (debug) console.debug(' WebSocket.open ');
                _connected=true;
                break;

            case WebSocket.Error:
                console.log('OPC WebSocket error:', wsocket.errorString);
                _connected=false;
                disconnect();
                wsocket.active=false;
                break;

            case WebSocket.Closed:
                if (debug) console.debug('OPC attempting to reconnect...');
                _connected=false;
                connect();
                break;
            }
        }


        Component.onCompleted: {
            statusNames[WebSocket.Connecting] = 'WebSocket.Connecting';
            statusNames[WebSocket.Open]       = 'WebSocket.Open';
            statusNames[WebSocket.Closing]    = 'WebSocket.Closing';
            statusNames[WebSocket.Closed]     = 'WebSocket.Closed';
            statusNames[WebSocket.Error]      = 'WebSocket.Error';
        }

    }


    Timer {
        id : cnxtimer
        interval:1000*intervalcnx
        running : false
        repeat : true
        triggeredOnStart: true

        onTriggered: {
            retrycpt++;
            if (retrycpt<10)  {
                if (debug) console.debug('cnxtimer connect profile try :' +retrycpt);
                tryConnect(retrycpt);
                connectprofile();
            } else {
                mainpage.msgerror.open("Erreur configuration","Review your configuration, timout when try connecting !")
                stop();
            }
        }
    }



    function init() {
        retrycpt=0;
        cnxtimer.start();
    }

}
