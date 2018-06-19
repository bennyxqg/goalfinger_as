package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class JoinChallengeResponse extends GSResponse
    {

        public function JoinChallengeResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getJoined() : Boolean
        {
            if (data.joined != null)
            {
                return data.joined;
            }
            return false;
        }// end function

    }
}
