package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class GetMyTeamsResponse extends GSResponse
    {

        public function GetMyTeamsResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getTeams() : Vector.<Team>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<Team>;
            if (data.teams != null)
            {
                _loc_2 = data.teams;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new Team(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
