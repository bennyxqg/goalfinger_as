package com.gamesparks.sockets
{
    import com.gamesparks.sockets.*;
    import flash.utils.*;
    import net.gimite.websocket.*;

    public class GSSocketGimite extends Object implements GSSocket
    {
        private var websocket:WebSocket;
        private var secret:String;
        private var connected:Boolean = false;
        private var pingEnabled:Boolean = false;
        private var onOpen:Function;
        private var onClose:Function;
        private var onMessage:Function;
        private var onError:Function;
        private var logger:Function;
        public var useFlashSecureSocket:Boolean;
        public var name:String;
        private var hasErrored:Boolean = false;
        private var waitingForPong:Boolean = false;
        public static var networkAvailable:Boolean = true;

        public function GSSocketGimite(param1:Function, param2:String, param3:Boolean)
        {
            var logger:* = param1;
            var name:* = param2;
            var useFlashSecureSocket:* = param3;
            this.name = name;
            this.logger = function (param1:String) : void
            {
                logger((useFlashSecureSocket ? ("GSSocketSS:") : ("GSSocketTLS:")) + param1);
                return;
            }// end function
            ;
            this.useFlashSecureSocket = useFlashSecureSocket;
            return;
        }// end function

        public function Dispose() : void
        {
            if (this.websocket != null)
            {
                this.logger("dispose");
                this.websocket.removeEventListener(WebSocketEvent.CLOSE, this.handleClose);
                this.websocket.removeEventListener(WebSocketEvent.OPEN, this.handleOpen);
                this.websocket.removeEventListener(WebSocketEvent.MESSAGE, this.handleMessage);
                this.websocket.removeEventListener(WebSocketEvent.ERROR, this.handleError);
                this.websocket.removeEventListener(WebSocketEvent.PONG, this.handlePong);
            }
            return;
        }// end function

        public function Connect(param1:String, param2:Function, param3:Function, param4:Function, param5:Function) : Boolean
        {
            if (!networkAvailable)
            {
                return false;
            }
            this.onError = param5;
            this.onOpen = param2;
            this.onMessage = param4;
            this.onClose = param3;
            this.websocket = new WebSocket(0, param1, [], "*", null, 0, null, null, new GSSocketGimiteLogger(this.logger), this.useFlashSecureSocket);
            this.websocket.addEventListener(WebSocketEvent.CLOSE, this.handleClose);
            this.websocket.addEventListener(WebSocketEvent.OPEN, this.handleOpen);
            this.websocket.addEventListener(WebSocketEvent.MESSAGE, this.handleMessage);
            this.websocket.addEventListener(WebSocketEvent.ERROR, this.handleError);
            this.websocket.addEventListener(WebSocketEvent.PONG, this.handlePong);
            return true;
        }// end function

        private function handleClose(event:WebSocketEvent) : void
        {
            this.Dispose();
            this.waitingForPong = false;
            this.connected = false;
            this.onClose(this);
            return;
        }// end function

        private function handleOpen(event:WebSocketEvent) : void
        {
            this.connected = true;
            this.onOpen(this);
            if (this.pingEnabled)
            {
                this.keepAlive();
            }
            return;
        }// end function

        private function handleMessage(event:WebSocketEvent) : void
        {
            this.onMessage(event.message, this);
            return;
        }// end function

        private function handleError(event:WebSocketEvent) : void
        {
            if (!this.hasErrored)
            {
                this.hasErrored = true;
                this.onError(this);
            }
            return;
        }// end function

        public function Connected() : Boolean
        {
            return this.websocket != null && this.websocket.getReadyState() == 1 && networkAvailable;
        }// end function

        public function Send(param1:String, param2:Boolean = false) : void
        {
            if (!networkAvailable)
            {
                return;
            }
            this.websocket.send(param1);
            return;
        }// end function

        public function Disconnect() : void
        {
            this.pingEnabled = false;
            if (this.websocket != null)
            {
                this.websocket.close();
                this.websocket = null;
            }
            return;
        }// end function

        public function EnablePing() : void
        {
            this.pingEnabled = true;
            return;
        }// end function

        public function keepAlive() : void
        {
            if (!this.connected || !this.pingEnabled)
            {
                return;
            }
            if (networkAvailable && this.websocket != null)
            {
                try
                {
                    this.websocket.sendPing(new ByteArray());
                }
                catch (e:Error)
                {
                }
                this.waitingForPong = true;
            }
            setTimeout(function () : void
            {
                if (websocket != null)
                {
                    keepAlive();
                }
                else
                {
                    pingEnabled = false;
                }
                return;
            }// end function
            , 5000);
            return;
        }// end function

        private function handlePong(event:WebSocketEvent) : void
        {
            this.waitingForPong = false;
            return;
        }// end function

        public function GetName() : String
        {
            return this.name;
        }// end function

        public function IsExternal() : Boolean
        {
            return false;
        }// end function

    }
}
