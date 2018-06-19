package com.gamesparks.api.types
{
    import com.gamesparks.*;

    public class PlayerTurnCount extends GSData
    {

        public function PlayerTurnCount(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getCount() : String
        {
            if (data.count != null)
            {
                return data.count;
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

    }
}
