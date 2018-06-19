package com.gamesparks.sockets
{
    import com.gamesparks.sockets.*;
    import flash.net.*;
    import flash.utils.*;

    public class GSSocketSelector extends Object implements GSSocket
    {
        private var _logger:Function;
        private var wrappedSocket:GSSocket;
        private var _onOpen:Function;
        private var _onClose:Function;
        private var _onMessage:Function;
        private var _onError:Function;
        private var _closeEventFired:Boolean = false;
        private var _errorEventFired:Boolean = false;
        private var errorCount:int = 0;
        protected var attemptedSockets:Array;
        protected var _errors:Array;
        protected var selectorInstance:Number = 0;
        private static var socketCreator:Function;
        private static var socketType:String;
        static var selectorCount:Number = 0;

        public function GSSocketSelector(param1:Function)
        {
            this.attemptedSockets = new Array();
            this._errors = new Array();
            this._logger = param1;
            selectorCount = (selectorCount + 1);
            this.selectorInstance = selectorCount + 1;
            return;
        }// end function

        public function Dispose() : void
        {
            if (this.wrappedSocket != null)
            {
                this.wrappedSocket.Dispose();
            }
            this.cleanupAttemptedSockets(this.wrappedSocket);
            return;
        }// end function

        public function Connect(param1:String, param2:Function, param3:Function, param4:Function, param5:Function) : Boolean
        {
            var superThis:GSSocket;
            var url:* = param1;
            var onOpen:* = param2;
            var onClose:* = param3;
            var onMessage:* = param4;
            var onError:* = param5;
            var timeout:int;
            this._onError = onError;
            this._onOpen = onOpen;
            this._onMessage = onMessage;
            this._onClose = onClose;
            if (socketCreator != null)
            {
                this._logger("Creating " + socketType);
                this.wrappedSocket = socketCreator(socketType + "_" + this.selectorInstance);
                this.wrappedSocket.Connect(url, this.handleWebSocketOpen, this.handleWebSocketClosed, this.handleWebSocketMessage, this.handleWebSocketError);
                this.wrappedSocket.EnablePing();
            }
            else
            {
                try
                {
                    this._logger("Creating 3 Sockets");
                    this.createSocket(url, this.externalSocket, "externalSocket_" + this.selectorInstance);
                    this.createSocket(url, this.internalSocket, "internalSocket_" + this.selectorInstance);
                    this.createSocket(url, this.internalSecureSocket, "internalSecureSocket_" + this.selectorInstance);
                }
                catch (err:Error)
                {
                    _logger(err);
                }
            }
            superThis;
            setTimeout(function () : void
            {
                var error:String;
                if (wrappedSocket == null || !wrappedSocket.Connected())
                {
                    try
                    {
                        cleanupAttemptedSockets(superThis);
                        var _loc_2:* = 0;
                        var _loc_3:* = _errors;
                        while (_loc_3 in _loc_2)
                        {
                            
                            error = _loc_3[_loc_2];
                            _logger(error);
                        }
                        _onError(superThis);
                    }
                    catch (e:Error)
                    {
                        _logger(e);
                    }
                    if (wrappedSocket == null)
                    {
                        Connect(url, onOpen, onClose, onMessage, onError);
                    }
                }
                return;
            }// end function
            , timeout);
            return true;
        }// end function

        private function cleanupAttemptedSockets(param1:GSSocket) : void
        {
            var _loc_2:* = null;
            for each (_loc_2 in this.attemptedSockets)
            {
                
                if (_loc_2 != param1)
                {
                    _loc_2.Dispose();
                    _loc_2.Disconnect();
                }
            }
            _loc_4.length = 0;
            return;
        }// end function

        private function createSocket(param1:String, param2:Function, param3:String) : void
        {
            var url:* = param1;
            var creator:* = param2;
            var name:* = param3;
            var newSocket:* = this.creator(name);
            if (newSocket != null)
            {
                this.attemptedSockets.push(newSocket);
                newSocket.Connect(url, this.handleWebSocketOpen, this.handleWebSocketClosed, function (param1:String, param2:GSSocket) : void
            {
                if (wrappedSocket == null)
                {
                    socketCreator = creator;
                    socketType = name;
                    wrappedSocket = param2;
                    cleanupAttemptedSockets(param2);
                    handleWebSocketOpen(param2);
                    handleWebSocketMessage(param1, param2);
                }
                else if (wrappedSocket == param2)
                {
                    handleWebSocketMessage(param1, param2);
                }
                return;
            }// end function
            , function (param1:GSSocket, param2:String = "") : void
            {
                if (socketCreator == null && param2 != "")
                {
                    _errors.push(param1.GetName() + ":" + param2);
                }
                handleWebSocketError(param1, param2);
                return;
            }// end function
            );
            }
            return;
        }// end function

        private function handleWebSocketMessage(param1:String, param2:GSSocket) : void
        {
            if (this.wrappedSocket == param2)
            {
                this._onMessage(param1, this);
            }
            return;
        }// end function

        private function handleWebSocketOpen(param1:GSSocket) : void
        {
            if (this.wrappedSocket == param1)
            {
                this._onOpen(this);
            }
            return;
        }// end function

        private function handleWebSocketClosed(param1:GSSocket) : void
        {
            if (this.wrappedSocket == param1 && !this._closeEventFired)
            {
                this._closeEventFired = true;
                this._onClose(this);
            }
            return;
        }// end function

        private function handleWebSocketError(param1:GSSocket, param2:String = "") : void
        {
            var _loc_3:* = this;
            var _loc_4:* = this.errorCount + 1;
            _loc_3.errorCount = _loc_4;
            if (this.wrappedSocket == param1 || this.errorCount == this.attemptedSockets.length)
            {
                if (!this._errorEventFired)
                {
                    this._errorEventFired = true;
                    this._onError(this);
                }
                setTimeout(this.handleWebSocketClosed, 500, param1);
            }
            return;
        }// end function

        public function Send(param1:String, param2:Boolean = false) : void
        {
            if (this.wrappedSocket != null)
            {
                this.wrappedSocket.Send(param1, param2);
            }
            return;
        }// end function

        public function Connected() : Boolean
        {
            if (this.wrappedSocket != null)
            {
                return this.wrappedSocket.Connected();
            }
            return false;
        }// end function

        public function Disconnect() : void
        {
            if (this.wrappedSocket != null)
            {
                this.wrappedSocket.Disconnect();
            }
            return;
        }// end function

        public function EnablePing() : void
        {
            return;
        }// end function

        private function externalSocket(param1:String) : GSSocket
        {
            if (!GSSocketExternal.IsAvailable())
            {
                return null;
            }
            return new GSSocketExternal(this._logger);
        }// end function

        private function internalSecureSocket(param1:String) : GSSocket
        {
            if (!SecureSocket.isSupported)
            {
                return null;
            }
            var _loc_2:* = new GSSocketGimite(this._logger, param1, true);
            return _loc_2;
        }// end function

        private function internalSocket(param1:String) : GSSocket
        {
            var _loc_2:* = new GSSocketGimite(this._logger, param1, false);
            return _loc_2;
        }// end function

        public function GetName() : String
        {
            return "socketSelector_" + this.selectorInstance;
        }// end function

        public function IsExternal() : Boolean
        {
            return this.wrappedSocket.IsExternal();
        }// end function

        public static function reset() : void
        {
            if (socketCreator != null)
            {
                socketCreator = null;
                socketType = null;
            }
            return;
        }// end function

    }
}
