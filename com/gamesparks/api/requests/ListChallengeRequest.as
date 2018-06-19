package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class ListChallengeRequest extends GSRequest
    {

        public function ListChallengeRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".ListChallengeRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : ListChallengeRequest
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
                    callback(new ListChallengeResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : ListChallengeRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setEntryCount(param1:Number) : ListChallengeRequest
        {
            this.data["entryCount"] = param1;
            return this;
        }// end function

        public function setOffset(param1:Number) : ListChallengeRequest
        {
            this.data["offset"] = param1;
            return this;
        }// end function

        public function setShortCode(param1:String) : ListChallengeRequest
        {
            this.data["shortCode"] = param1;
            return this;
        }// end function

        public function setState(param1:String) : ListChallengeRequest
        {
            this.data["state"] = param1;
            return this;
        }// end function

        public function setStates(param1:Vector.<String>) : ListChallengeRequest
        {
            this.data["states"] = toArray(param1);
            return this;
        }// end function

    }
}
