package com.gamesparks.api.requests
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.responses.*;

    public class CreateChallengeRequest extends GSRequest
    {

        public function CreateChallengeRequest(param1:GS)
        {
            super(param1);
            data["@class"] = ".CreateChallengeRequest";
            return;
        }// end function

        public function setTimeoutSeconds(param1:int = 10) : CreateChallengeRequest
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
                    callback(new CreateChallengeResponse(param1));
                }
                return;
            }// end function
            );
        }// end function

        public function setScriptData(param1:Object) : CreateChallengeRequest
        {
            data["scriptData"] = param1;
            return this;
        }// end function

        public function setAccessType(param1:String) : CreateChallengeRequest
        {
            this.data["accessType"] = param1;
            return this;
        }// end function

        public function setAutoStartJoinedChallengeOnMaxPlayers(param1:Boolean) : CreateChallengeRequest
        {
            this.data["autoStartJoinedChallengeOnMaxPlayers"] = param1;
            return this;
        }// end function

        public function setChallengeMessage(param1:String) : CreateChallengeRequest
        {
            this.data["challengeMessage"] = param1;
            return this;
        }// end function

        public function setChallengeShortCode(param1:String) : CreateChallengeRequest
        {
            this.data["challengeShortCode"] = param1;
            return this;
        }// end function

        public function setCurrency1Wager(param1:Number) : CreateChallengeRequest
        {
            this.data["currency1Wager"] = param1;
            return this;
        }// end function

        public function setCurrency2Wager(param1:Number) : CreateChallengeRequest
        {
            this.data["currency2Wager"] = param1;
            return this;
        }// end function

        public function setCurrency3Wager(param1:Number) : CreateChallengeRequest
        {
            this.data["currency3Wager"] = param1;
            return this;
        }// end function

        public function setCurrency4Wager(param1:Number) : CreateChallengeRequest
        {
            this.data["currency4Wager"] = param1;
            return this;
        }// end function

        public function setCurrency5Wager(param1:Number) : CreateChallengeRequest
        {
            this.data["currency5Wager"] = param1;
            return this;
        }// end function

        public function setCurrency6Wager(param1:Number) : CreateChallengeRequest
        {
            this.data["currency6Wager"] = param1;
            return this;
        }// end function

        public function setEligibilityCriteria(param1:Object) : CreateChallengeRequest
        {
            this.data["eligibilityCriteria"] = param1;
            return this;
        }// end function

        public function setEndTime(param1:Date) : CreateChallengeRequest
        {
            this.data["endTime"] = dateToRFC3339(param1);
            return this;
        }// end function

        public function setExpiryTime(param1:Date) : CreateChallengeRequest
        {
            this.data["expiryTime"] = dateToRFC3339(param1);
            return this;
        }// end function

        public function setMaxAttempts(param1:Number) : CreateChallengeRequest
        {
            this.data["maxAttempts"] = param1;
            return this;
        }// end function

        public function setMaxPlayers(param1:Number) : CreateChallengeRequest
        {
            this.data["maxPlayers"] = param1;
            return this;
        }// end function

        public function setMinPlayers(param1:Number) : CreateChallengeRequest
        {
            this.data["minPlayers"] = param1;
            return this;
        }// end function

        public function setSilent(param1:Boolean) : CreateChallengeRequest
        {
            this.data["silent"] = param1;
            return this;
        }// end function

        public function setStartTime(param1:Date) : CreateChallengeRequest
        {
            this.data["startTime"] = dateToRFC3339(param1);
            return this;
        }// end function

        public function setUsersToChallenge(param1:Vector.<String>) : CreateChallengeRequest
        {
            this.data["usersToChallenge"] = toArray(param1);
            return this;
        }// end function

    }
}
