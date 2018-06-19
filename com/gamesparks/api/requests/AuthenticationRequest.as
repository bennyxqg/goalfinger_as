package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class AuthenticationRequest extends GSRequest
    {

        public function AuthenticationRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".AuthenticationRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : AuthenticationRequest
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
                    callback(new AuthenticationResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : AuthenticationRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setPassword(param1:String) : AuthenticationRequest
        {
            this.data["password"] = param1;
            return this;
        }// end function

        public function setUserName(param1:String) : AuthenticationRequest
        {
            this.data["userName"] = param1;
            return this;
        }// end function

    }
}
