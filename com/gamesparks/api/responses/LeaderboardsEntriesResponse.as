package com.gamesparks.api.responses
{
    import com.gamesparks.*;

    public class LeaderboardsEntriesResponse extends GSResponse
    {

        public function LeaderboardsEntriesResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getResults() : Object
        {
            if (data.results != null)
            {
                return data.results;
            }
            return null;
        }// end function

    }
}
