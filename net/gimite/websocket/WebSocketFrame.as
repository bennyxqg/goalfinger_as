package net.gimite.websocket
{
    import flash.utils.*;

    public class WebSocketFrame extends Object
    {
        public var fin:Boolean = true;
        public var rsv:int = 0;
        public var opcode:int = -1;
        public var payload:ByteArray;
        public var length:uint = 0;
        public var mask:Boolean = false;

        public function WebSocketFrame()
        {
            return;
        }// end function

    }
}
