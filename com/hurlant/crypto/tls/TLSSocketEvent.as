package com.hurlant.crypto.tls
{
    import com.hurlant.crypto.cert.*;
    import flash.events.*;

    public class TLSSocketEvent extends Event
    {
        public var cert:X509Certificate;
        public static const PROMPT_ACCEPT_CERT:String = "promptAcceptCert";

        public function TLSSocketEvent(param1:X509Certificate = null)
        {
            super(PROMPT_ACCEPT_CERT, false, false);
            this.cert = param1;
            return;
        }// end function

    }
}
