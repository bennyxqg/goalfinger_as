package com.gamesparks.api.types
{
    import __AS3__.vec.*;
    import com.gamesparks.*;

    public class PendingMatch extends GSData
    {

        public function PendingMatch(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getId() : String
        {
            if (data.id != null)
            {
                return data.id;
            }
            return null;
        }// end function

        public function getMatchData() : Object
        {
            if (data.matchData != null)
            {
                return data.matchData;
            }
            return null;
        }// end function

        public function getMatchGroup() : String
        {
            if (data.matchGroup != null)
            {
                return data.matchGroup;
            }
            return null;
        }// end function

        public function getMatchShortCode() : String
        {
            if (data.matchShortCode != null)
            {
                return data.matchShortCode;
            }
            return null;
        }// end function

        public function getMatchedPlayers() : Vector.<MatchedPlayer>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<MatchedPlayer>;
            if (data.matchedPlayers != null)
            {
                _loc_2 = data.matchedPlayers;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new MatchedPlayer(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

        public function getSkill() : Number
        {
            if (data.skill != null)
            {
                return data.skill;
            }
            return NaN;
        }// end function

    }
}
