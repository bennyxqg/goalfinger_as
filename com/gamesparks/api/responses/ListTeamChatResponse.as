package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class ListTeamChatResponse extends GSResponse
    {

        public function ListTeamChatResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getMessages() : Vector.<ChatMessage>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<ChatMessage>;
            if (data.messages != null)
            {
                _loc_2 = data.messages;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new ChatMessage(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
