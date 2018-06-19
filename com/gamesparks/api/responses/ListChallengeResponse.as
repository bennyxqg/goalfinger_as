package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class ListChallengeResponse extends GSResponse
    {

        public function ListChallengeResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getChallengeInstances() : Vector.<Challenge>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<Challenge>;
            if (data.challengeInstances != null)
            {
                _loc_2 = data.challengeInstances;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new Challenge(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
