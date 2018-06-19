package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class ListMessageDetailResponse extends GSResponse
    {

        public function ListMessageDetailResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getMessageList() : Vector.<PlayerMessage>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<PlayerMessage>;
            if (data.messageList != null)
            {
                _loc_2 = data.messageList;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new PlayerMessage(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
