package com.gamesparks.api.types
{
    import __AS3__.vec.*;
    import com.gamesparks.*;

    public class Challenge extends GSData
    {

        public function Challenge(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getAccepted() : Vector.<PlayerDetail>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<PlayerDetail>;
            if (data.accepted != null)
            {
                _loc_2 = data.accepted;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new PlayerDetail(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

        public function getChallengeId() : String
        {
            if (data.challengeId != null)
            {
                return data.challengeId;
            }
            return null;
        }// end function

        public function getChallengeMessage() : String
        {
            if (data.challengeMessage != null)
            {
                return data.challengeMessage;
            }
            return null;
        }// end function

        public function getChallengeName() : String
        {
            if (data.challengeName != null)
            {
                return data.challengeName;
            }
            return null;
        }// end function

        public function getChallenged() : Vector.<PlayerDetail>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<PlayerDetail>;
            if (data.challenged != null)
            {
                _loc_2 = data.challenged;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new PlayerDetail(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

        public function getChallenger() : PlayerDetail
        {
            if (data.challenger != null)
            {
                return new PlayerDetail(data.challenger);
            }
            return null;
        }// end function

        public function getCurrency1Wager() : Number
        {
            if (data.currency1Wager != null)
            {
                return data.currency1Wager;
            }
            return NaN;
        }// end function

        public function getCurrency2Wager() : Number
        {
            if (data.currency2Wager != null)
            {
                return data.currency2Wager;
            }
            return NaN;
        }// end function

        public function getCurrency3Wager() : Number
        {
            if (data.currency3Wager != null)
            {
                return data.currency3Wager;
            }
            return NaN;
        }// end function

        public function getCurrency4Wager() : Number
        {
            if (data.currency4Wager != null)
            {
                return data.currency4Wager;
            }
            return NaN;
        }// end function

        public function getCurrency5Wager() : Number
        {
            if (data.currency5Wager != null)
            {
                return data.currency5Wager;
            }
            return NaN;
        }// end function

        public function getCurrency6Wager() : Number
        {
            if (data.currency6Wager != null)
            {
                return data.currency6Wager;
            }
            return NaN;
        }// end function

        public function getDeclined() : Vector.<PlayerDetail>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<PlayerDetail>;
            if (data.declined != null)
            {
                _loc_2 = data.declined;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new PlayerDetail(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

        public function getEndDate() : Date
        {
            if (data.endDate != null)
            {
                return RFC3339toDate(data.endDate);
            }
            return null;
        }// end function

        public function getExpiryDate() : Date
        {
            if (data.expiryDate != null)
            {
                return RFC3339toDate(data.expiryDate);
            }
            return null;
        }// end function

        public function getMaxTurns() : Number
        {
            if (data.maxTurns != null)
            {
                return data.maxTurns;
            }
            return NaN;
        }// end function

        public function getNextPlayer() : String
        {
            if (data.nextPlayer != null)
            {
                return data.nextPlayer;
            }
            return null;
        }// end function

        public function getScriptData() : Object
        {
            if (data.scriptData != null)
            {
                return data.scriptData;
            }
            return null;
        }// end function

        public function getShortCode() : String
        {
            if (data.shortCode != null)
            {
                return data.shortCode;
            }
            return null;
        }// end function

        public function getStartDate() : Date
        {
            if (data.startDate != null)
            {
                return RFC3339toDate(data.startDate);
            }
            return null;
        }// end function

        public function getState() : String
        {
            if (data.state != null)
            {
                return data.state;
            }
            return null;
        }// end function

        public function getTurnCount() : Vector.<PlayerTurnCount>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<PlayerTurnCount>;
            if (data.turnCount != null)
            {
                _loc_2 = data.turnCount;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new PlayerTurnCount(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
