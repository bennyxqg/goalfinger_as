package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class WithdrawChallengeRequest extends GSRequest
    {

        public function WithdrawChallengeRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".WithdrawChallengeRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : WithdrawChallengeRequest
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
                    callback(new WithdrawChallengeResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : WithdrawChallengeRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setChallengeInstanceId(param1:String) : WithdrawChallengeRequest
        {
            this.data["challengeInstanceId"] = param1;
            return this;
        }// end function

        public function setMessage(param1:String) : WithdrawChallengeRequest
        {
            this.data["message"] = param1;
            return this;
        }// end function

    }
}
