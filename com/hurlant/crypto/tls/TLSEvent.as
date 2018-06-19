package com.hurlant.crypto.tls
{
    import flash.events.*;
    import flash.utils.*;

    public class TLSEvent extends Event
    {
        public var data:ByteArray;
        public static const DATA:String = "data";
        public static const READY:String = "ready";
        public static const PROMPT_ACCEPT_CERT:String = "promptAcceptCert";

        public function TLSEvent(param1:String, param2:ByteArray = null)
        {
            this.data = param2;
            super(param1, false, false);
            return;
        }// end function

    }
}
