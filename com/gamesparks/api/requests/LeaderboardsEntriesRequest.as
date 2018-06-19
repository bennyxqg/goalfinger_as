package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class LeaderboardsEntriesRequest extends GSRequest
    {

        public function LeaderboardsEntriesRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".LeaderboardsEntriesRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : LeaderboardsEntriesRequest
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
                    callback(new LeaderboardsEntriesResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : LeaderboardsEntriesRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setChallenges(param1:Vector.<String>) : LeaderboardsEntriesRequest
        {
            this.data["challenges"] = toArray(param1);
            return this;
        }// end function

        public function setInverseSocial(param1:Boolean) : LeaderboardsEntriesRequest
        {
            this.data["inverseSocial"] = param1;
            return this;
        }// end function

        public function setLeaderboards(param1:Vector.<String>) : LeaderboardsEntriesRequest
        {
            this.data["leaderboards"] = toArray(param1);
            return this;
        }// end function

        public function setPlayer(param1:String) : LeaderboardsEntriesRequest
        {
            this.data["player"] = param1;
            return this;
        }// end function

        public function setSocial(param1:Boolean) : LeaderboardsEntriesRequest
        {
            this.data["social"] = param1;
            return this;
        }// end function

        public function setTeamTypes(param1:Vector.<String>) : LeaderboardsEntriesRequest
        {
            this.data["teamTypes"] = toArray(param1);
            return this;
        }// end function

    }
}
