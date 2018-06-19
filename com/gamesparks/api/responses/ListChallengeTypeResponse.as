package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class ListChallengeTypeResponse extends GSResponse
    {

        public function ListChallengeTypeResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getChallengeTemplates() : Vector.<ChallengeType>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<ChallengeType>;
            if (data.challengeTemplates != null)
            {
                _loc_2 = data.challengeTemplates;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new ChallengeType(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
