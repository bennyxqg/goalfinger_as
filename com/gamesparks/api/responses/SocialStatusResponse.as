package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class SocialStatusResponse extends GSResponse
    {

        public function SocialStatusResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getStatuses() : Vector.<SocialStatus>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<SocialStatus>;
            if (data.statuses != null)
            {
                _loc_2 = data.statuses;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new SocialStatus(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
