package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class AcceptChallengeResponse extends GSResponse
    {

        public function AcceptChallengeResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getChallengeInstanceId() : String
        {
            if (data.challengeInstanceId != null)
            {
                return data.challengeInstanceId;
            }
            return null;
        }// end function

    }
}
