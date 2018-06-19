package com.gamesparks
{
    import com.adobe.serialization.json.*;
    import com.adobe.utils.*;
    import com.gamesparks.api.messages.*;
    import com.gamesparks.api.requests.*;
    import com.gamesparks.sockets.*;
    import com.hurlant.crypto.hash.*;
    import com.hurlant.util.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.utils.*;

    public class GS extends Object
    {
        private var _id:int;
        protected var _itemsToSend:Array;
        protected var _persistentItemsToSend:Array;
        private var _pendingRequests:Dictionary;
        private var _queueTimeout:uint;
        private var _persistentQueueTimeout:uint;
        protected var _authToken:String;
        private var _userId:String;
        private var _persistantQueue_playerId:String = "";
        private var _sessionId:String;
        private var _initialised:Boolean = false;
        private var _initialising:Boolean = false;
        private var _disabledSharedObject:Boolean = false;
        protected var _available:Boolean = false;
        protected var _authenticated:Boolean = false;
        protected var _durableQueueDirty:Boolean = false;
        protected var _durableQueuePaused:Boolean = false;
        private var _requestBuilder:GSRequestBuilder;
        private var _messageHandler:GSMessageHandler;
        private var _messageCallback:Function;
        private var _availabilityCallback:Function;
        private var _authenticatedCallback:Function;
        private var _messageHandlerCallback:Function;
        private var _liveServers:Boolean = false;
        private var _apiSecret:String = "";
        private var _apiKey:String = "";
        private var _apiCredential:String = "";
        private var _url:String;
        private var _lbUrl:String;
        protected var _socket:GSSocket;
        private var _logger:Function;
        private var _stopped:Boolean = false;
        private var _stage:Stage;
        private var _overlay:Sprite;
        private var _text:TextField;
        private var _format:TextFormat;
        private var _webSocketErrorCount:Number = 0;
        private static var _nextID:int = 0;
        private static const _VERSION:String = "1.4.9";

        public function GS(param1:Stage = null)
        {
            this._itemsToSend = new Array();
            this._persistentItemsToSend = new Array();
            this._pendingRequests = new Dictionary();
            this._messageHandler = new GSMessageHandler();
            this._overlay = new Sprite();
            this._text = new TextField();
            this._format = new TextFormat();
            this._id = _nextID + 1;
            this._stage = param1;
            if (this._stage != null)
            {
                this._stage.addChild(this._overlay);
                this._stage.addEventListener(Event.RESIZE, this.resizeListener);
            }
            this._requestBuilder = new GSRequestBuilder(this);
            return;
        }// end function

        private function resizeListener(event:Event) : void
        {
            this._text.y = this._stage.stageHeight - this._text.textHeight - 5;
            this._text.width = this._stage.stageWidth;
            return;
        }// end function

        public function setAvailabilityCallback(param1:Function) : GS
        {
            this._availabilityCallback = param1;
            return this;
        }// end function

        public function setAuthenticatedCallback(param1:Function) : GS
        {
            this._authenticatedCallback = param1;
            return this;
        }// end function

        public function setMessageHandlerCallback(param1:Function) : GS
        {
            this._messageHandlerCallback = param1;
            return this;
        }// end function

        public function setUseLiveServices(param1:Boolean) : GS
        {
            this._liveServers = param1;
            this.buildServiceUrl();
            return this;
        }// end function

        public function setApiSecret(param1:String) : GS
        {
            this._apiSecret = param1;
            this.buildServiceUrl();
            return this;
        }// end function

        public function setApiKey(param1:String) : GS
        {
            this._apiKey = param1;
            this.buildServiceUrl();
            return this;
        }// end function

        public function setApiCredential(param1:String) : GS
        {
            this._apiCredential = param1;
            this.buildServiceUrl();
            return this;
        }// end function

        public function setLogger(param1:Function) : GS
        {
            this._logger = param1;
            return this;
        }// end function

        public function connect() : void
        {
            this._initialising = true;
            this._stopped = false;
            if (this._webSocketErrorCount > 5)
            {
                this._webSocketErrorCount = 0;
                this._url = this._lbUrl;
            }
            this._socket = new GSSocketSelector(this.log);
            this._socket.Connect(this._url, this.handleWebSocketOpen, this.handleWebSocketClosed, this.handleWebSocketMessage, this.handleWebSocketError);
            this.log("*** GameSparks SDK v" + _VERSION + " connecting to " + this._url + " " + this._socket.GetName());
            if (this._stage != null)
            {
                if (this._text.stage)
                {
                    this._text.parent.removeChild(this._text);
                }
                if (this._liveServers == false)
                {
                    this._format.color = 14540253;
                    this._format.size = 18;
                    this._text.text = "GameSparks Preview mode v" + _VERSION;
                    this._text.setTextFormat(this._format);
                    this._text.y = this._stage.stageHeight - this._text.textHeight - 5;
                    this._text.width = this._stage.stageWidth;
                    this._overlay.addChild(this._text);
                    this._overlay.mouseEnabled = false;
                    this._overlay.mouseChildren = false;
                }
            }
            return;
        }// end function

        private function initialisePersistentQueue() : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            if (this._persistantQueue_playerId == this._userId)
            {
                return;
            }
            var _loc_1:* = this._durableQueuePaused;
            this._durableQueuePaused = true;
            var _loc_2:* = new Array();
            var _loc_3:* = this.loadPersistentQueue();
            if (_loc_3 != null && _loc_3.length > 0)
            {
                _loc_4 = _loc_3.split(/\n/);
                for each (_loc_5 in _loc_4)
                {
                    
                    if (StringUtil.trim(_loc_5).length > 0)
                    {
                        _loc_6 = this.stringToRequest(_loc_5);
                        if (_loc_6 != null)
                        {
                            _loc_2.push(_loc_6);
                        }
                    }
                }
            }
            this._persistentItemsToSend = _loc_2;
            this._persistantQueue_playerId = this._userId;
            this._durableQueuePaused = _loc_1;
            this.log("_persistantQueue COUNT: " + this._persistentItemsToSend.length);
            return;
        }// end function

        private function writeDurableQueueIfDirty() : void
        {
            var _loc_1:* = null;
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_4:* = null;
            var _loc_5:* = null;
            if (this._durableQueueDirty)
            {
                this._durableQueueDirty = false;
                _loc_1 = "";
                for each (_loc_2 in this._persistentItemsToSend)
                {
                    
                    _loc_3 = JSON.encode(_loc_2.getData());
                    _loc_4 = new Object();
                    _loc_4.rq = _loc_3;
                    _loc_4.sq = this.getHmac(_loc_3);
                    _loc_5 = JSON.encode(_loc_4);
                    _loc_1 = _loc_1 + (_loc_5 + "\n");
                }
                this.savePersistentQueue(_loc_1);
            }
            return;
        }// end function

        public function send(param1:GSRequest) : void
        {
            var _loc_2:* = null;
            if (param1.durable)
            {
                this.sendDurable(param1);
            }
            else
            {
                _loc_2 = param1.getData();
                _loc_2.requestId = String(new Date().time) + String(Math.floor(Math.random() * 10000));
                this._itemsToSend.push(param1);
                setTimeout(this.timeoutRequest, param1.getTimeoutSeconds() * 1000, param1);
                this.processQueues();
            }
            return;
        }// end function

        public function sendDurable(param1:GSRequest) : void
        {
            param1.durable = true;
            this._persistentItemsToSend.push(param1);
            this._durableQueueDirty = true;
            this.processQueues();
            return;
        }// end function

        private function timeoutRequest(param1:GSRequest) : void
        {
            var _loc_4:* = null;
            var _loc_2:* = this._itemsToSend.indexOf(param1);
            var _loc_3:* = false;
            if (_loc_2 != -1)
            {
                this._itemsToSend.splice(_loc_2, 1);
                _loc_3 = true;
            }
            if (this._pendingRequests[param1.getData().requestId] == param1)
            {
                delete this._pendingRequests[param1.getData().requestId];
                _loc_3 = true;
            }
            if (_loc_3 && param1.callback != null && !param1.durable)
            {
                _loc_4 = new Object();
                _loc_4.error = new Object();
                _loc_4.error.error = "timeout";
                _loc_4.requestId = param1.getAttribute("requestId");
                param1.callback(_loc_4);
            }
            return;
        }// end function

        public function disconnect() : void
        {
            if (this._queueTimeout)
            {
                clearTimeout(this._queueTimeout);
                this._queueTimeout = 0;
            }
            this._stopped = true;
            if (this._socket != null)
            {
                this._socket.Dispose();
                this._socket.Disconnect();
                this._socket = null;
            }
            this.setAvailable(false);
            this.setAuthenticated(null);
            return;
        }// end function

        public function getRequestBuilder() : GSRequestBuilder
        {
            return this._requestBuilder;
        }// end function

        public function getMessageHandler() : GSMessageHandler
        {
            return this._messageHandler;
        }// end function

        private function handleWebSocketClosed(param1:GSSocket) : void
        {
            var socket:* = param1;
            if (socket != this._socket)
            {
                this.log("handleWebSocketClosed : Not the right socket " + socket.GetName());
                return;
            }
            if (socket != null)
            {
                this.log("Websocket closed. initialised=" + this._initialised + " initialising=" + this._initialising + " stopped=" + this._stopped + " " + socket.GetName());
            }
            else
            {
                this.log("Websocket closed. initialised=" + this._initialised + " initialising=" + this._initialising + " stopped=" + this._stopped);
            }
            if (this._queueTimeout)
            {
                clearTimeout(this._queueTimeout);
                this._queueTimeout = 0;
            }
            if (this._socket != null)
            {
                this._socket.Dispose();
                this._socket.Disconnect();
                this._socket = null;
            }
            this.setAvailable(false);
            if ((this._initialised || this._initialising) && !this._stopped)
            {
                setTimeout(function () : void
            {
                var _loc_2:* = _webSocketErrorCount + 1;
                _webSocketErrorCount = _loc_2;
                connect();
                return;
            }// end function
            , 5000);
            }
            return;
        }// end function

        private function handleWebSocketError(param1:GSSocket, param2:String = "") : void
        {
            var socket:* = param1;
            var error:* = param2;
            if (socket != this._socket)
            {
                this.log("handleWebSocketErr : Not the right socket " + socket.GetName());
                return;
            }
            if (socket != null)
            {
                this.log("Websocket Error " + error + " " + socket.GetName());
            }
            else
            {
                this.log("Websocket Error " + error);
            }
            if ((this._initialised || this._initialising) && !this._stopped && this._socket != null && !this._socket.Connected() && this._socket.IsExternal())
            {
                if (this._queueTimeout)
                {
                    clearTimeout(this._queueTimeout);
                    this._queueTimeout = 0;
                }
                if (this._socket != null)
                {
                    this._socket.Dispose();
                    this._socket.Disconnect();
                    this._socket = null;
                }
                setTimeout(function () : void
            {
                var _loc_2:* = _webSocketErrorCount + 1;
                _webSocketErrorCount = _loc_2;
                connect();
                return;
            }// end function
            , 5000);
            }
            return;
        }// end function

        private function handleWebSocketOpen(param1:GSSocket) : void
        {
            if (param1 != this._socket)
            {
                this.log("handleWebSocketOpen : Not the right socket " + param1.GetName());
                return;
            }
            this.log("Websocket Connected " + param1.GetName());
            this._webSocketErrorCount = 0;
            return;
        }// end function

        private function processQueues(event:TimerEvent = null) : void
        {
            var request:GSRequest;
            var data:Object;
            var request2:GSRequest;
            var data2:Object;
            var packet:String;
            var event:* = event;
            if (this._queueTimeout)
            {
                clearTimeout(this._queueTimeout);
                this._queueTimeout = 0;
            }
            if (this._socket != null && this._socket.Connected() && this._available)
            {
                this.writeDurableQueueIfDirty();
                if (!this._durableQueuePaused && this._authenticated)
                {
                    var _loc_3:* = 0;
                    var _loc_4:* = this._persistentItemsToSend;
                    do
                    {
                        
                        request = _loc_4[_loc_3];
                        if (request.durableRetryTicks == 0 || request.durableRetryTicks < new Date().time)
                        {
                            try
                            {
                                request.durableRetryTicks = new Date().time + 10000;
                                data = request.getData();
                                data.requestId = "d_" + String(new Date().time) + String(Math.floor(Math.random() * 10000));
                                this.log(JSON.encode(data));
                                this._socket.Send(JSON.encode(data));
                                this._pendingRequests[data.requestId] = request;
                            }
                            catch (e:Error)
                            {
                            }
                        }
                    }while (_loc_4 in _loc_3)
                }
                else
                {
                    this._queueTimeout = setTimeout(this.processQueues, 500);
                }
                if (this._itemsToSend.length > 0)
                {
                    request2 = this._itemsToSend.shift();
                    try
                    {
                        data2 = request2.getData();
                        packet = JSON.encode(data2);
                        this.log(packet);
                        this._socket.Send(packet);
                        this._pendingRequests[data2.requestId] = request2;
                    }
                    catch (e:Error)
                    {
                        _itemsToSend.unshift(_itemsToSend);
                    }
                }
                if (this._itemsToSend.length > 0 && this._queueTimeout == 0)
                {
                    this._queueTimeout = setTimeout(this.processQueues, 500);
                }
            }
            else if (this._socket != null)
            {
                this._queueTimeout = setTimeout(this.processQueues, 500);
            }
            return;
        }// end function

        private function log(param1:String) : void
        {
            var _loc_2:* = null;
            if (this._logger != null)
            {
                _loc_2 = new Date();
                this._logger(_loc_2.hours + ":" + _loc_2.minutes + ":" + _loc_2.seconds + "." + _loc_2.milliseconds + "  id: " + this._id + "   " + param1);
            }
            return;
        }// end function

        private function saveSettings() : void
        {
            var sharedObject:SharedObject;
            if (this._disabledSharedObject)
            {
                return;
            }
            try
            {
                sharedObject = SharedObject.getLocal("settings");
                sharedObject.data.authToken = this._authToken;
                sharedObject.flush();
            }
            catch (e:Error)
            {
                log("UNABLE TO SAVE SETTINGS");
            }
            return;
        }// end function

        private function loadPersistentQueue() : String
        {
            var sharedObject:SharedObject;
            if (!this._userId || this._disabledSharedObject)
            {
                return null;
            }
            try
            {
                sharedObject = SharedObject.getLocal(this._userId);
                return sharedObject.data.durableRequests;
            }
            catch (e:Error)
            {
                log("UNABLE TO LOAD PERSISTENT QUEUE " + e);
            }
            return null;
        }// end function

        private function savePersistentQueue(param1:String) : void
        {
            var sharedObject:SharedObject;
            var queue:* = param1;
            if (!this._userId || this._disabledSharedObject)
            {
                return;
            }
            try
            {
                sharedObject = SharedObject.getLocal(this._userId);
                sharedObject.data.durableRequests = queue;
                sharedObject.flush();
            }
            catch (e:Error)
            {
                log("UNABLE TO SAVE PERSISTENT QUEUE " + e);
            }
            return;
        }// end function

        protected function resetPersistentQueue() : void
        {
            var _loc_1:* = null;
            if (!this._userId || this._disabledSharedObject)
            {
                return;
            }
            try
            {
                _loc_1 = SharedObject.getLocal(this._userId);
                _loc_1.clear();
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public function disableSharedObject(param1:Boolean) : void
        {
            this._disabledSharedObject = param1;
            return;
        }// end function

        private function handleWebSocketMessage(param1:String, param2:GSSocket) : void
        {
            var _loc_4:* = null;
            var _loc_5:* = null;
            var _loc_6:* = null;
            this.log("handleWebSocketMessage" + param1);
            var _loc_3:* = JSON.decode(param1);
            if (_loc_3.authToken)
            {
                this._authToken = _loc_3.authToken;
                this.saveSettings();
                this.log("Got authtoken " + this._authToken);
            }
            if (StringUtil.endsWith(_loc_3["@class"], "Response") && _loc_3.userId)
            {
                this._userId = _loc_3.userId;
                this.initialisePersistentQueue();
                this.setAuthenticated(this._userId);
            }
            if (_loc_3.connectUrl != null)
            {
                this.log("Changing connect url to " + _loc_3.connectUrl);
                if (this._queueTimeout)
                {
                    clearTimeout(this._queueTimeout);
                    this._queueTimeout = 0;
                }
                this._available = false;
                this._authenticated = false;
                if (this._socket != null)
                {
                    this._socket.Dispose();
                    this._socket.Disconnect();
                    this._socket = null;
                }
                this._url = _loc_3.connectUrl;
                this.connect();
                return;
            }
            if (_loc_3.requestId && _loc_3.requestId != 0)
            {
                _loc_4 = this._pendingRequests[_loc_3.requestId];
                delete this._pendingRequests[_loc_3.requestId];
                if (_loc_4 != null)
                {
                    if (_loc_4.durableRetryTicks > 0)
                    {
                        if (!StringUtil.endsWith(_loc_3["@class"], "ClientError"))
                        {
                            this._durableQueueDirty = this._persistentItemsToSend.splice(this._persistentItemsToSend.indexOf(_loc_4), 1);
                            this.writeDurableQueueIfDirty();
                        }
                    }
                    if (_loc_4.callback != null)
                    {
                        _loc_4.callback(_loc_3);
                    }
                }
                else
                {
                    this.log("no pending request yet");
                }
            }
            else if (StringUtil.endsWith(_loc_3["@class"], "Message"))
            {
                if (this._messageHandlerCallback != null)
                {
                    this._messageHandlerCallback(_loc_3);
                }
                this._messageHandler.handle(_loc_3);
            }
            else if (_loc_3["@class"] == ".AuthenticatedConnectResponse" && param2 == this._socket)
            {
                if (_loc_3.error)
                {
                    this.log("INCORRECT APIKEY / APISECRET");
                    this.disconnect();
                }
                if (_loc_3.sessionId != null)
                {
                    this._sessionId = _loc_3.sessionId;
                }
                if (_loc_3.nonce != null)
                {
                    _loc_5 = new Object();
                    _loc_5["@class"] = ".AuthenticatedConnectRequest";
                    _loc_5.hmac = this.getHmac(_loc_3.nonce);
                    if (this._authToken != "0")
                    {
                        _loc_5.authToken = this._authToken;
                    }
                    if (this._sessionId != null)
                    {
                        _loc_5.sessionId = this._sessionId;
                    }
                    _loc_6 = JSON.encode(_loc_5);
                    this.log("sending:" + _loc_6);
                    if (this._socket != null)
                    {
                        this._socket.Send(_loc_6);
                    }
                    return;
                }
                else if (_loc_3.connectUrl == null)
                {
                    this._initialised = true;
                    this._initialising = false;
                    this.setAvailable(true);
                    this.processQueues();
                }
            }
            return;
        }// end function

        private function setAvailable(param1:Boolean) : void
        {
            if (this._available != param1)
            {
                this._available = param1;
                if (this._availabilityCallback != null)
                {
                    this._availabilityCallback(param1);
                }
            }
            return;
        }// end function

        private function setAuthenticated(param1:String) : void
        {
            if (param1)
            {
                this._authenticated = true;
            }
            else
            {
                this._authenticated = false;
            }
            if (this._authenticatedCallback != null)
            {
                this._authenticatedCallback(param1);
            }
            return;
        }// end function

        private function getHmac(param1:String) : String
        {
            var _loc_2:* = new HMAC(new SHA256());
            var _loc_3:* = Hex.toArray(Hex.fromString(this._apiSecret));
            var _loc_4:* = Hex.toArray(Hex.fromString(param1));
            return Base64.encodeByteArray(_loc_2.compute(_loc_3, _loc_4));
        }// end function

        private function stringToRequest(param1:String) : GSRequest
        {
            var _loc_2:* = JSON.decode(param1);
            var _loc_3:* = _loc_2.rq;
            var _loc_4:* = _loc_2.sq;
            var _loc_5:* = this.getHmac(_loc_3);
            if (this.getHmac(_loc_3) == _loc_4)
            {
                return new GSRequest(this, JSON.decode(_loc_3));
            }
            return null;
        }// end function

        private function buildServiceUrl() : void
        {
            var _loc_1:* = 0;
            var _loc_2:* = null;
            var _loc_4:* = null;
            var _loc_3:* = this._apiKey;
            if (this._liveServers)
            {
                _loc_2 = "live";
            }
            else
            {
                _loc_2 = "preview";
            }
            if (this._apiCredential.length == 0)
            {
                _loc_4 = "device";
            }
            else
            {
                _loc_4 = this._apiCredential;
            }
            _loc_1 = this._apiSecret.indexOf(":");
            if (_loc_1 > 0)
            {
                _loc_4 = "secure";
                _loc_3 = this._apiSecret.substring(0, _loc_1) + "/" + _loc_3;
            }
            this._url = "wss://" + _loc_2 + "-" + _loc_3 + ".ws.gamesparks.net/ws/" + _loc_4 + "/" + _loc_3;
            this._lbUrl = this._url;
            return;
        }// end function

    }
}
