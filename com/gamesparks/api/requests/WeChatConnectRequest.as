package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class WeChatConnectRequest extends GSRequest
    {

        public function WeChatConnectRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".WeChatConnectRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : WeChatConnectRequest
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

        public function setScriptData(param1:Object) : WeChatConnectRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setAccessToken(param1:String) : WeChatConnectRequest
        {
            this.data["accessToken"] = param1;
            return this;
        }// end function

        public function setDoNotLinkToCurrentPlayer(param1:Boolean) : WeChatConnectRequest
        {
            this.data["doNotLinkToCurrentPlayer"] = param1;
            return this;
        }// end function

        public function setErrorOnSwitch(param1:Boolean) : WeChatConnectRequest
        {
            this.data["errorOnSwitch"] = param1;
            return this;
        }// end function

        public function setOpenId(param1:String) : WeChatConnectRequest
        {
            this.data["openId"] = param1;
            return this;
        }// end function

        public function setSegments(param1:Object) : WeChatConnectRequest
        {
            this.data["segments"] = param1;
            return this;
        }// end function

        public function setSwitchIfPossible(param1:Boolean) : WeChatConnectRequest
        {
            this.data["switchIfPossible"] = param1;
            return this;
        }// end function

        public function setSyncDisplayName(param1:Boolean) : WeChatConnectRequest
        {
            this.data["syncDisplayName"] = param1;
            return this;
        }// end function

    }
}
