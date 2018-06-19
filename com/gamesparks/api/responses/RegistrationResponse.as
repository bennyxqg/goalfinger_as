package com.gamesparks.api.responses
{
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class RegistrationResponse extends GSResponse
    {

        public function RegistrationResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getAuthToken() : String
        {
            if (data.authToken != null)
            {
                return data.authToken;
            }
            return null;
        }// end function

        public function getDisplayName() : String
        {
            if (data.displayName != null)
            {
                return data.displayName;
            }
            return null;
        }// end function

        public function getNewPlayer() : Boolean
        {
            if (data.newPlayer != null)
            {
                return data.newPlayer;
            }
            return false;
        }// end function

        public function getSwitchSummary() : Player
        {
            if (data.switchSummary != null)
            {
                return new Player(data.switchSummary);
            }
            return null;
        }// end function

        public function getUserId() : String
        {
            if (data.userId != null)
            {
                return data.userId;
            }
            return null;
        }// end function

    }
}
