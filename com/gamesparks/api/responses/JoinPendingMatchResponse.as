package com.gamesparks.api.responses
{
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class JoinPendingMatchResponse extends GSResponse
    {

        public function JoinPendingMatchResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getPendingMatch() : PendingMatch
        {
            if (data.pendingMatch != null)
            {
                return new PendingMatch(data.pendingMatch);
            }
            return null;
        }// end function

    }
}
