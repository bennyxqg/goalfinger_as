package com.gamesparks.api.types
{
    import __AS3__.vec.*;
    import com.gamesparks.*;

    public class LeaderboardRankDetails extends GSData
    {

        public function LeaderboardRankDetails(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getFriendsPassed() : Vector.<LeaderboardData>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<LeaderboardData>;
            if (data.friendsPassed != null)
            {
                _loc_2 = data.friendsPassed;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new LeaderboardData(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

        public function getGlobalCount() : Number
        {
            if (data.globalCount != null)
            {
                return data.globalCount;
            }
            return NaN;
        }// end function

        public function getGlobalFrom() : Number
        {
            if (data.globalFrom != null)
            {
                return data.globalFrom;
            }
            return NaN;
        }// end function

        public function getGlobalFromPercent() : Number
        {
            if (data.globalFromPercent != null)
            {
                return data.globalFromPercent;
            }
            return NaN;
        }// end function

        public function getGlobalTo() : Number
        {
            if (data.globalTo != null)
            {
                return data.globalTo;
            }
            return NaN;
        }// end function

        public function getGlobalToPercent() : Number
        {
            if (data.globalToPercent != null)
            {
                return data.globalToPercent;
            }
            return NaN;
        }// end function

        public function getSocialCount() : Number
        {
            if (data.socialCount != null)
            {
                return data.socialCount;
            }
            return NaN;
        }// end function

        public function getSocialFrom() : Number
        {
            if (data.socialFrom != null)
            {
                return data.socialFrom;
            }
            return NaN;
        }// end function

        public function getSocialFromPercent() : Number
        {
            if (data.socialFromPercent != null)
            {
                return data.socialFromPercent;
            }
            return NaN;
        }// end function

        public function getSocialTo() : Number
        {
            if (data.socialTo != null)
            {
                return data.socialTo;
            }
            return NaN;
        }// end function

        public function getSocialToPercent() : Number
        {
            if (data.socialToPercent != null)
            {
                return data.socialToPercent;
            }
            return NaN;
        }// end function

        public function getTopNPassed() : Vector.<LeaderboardData>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<LeaderboardData>;
            if (data.topNPassed != null)
            {
                _loc_2 = data.topNPassed;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new LeaderboardData(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
