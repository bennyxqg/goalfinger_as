package com.gamesparks.api.requests
{
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class MatchmakingRequest extends GSRequest
    {

        public function MatchmakingRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".MatchmakingRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : MatchmakingRequest
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
                    callback(new MatchmakingResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : MatchmakingRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setAction(param1:String) : MatchmakingRequest
        {
            this.data["action"] = param1;
            return this;
        }// end function

        public function setCustomQuery(param1:Object) : MatchmakingRequest
        {
            this.data["customQuery"] = param1;
            return this;
        }// end function

        public function setMatchData(param1:Object) : MatchmakingRequest
        {
            this.data["matchData"] = param1;
            return this;
        }// end function

        public function setMatchGroup(param1:String) : MatchmakingRequest
        {
            this.data["matchGroup"] = param1;
            return this;
        }// end function

        public function setMatchShortCode(param1:String) : MatchmakingRequest
        {
            this.data["matchShortCode"] = param1;
            return this;
        }// end function

        public function setParticipantData(param1:Object) : MatchmakingRequest
        {
            this.data["participantData"] = param1;
            return this;
        }// end function

        public function setSkill(param1:Number) : MatchmakingRequest
        {
            this.data["skill"] = param1;
            return this;
        }// end function

    }
}
