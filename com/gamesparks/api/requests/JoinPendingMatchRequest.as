package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class JoinPendingMatchRequest extends GSRequest
    {

        public function JoinPendingMatchRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".JoinPendingMatchRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : JoinPendingMatchRequest
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
                    callback(new JoinPendingMatchResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : JoinPendingMatchRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setMatchGroup(param1:String) : JoinPendingMatchRequest
        {
            this.data["matchGroup"] = param1;
            return this;
        }// end function

        public function setMatchShortCode(param1:String) : JoinPendingMatchRequest
        {
            this.data["matchShortCode"] = param1;
            return this;
        }// end function

        public function setPendingMatchId(param1:String) : JoinPendingMatchRequest
        {
            this.data["pendingMatchId"] = param1;
            return this;
        }// end function

    }
}
