package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class FindChallengeRequest extends GSRequest
    {

        public function FindChallengeRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".FindChallengeRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : FindChallengeRequest
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
                    callback(new FindChallengeResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : FindChallengeRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setAccessType(param1:String) : FindChallengeRequest
        {
            this.data["accessType"] = param1;
            return this;
        }// end function

        public function setCount(param1:Number) : FindChallengeRequest
        {
            this.data["count"] = param1;
            return this;
        }// end function

        public function setEligibility(param1:Object) : FindChallengeRequest
        {
            this.data["eligibility"] = param1;
            return this;
        }// end function

        public function setOffset(param1:Number) : FindChallengeRequest
        {
            this.data["offset"] = param1;
            return this;
        }// end function

        public function setShortCode(param1:Vector.<String>) : FindChallengeRequest
        {
            this.data["shortCode"] = toArray(param1);
            return this;
        }// end function

    }
}
