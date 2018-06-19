package com.adobe.net.proxies
{
    import flash.events.*;
    import flash.net.*;

    public class RFC2817Socket extends Socket
    {
        private var proxyHost:String = null;
        private var host:String = null;
        private var proxyPort:int = 0;
        private var port:int = 0;
        private var deferredEventHandlers:Object;
        private var buffer:String;

        public function RFC2817Socket(param1:String = null, param2:int = 0)
        {
            this.deferredEventHandlers = new Object();
            this.buffer = new String();
            if (param1 != null && param2 != 0)
            {
                super(param1, param2);
            }
            return;
        }// end function

        public function setProxyInfo(param1:String, param2:int) : void
        {
            this.proxyHost = param1;
            this.proxyPort = param2;
            var _loc_3:* = this.deferredEventHandlers[ProgressEvent.SOCKET_DATA];
            var _loc_4:* = this.deferredEventHandlers[Event.CONNECT];
            if (_loc_3 != null)
            {
                super.removeEventListener(ProgressEvent.SOCKET_DATA, _loc_3.listener, _loc_3.useCapture);
            }
            if (_loc_4 != null)
            {
                super.removeEventListener(Event.CONNECT, _loc_4.listener, _loc_4.useCapture);
            }
            return;
        }// end function

        override public function connect(param1:String, param2:int) : void
        {
            if (this.proxyHost == null)
            {
                this.redirectConnectEvent();
                this.redirectSocketDataEvent();
                super.connect(param1, param2);
            }
            else
            {
                this.host = param1;
                this.port = param2;
                super.addEventListener(Event.CONNECT, this.onConnect);
                super.addEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
                super.connect(this.proxyHost, this.proxyPort);
            }
            return;
        }// end function

        private function onConnect(event:Event) : void
        {
            this.writeUTFBytes("CONNECT " + this.host + ":" + this.port + " HTTP/1.1\n\n");
            this.flush();
            this.redirectConnectEvent();
            return;
        }// end function

        private function onSocketData(event:ProgressEvent) : void
        {
            while (this.bytesAvailable != 0)
            {
                
                this.buffer = this.buffer + this.readUTFBytes(1);
                if (this.buffer.search(/\r?\n\r?\n$/) != -1)
                {
                    this.checkResponse(event);
                    break;
                }
            }
            return;
        }// end function

        private function checkResponse(event:ProgressEvent) : void
        {
            var _loc_3:* = null;
            var _loc_2:* = this.buffer.substr((this.buffer.indexOf(" ") + 1), 3);
            if (_loc_2.search(/^2/) == -1)
            {
                _loc_3 = new IOErrorEvent(IOErrorEvent.IO_ERROR);
                _loc_3.text = "Error connecting to the proxy [" + this.proxyHost + "] on port [" + this.proxyPort + "]: " + this.buffer;
                this.dispatchEvent(_loc_3);
            }
            else
            {
                this.redirectSocketDataEvent();
                this.dispatchEvent(new Event(Event.CONNECT));
                if (this.bytesAvailable > 0)
                {
                    this.dispatchEvent(event);
                }
            }
            this.buffer = null;
            return;
        }// end function

        private function redirectConnectEvent() : void
        {
            super.removeEventListener(Event.CONNECT, this.onConnect);
            var _loc_1:* = this.deferredEventHandlers[Event.CONNECT];
            if (_loc_1 != null)
            {
                super.addEventListener(Event.CONNECT, _loc_1.listener, _loc_1.useCapture, _loc_1.priority, _loc_1.useWeakReference);
            }
            return;
        }// end function

        private function redirectSocketDataEvent() : void
        {
            super.removeEventListener(ProgressEvent.SOCKET_DATA, this.onSocketData);
            var _loc_1:* = this.deferredEventHandlers[ProgressEvent.SOCKET_DATA];
            if (_loc_1 != null)
            {
                super.addEventListener(ProgressEvent.SOCKET_DATA, _loc_1.listener, _loc_1.useCapture, _loc_1.priority, _loc_1.useWeakReference);
            }
            return;
        }// end function

        override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
        {
            if (param1 == Event.CONNECT || param1 == ProgressEvent.SOCKET_DATA)
            {
                this.deferredEventHandlers[param1] = {listener:param2, useCapture:param3, priority:param4, useWeakReference:param5};
            }
            else
            {
                super.addEventListener(param1, param2, param3, param4, param5);
            }
            return;
        }// end function

    }
}
