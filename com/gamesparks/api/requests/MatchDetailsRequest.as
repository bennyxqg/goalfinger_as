package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class MatchDetailsRequest extends GSRequest
    {

        public function MatchDetailsRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".MatchDetailsRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : MatchDetailsRequest
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
                    callback(new MatchDetailsResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : MatchDetailsRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setMatchId(param1:String) : MatchDetailsRequest
        {
            this.data["matchId"] = param1;
            return this;
        }// end function

        public function setRealtimeEnabled(param1:Boolean) : MatchDetailsRequest
        {
            this.data["realtimeEnabled"] = param1;
            return this;
        }// end function

    }
}
