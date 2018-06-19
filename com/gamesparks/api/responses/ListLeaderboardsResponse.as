package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class ListLeaderboardsResponse extends GSResponse
    {

        public function ListLeaderboardsResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getLeaderboards() : Vector.<Leaderboard>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<Leaderboard>;
            if (data.leaderboards != null)
            {
                _loc_2 = data.leaderboards;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new Leaderboard(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
