package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class ChatOnChallengeRequest extends GSRequest
    {

        public function ChatOnChallengeRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".ChatOnChallengeRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : ChatOnChallengeRequest
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
                    callback(new ChatOnChallengeResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : ChatOnChallengeRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setChallengeInstanceId(param1:String) : ChatOnChallengeRequest
        {
            this.data["challengeInstanceId"] = param1;
            return this;
        }// end function

        public function setMessage(param1:String) : ChatOnChallengeRequest
        {
            this.data["message"] = param1;
            return this;
        }// end function

    }
}
