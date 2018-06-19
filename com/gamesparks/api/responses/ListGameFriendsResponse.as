package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class ListGameFriendsResponse extends GSResponse
    {

        public function ListGameFriendsResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getFriends() : Vector.<Player>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<Player>;
            if (data.friends != null)
            {
                _loc_2 = data.friends;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new Player(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
