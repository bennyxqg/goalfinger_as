package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class PushRegistrationRequest extends GSRequest
    {

        public function PushRegistrationRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".PushRegistrationRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : PushRegistrationRequest
        {
            this.timeoutSeconds = param1;
            return this;
        }// end function

        override public function send(param1:Function) : String
        {
            var callback:* = param1;
            return super.send(function (param1:Object) : void
            {
                if (callback != null)
                {
                    callback(new PushRegistrationResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : PushRegistrationRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setDeviceOS(param1:String) : PushRegistrationRequest
        {
            this.data["deviceOS"] = param1;
            return this;
        }// end function

        public function setPushId(param1:String) : PushRegistrationRequest
        {
            this.data["pushId"] = param1;
            return this;
        }// end function

    }
}
