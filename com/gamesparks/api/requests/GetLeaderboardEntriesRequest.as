package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class GetLeaderboardEntriesRequest extends GSRequest
    {

        public function GetLeaderboardEntriesRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".GetLeaderboardEntriesRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : GetLeaderboardEntriesRequest
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
                    callback(new GetLeaderboardEntriesResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : GetLeaderboardEntriesRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setChallenges(param1:Vector.<String>) : GetLeaderboardEntriesRequest
        {
            this.data["challenges"] = toArray(param1);
            return this;
        }// end function

        public function setInverseSocial(param1:Boolean) : GetLeaderboardEntriesRequest
        {
            this.data["inverseSocial"] = param1;
            return this;
        }// end function

        public function setLeaderboards(param1:Vector.<String>) : GetLeaderboardEntriesRequest
        {
            this.data["leaderboards"] = toArray(param1);
            return this;
        }// end function

        public function setPlayer(param1:String) : GetLeaderboardEntriesRequest
        {
            this.data["player"] = param1;
            return this;
        }// end function

        public function setSocial(param1:Boolean) : GetLeaderboardEntriesRequest
        {
            this.data["social"] = param1;
            return this;
        }// end function

        public function setTeamTypes(param1:Vector.<String>) : GetLeaderboardEntriesRequest
        {
            this.data["teamTypes"] = toArray(param1);
            return this;
        }// end function

    }
}
