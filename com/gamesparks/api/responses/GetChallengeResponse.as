package com.gamesparks.api.responses
{
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class GetChallengeResponse extends GSResponse
    {

        public function GetChallengeResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getChallenge() : Challenge
        {
            if (data.challenge != null)
            {
                return new Challenge(data.challenge);
            }
            return null;
        }// end function

    }
}
