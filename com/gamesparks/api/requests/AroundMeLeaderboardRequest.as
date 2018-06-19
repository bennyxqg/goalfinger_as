package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class AroundMeLeaderboardRequest extends GSRequest
    {

        public function AroundMeLeaderboardRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".AroundMeLeaderboardRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : AroundMeLeaderboardRequest
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
                    callback(new AroundMeLeaderboardResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : AroundMeLeaderboardRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setChallengeInstanceId(param1:String) : AroundMeLeaderboardRequest
        {
            this.data["challengeInstanceId"] = param1;
            return this;
        }// end function

        public function setCustomIdFilter(param1:Object) : AroundMeLeaderboardRequest
        {
            this.data["customIdFilter"] = param1;
            return this;
        }// end function

        public function setDontErrorOnNotSocial(param1:Boolean) : AroundMeLeaderboardRequest
        {
            this.data["dontErrorOnNotSocial"] = param1;
            return this;
        }// end function

        public function setEntryCount(param1:Number) : AroundMeLeaderboardRequest
        {
            this.data["entryCount"] = param1;
            return this;
        }// end function

        public function setFriendIds(param1:Vector.<String>) : AroundMeLeaderboardRequest
        {
            this.data["friendIds"] = toArray(param1);
            return this;
        }// end function

        public function setIncludeFirst(param1:Number) : AroundMeLeaderboardRequest
        {
            this.data["includeFirst"] = param1;
            return this;
        }// end function

        public function setIncludeLast(param1:Number) : AroundMeLeaderboardRequest
        {
            this.data["includeLast"] = param1;
            return this;
        }// end function

        public function setInverseSocial(param1:Boolean) : AroundMeLeaderboardRequest
        {
            this.data["inverseSocial"] = param1;
            return this;
        }// end function

        public function setLeaderboardShortCode(param1:String) : AroundMeLeaderboardRequest
        {
            this.data["leaderboardShortCode"] = param1;
            return this;
        }// end function

        public function setSocial(param1:Boolean) : AroundMeLeaderboardRequest
        {
            this.data["social"] = param1;
            return this;
        }// end function

        public function setTeamIds(param1:Vector.<String>) : AroundMeLeaderboardRequest
        {
            this.data["teamIds"] = toArray(param1);
            return this;
        }// end function

        public function setTeamTypes(param1:Vector.<String>) : AroundMeLeaderboardRequest
        {
            this.data["teamTypes"] = toArray(param1);
            return this;
        }// end function

    }
}
