package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class ListAchievementsResponse extends GSResponse
    {

        public function ListAchievementsResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getAchievements() : Vector.<Achievement>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<Achievement>;
            if (data.achievements != null)
            {
                _loc_2 = data.achievements;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new Achievement(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
