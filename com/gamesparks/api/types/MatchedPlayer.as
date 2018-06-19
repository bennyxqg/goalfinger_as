package com.gamesparks.api.types
{
    import com.gamesparks.*;

    public class MatchedPlayer extends GSData
    {

        public function MatchedPlayer(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getLocation() : Object
        {
            if (data.location != null)
            {
                return data.location;
            }
            return null;
        }// end function

        public function getParticipantData() : Object
        {
            if (data.participantData != null)
            {
                return data.participantData;
            }
            return null;
        }// end function

        public function getPlayerId() : String
        {
            if (data.playerId != null)
            {
                return data.playerId;
            }
            return null;
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
