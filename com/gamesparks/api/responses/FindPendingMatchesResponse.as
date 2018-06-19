package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class FindPendingMatchesResponse extends GSResponse
    {

        public function FindPendingMatchesResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getPendingMatches() : Vector.<PendingMatch>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<PendingMatch>;
            if (data.pendingMatches != null)
            {
                _loc_2 = data.pendingMatches;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new PendingMatch(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
