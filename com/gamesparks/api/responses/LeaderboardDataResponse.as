package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class LeaderboardDataResponse extends GSResponse
    {

        public function LeaderboardDataResponse(param1:Object)
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

        public function getData() : Vector.<LeaderboardData>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<LeaderboardData>;
            if (data.data != null)
            {
                _loc_2 = data.data;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new LeaderboardData(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

        public function getFirst() : Vector.<LeaderboardData>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<LeaderboardData>;
            if (data.first != null)
            {
                _loc_2 = data.first;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new LeaderboardData(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

        public function getLast() : Vector.<LeaderboardData>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<LeaderboardData>;
            if (data.last != null)
            {
                _loc_2 = data.last;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new LeaderboardData(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

        public function getLeaderboardShortCode() : String
        {
            if (data.leaderboardShortCode != null)
            {
                return data.leaderboardShortCode;
            }
            return null;
        }// end function

    }
}
