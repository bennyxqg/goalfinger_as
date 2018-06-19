package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class SendTeamChatMessageRequest extends GSRequest
    {

        public function SendTeamChatMessageRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".SendTeamChatMessageRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : SendTeamChatMessageRequest
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
                    callback(new SendTeamChatMessageResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : SendTeamChatMessageRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setMessage(param1:String) : SendTeamChatMessageRequest
        {
            this.data["message"] = param1;
            return this;
        }// end function

        public function setOwnerId(param1:String) : SendTeamChatMessageRequest
        {
            this.data["ownerId"] = param1;
            return this;
        }// end function

        public function setTeamId(param1:String) : SendTeamChatMessageRequest
        {
            this.data["teamId"] = param1;
            return this;
        }// end function

        public function setTeamType(param1:String) : SendTeamChatMessageRequest
        {
            this.data["teamType"] = param1;
            return this;
        }// end function

    }
}
