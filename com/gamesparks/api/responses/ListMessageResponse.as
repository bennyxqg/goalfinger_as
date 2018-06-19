package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;

    public class ListMessageResponse extends GSResponse
    {

        public function ListMessageResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getMessageList() : Vector.<Object>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<Object>;
            if (data.messageList != null)
            {
                _loc_2 = data.messageList;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(_loc_2[_loc_3]);
                }
            }
            return _loc_1;
        }// end function

    }
}
