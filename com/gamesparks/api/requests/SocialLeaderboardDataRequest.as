package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class SocialLeaderboardDataRequest extends GSRequest
    {

        public function SocialLeaderboardDataRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".SocialLeaderboardDataRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : SocialLeaderboardDataRequest
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
                    callback(new LeaderboardDataResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : SocialLeaderboardDataRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setChallengeInstanceId(param1:String) : SocialLeaderboardDataRequest
        {
            this.data["challengeInstanceId"] = param1;
            return this;
        }// end function

        public function setDontErrorOnNotSocial(param1:Boolean) : SocialLeaderboardDataRequest
        {
            this.data["dontErrorOnNotSocial"] = param1;
            return this;
        }// end function

        public function setEntryCount(param1:Number) : SocialLeaderboardDataRequest
        {
            this.data["entryCount"] = param1;
            return this;
        }// end function

        public function setFriendIds(param1:Vector.<String>) : SocialLeaderboardDataRequest
        {
            this.data["friendIds"] = toArray(param1);
            return this;
        }// end function

        public function setIncludeFirst(param1:Number) : SocialLeaderboardDataRequest
        {
            this.data["includeFirst"] = param1;
            return this;
        }// end function

        public function setIncludeLast(param1:Number) : SocialLeaderboardDataRequest
        {
            this.data["includeLast"] = param1;
            return this;
        }// end function

        public function setInverseSocial(param1:Boolean) : SocialLeaderboardDataRequest
        {
            this.data["inverseSocial"] = param1;
            return this;
        }// end function

        public function setLeaderboardShortCode(param1:String) : SocialLeaderboardDataRequest
        {
            this.data["leaderboardShortCode"] = param1;
            return this;
        }// end function

        public function setOffset(param1:Number) : SocialLeaderboardDataRequest
        {
            this.data["offset"] = param1;
            return this;
        }// end function

        public function setSocial(param1:Boolean) : SocialLeaderboardDataRequest
        {
            this.data["social"] = param1;
            return this;
        }// end function

        public function setTeamIds(param1:Vector.<String>) : SocialLeaderboardDataRequest
        {
            this.data["teamIds"] = toArray(param1);
            return this;
        }// end function

        public function setTeamTypes(param1:Vector.<String>) : SocialLeaderboardDataRequest
        {
            this.data["teamTypes"] = toArray(param1);
            return this;
        }// end function

    }
}
