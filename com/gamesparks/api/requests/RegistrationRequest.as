package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class RegistrationRequest extends GSRequest
    {

        public function RegistrationRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".RegistrationRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : RegistrationRequest
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
                    callback(new RegistrationResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : RegistrationRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setDisplayName(param1:String) : RegistrationRequest
        {
            this.data["displayName"] = param1;
            return this;
        }// end function

        public function setPassword(param1:String) : RegistrationRequest
        {
            this.data["password"] = param1;
            return this;
        }// end function

        public function setSegments(param1:Object) : RegistrationRequest
        {
            this.data["segments"] = param1;
            return this;
        }// end function

        public function setUserName(param1:String) : RegistrationRequest
        {
            this.data["userName"] = param1;
            return this;
        }// end function

    }
}
