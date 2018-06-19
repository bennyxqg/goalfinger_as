package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class GameCenterConnectRequest extends GSRequest
    {

        public function GameCenterConnectRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".GameCenterConnectRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : GameCenterConnectRequest
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

        public function setScriptData(param1:Object) : GameCenterConnectRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setDisplayName(param1:String) : GameCenterConnectRequest
        {
            this.data["displayName"] = param1;
            return this;
        }// end function

        public function setDoNotLinkToCurrentPlayer(param1:Boolean) : GameCenterConnectRequest
        {
            this.data["doNotLinkToCurrentPlayer"] = param1;
            return this;
        }// end function

        public function setErrorOnSwitch(param1:Boolean) : GameCenterConnectRequest
        {
            this.data["errorOnSwitch"] = param1;
            return this;
        }// end function

        public function setExternalPlayerId(param1:String) : GameCenterConnectRequest
        {
            this.data["externalPlayerId"] = param1;
            return this;
        }// end function

        public function setPublicKeyUrl(param1:String) : GameCenterConnectRequest
        {
            this.data["publicKeyUrl"] = param1;
            return this;
        }// end function

        public function setSalt(param1:String) : GameCenterConnectRequest
        {
            this.data["salt"] = param1;
            return this;
        }// end function

        public function setSegments(param1:Object) : GameCenterConnectRequest
        {
            this.data["segments"] = param1;
            return this;
        }// end function

        public function setSignature(param1:String) : GameCenterConnectRequest
        {
            this.data["signature"] = param1;
            return this;
        }// end function

        public function setSwitchIfPossible(param1:Boolean) : GameCenterConnectRequest
        {
            this.data["switchIfPossible"] = param1;
            return this;
        }// end function

        public function setSyncDisplayName(param1:Boolean) : GameCenterConnectRequest
        {
            this.data["syncDisplayName"] = param1;
            return this;
        }// end function

        public function setTimestamp(param1:Number) : GameCenterConnectRequest
        {
            this.data["timestamp"] = param1;
            return this;
        }// end function

    }
}
