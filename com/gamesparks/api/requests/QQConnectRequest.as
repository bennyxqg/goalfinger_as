package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class QQConnectRequest extends GSRequest
    {

        public function QQConnectRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".QQConnectRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : QQConnectRequest
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

        public function setScriptData(param1:Object) : QQConnectRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setAccessToken(param1:String) : QQConnectRequest
        {
            this.data["accessToken"] = param1;
            return this;
        }// end function

        public function setDoNotLinkToCurrentPlayer(param1:Boolean) : QQConnectRequest
        {
            this.data["doNotLinkToCurrentPlayer"] = param1;
            return this;
        }// end function

        public function setErrorOnSwitch(param1:Boolean) : QQConnectRequest
        {
            this.data["errorOnSwitch"] = param1;
            return this;
        }// end function

        public function setSegments(param1:Object) : QQConnectRequest
        {
            this.data["segments"] = param1;
            return this;
        }// end function

        public function setSwitchIfPossible(param1:Boolean) : QQConnectRequest
        {
            this.data["switchIfPossible"] = param1;
            return this;
        }// end function

        public function setSyncDisplayName(param1:Boolean) : QQConnectRequest
        {
            this.data["syncDisplayName"] = param1;
            return this;
        }// end function

    }
}
