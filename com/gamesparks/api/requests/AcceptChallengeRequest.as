package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class AcceptChallengeRequest extends GSRequest
    {

        public function AcceptChallengeRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".AcceptChallengeRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : AcceptChallengeRequest
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
                    callback(new AcceptChallengeResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : AcceptChallengeRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setChallengeInstanceId(param1:String) : AcceptChallengeRequest
        {
            this.data["challengeInstanceId"] = param1;
            return this;
        }// end function

        public function setMessage(param1:String) : AcceptChallengeRequest
        {
            this.data["message"] = param1;
            return this;
        }// end function

    }
}
