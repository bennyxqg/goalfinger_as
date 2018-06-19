package com.gamesparks.sockets
{
    import com.gamesparks.sockets.*;
    import flash.external.*;
    import flash.system.*;
    import flash.utils.*;

    public class GSSocketExternal extends Object implements GSSocket
    {
        private var instanceId:String;
        private var _connected:Boolean = false;
        private var _pingEnabled:Boolean = false;
        private var _onOpen:Function;
        private var _onClose:Function;
        private var _onMessage:Function;
        private var _onError:Function;
        private var _logger:Function;
        public static var networkAvailable:Boolean = true;
        private static var _nextID:int = 0;
        private static var _nextJsFunctionId:int = 0;

        public function GSSocketExternal(param1:Function)
        {
            var logger:* = param1;
            this.instanceId = new Date().time.toString() + "_" + (_nextID++).toString();
            this._logger = function (param1:String) : void
            {
                logger("GSSocketExternal:" + param1);
                return;
            }// end function
            ;
            return;
        }// end function

        public function Dispose() : void
        {
            this._logger("dispose");
            ExternalInterface.addCallback("OnClose_" + this.instanceId, function () : void
            {
                return;
            }// end function
            );
            ExternalInterface.addCallback("OnOpen_" + this.instanceId, function () : void
            {
                return;
            }// end function
            );
            ExternalInterface.addCallback("OnMessage_" + this.instanceId, function () : void
            {
                return;
            }// end function
            );
            ExternalInterface.addCallback("OnError_" + this.instanceId, function () : void
            {
                return;
            }// end function
            );
            ExternalInterface.addCallback("Log_" + this.instanceId, function () : void
            {
                return;
            }// end function
            );
            return;
        }// end function

        private function internalOnClose(param1:Object = null) : void
        {
            if (param1 != null && param1.code != 1000 && param1.code != 1005)
            {
                this._logger("abnormal close event. code: " + param1.code + "  reason: " + param1.reason);
            }
            else
            {
                this._logger("normal close event.");
            }
            this.Dispose();
            if (this._connected)
            {
                this._connected = false;
                this._onClose(this);
            }
            return;
        }// end function

        private function internalOnError(param1:Object = null) : void
        {
            if (param1 != null)
            {
                this._logger(JSON.stringify(param1));
            }
            if (!this._connected)
            {
                this._onError(this, param1);
            }
            else
            {
                this.internalOnClose(param1);
            }
            return;
        }// end function

        private function internalOnOpen(param1:Object = null) : void
        {
            this._connected = true;
            this._onOpen(this);
            if (this._pingEnabled)
            {
                this.keepAlive();
            }
            return;
        }// end function

        private function internalOnMessage(param1:Object = null) : void
        {
            this._onMessage(param1, this);
            return;
        }// end function

        private function internalLog(param1:Object) : void
        {
            this._logger(JSON.stringify(param1));
            return;
        }// end function

        public function Connect(param1:String, param2:Function, param3:Function, param4:Function, param5:Function) : Boolean
        {
            var _loc_12:* = false;
            if (!networkAvailable || !IsAvailable())
            {
                return false;
            }
            var _loc_6:* = param1.match(/^(\w+):\/\/([^\/:]+)(:(\d+))?(\/.*)?(\?.*)?$/);
            if (!param1.match(/^(\w+):\/\/([^\/:]+)(:(\d+))?(\/.*)?(\?.*)?$/))
            {
                this._logger("invalid url: " + param1);
                return false;
            }
            var _loc_7:* = _loc_6[1];
            var _loc_8:* = _loc_6[2];
            var _loc_9:* = _loc_7 == "wss" ? (443) : (80);
            var _loc_10:* = parseInt(_loc_6[4]) || _loc_9;
            Security.loadPolicyFile("xmlsocket://" + _loc_8 + ":" + _loc_10);
            Security.loadPolicyFile("xmlsocket://gamesparksbetabinaries.blob.core.windows.net");
            this._onError = param5;
            this._onOpen = param2;
            this._onMessage = param4;
            this._onClose = param3;
            ExternalInterface.addCallback("OnClose_" + this.instanceId, this.internalOnClose);
            ExternalInterface.addCallback("OnError_" + this.instanceId, this.internalOnError);
            ExternalInterface.addCallback("OnOpen_" + this.instanceId, this.internalOnOpen);
            ExternalInterface.addCallback("OnMessage_" + this.instanceId, this.internalOnMessage);
            ExternalInterface.addCallback("Log_" + this.instanceId, this.internalLog);
            var _loc_11:* = "function(url, id, instanceId){\n" + "\ttry { var ws = new WebSocket(decodeURIComponent(url));\n" + "       if (ws != null) { \n" + "\t\tws.instanceId = instanceId;\n" + "\t\tws.onopen \t  =  function(event) { try { document.getElementById(id).OnOpen_" + this.instanceId + "(event); } catch (ex) {};};\n" + "\t\tws.onmessage  =  function(event) { try { document.getElementById(id).OnMessage_" + this.instanceId + "(event.data); } catch (ex) {};};\n" + "\t\tws.onclose \t  =  function(event) { try { document.getElementById(id).OnClose_" + this.instanceId + "(event); } catch (ex) {};};\n" + "\t\tws.onerror \t  =  function(event) { try { document.getElementById(id).OnError_" + this.instanceId + "(null); } catch (ex) {};};\n" + "\t\twindow.gsWebSocket = ws;\n" + "\t\treturn true; }\n" + "\t} catch (err) {\n" + "\t\ttry { document.getElementById(id).OnError_" + this.instanceId + "(err);} catch (ex) {};\n" + "\t}\n" + "\treturn false;\n" + "}\n";
            try
            {
                _loc_12 = ExternalInterface.call(_loc_11, encodeURIComponent(param1), ExternalInterface.objectID, this.instanceId);
            }
            catch (e:Error)
            {
            }
            return _loc_12;
        }// end function

        public function Connected() : Boolean
        {
            var _loc_2:* = false;
            if (!networkAvailable || !IsAvailable())
            {
                return false;
            }
            var _loc_1:* = "function(id, instanceId){\n" + "try{\n" + "\tvar currentSocket = window.gsWebSocket;\n" + "\treturn (currentSocket != null && currentSocket.readyState == 1 && currentSocket.instanceId == instanceId);\n" + "}\n" + "catch (err) { \n" + "\t try {document.getElementById(id).OnError_" + this.instanceId + "(err); } catch (ex) {};\n" + "} return false;\n }";
            try
            {
                _loc_2 = ExternalInterface.call(_loc_1, ExternalInterface.objectID, this.instanceId);
            }
            catch (e:Error)
            {
            }
            if (this._connected && !_loc_2)
            {
                this._onClose(this);
            }
            return _loc_2;
        }// end function

        public function Send(param1:String, param2:Boolean = false) : void
        {
            if (!networkAvailable || !IsAvailable())
            {
                return;
            }
            param1 = encodeURIComponent(param1);
            var _loc_3:* = "function(id, instanceId, msg, waitBufferedQueue){\n" + "\ttry {\n" + "\t\tvar currentSocket = window.gsWebSocket;\n" + "\t\tif (currentSocket != null && currentSocket.readyState == 1) {\n" + "\t\t\tvar data = decodeURIComponent(msg);\n" + "\t\t\tif (currentSocket.bufferedAmount == 0 || !waitBufferedQueue) {\n" + "\t\t\t\tcurrentSocket.send(data);\n" + "\t\t\t}\n" + "\t\t}\n" + "\t}\n" + "\tcatch (err){\n" + "\t \ttry {document.getElementById(id).OnError_" + this.instanceId + "(err); } catch (ex) {};\n" + "\t};}";
            try
            {
                ExternalInterface.call(_loc_3, ExternalInterface.objectID, this.instanceId, param1, param2);
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public function Disconnect() : void
        {
            this._pingEnabled = false;
            if (!IsAvailable())
            {
                return;
            }
            var _loc_1:* = "try {\n" + "\tvar currentSocket = window.gsWebSocket;\n" + "\tif (currentSocket != null && currentSocket.readyState == 1 && currentSocket.instanceId == instanceId) {\n" + "\t\tcurrentSocket.close();\n" + "\t\twindow.gsWebSocket = null;\n" + "\t}\n" + "} catch (err) {\n" + "\t try {document.getElementById(id).OnError_" + this.instanceId + "(err); } catch (ex) {};\n" + "}";
            try
            {
                ExternalInterface.call("function(id, instanceId){ " + _loc_1 + " }", ExternalInterface.objectID, this.instanceId);
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        public function EnablePing() : void
        {
            this._pingEnabled = true;
            return;
        }// end function

        public function keepAlive() : void
        {
            if (!this._connected || !IsAvailable() || !this._pingEnabled)
            {
                return;
            }
            if (networkAvailable)
            {
                this.Send(" ", true);
            }
            setTimeout(function () : void
            {
                keepAlive();
                return;
            }// end function
            , 5000);
            return;
        }// end function

        public function GetName() : String
        {
            return this.instanceId;
        }// end function

        public function IsExternal() : Boolean
        {
            return true;
        }// end function

        public static function IsAvailable() : Boolean
        {
            var _loc_1:* = ExternalInterface.available;
            var _loc_2:* = false;
            if (_loc_1)
            {
                try
                {
                    _loc_2 = ExternalInterface.call("function(){ return (\"WebSocket\" in window); }");
                }
                catch (e:Error)
                {
                }
            }
            return _loc_1 && _loc_2;
        }// end function

    }
}
