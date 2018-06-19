package net.gimite.websocket
{
    import flash.events.*;
    import flash.utils.*;

    public class WebSocketEvent extends Event
    {
        public var message:String;
        public var wasClean:Boolean;
        public var code:int;
        public var reason:String;
        public var payload:ByteArray;
        public static const OPEN:String = "open";
        public static const CLOSE:String = "close";
        public static const MESSAGE:String = "message";
        public static const ERROR:String = "error";
        public static const PONG:String = "pong";

        public function WebSocketEvent(param1:String, param2:String = null, param3:Boolean = false, param4:Boolean = false)
        {
            super(param1, param3, param4);
            this.message = param2;
            return;
        }// end function

        override public function clone() : Event
        {
            var _loc_1:* = new WebSocketEvent(this.type, this.message, this.bubbles, this.cancelable);
            _loc_1.wasClean = this.wasClean;
            _loc_1.code = this.code;
            _loc_1.reason = this.reason;
            return _loc_1;
        }// end function

        override public function toString() : String
        {
            return "WebSocketEvent: " + this.type + ": " + this.message;
        }// end function

    }
}
