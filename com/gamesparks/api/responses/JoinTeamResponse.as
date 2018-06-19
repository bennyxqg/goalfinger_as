package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class JoinTeamResponse extends GSResponse
    {

        public function JoinTeamResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getMembers() : Vector.<Player>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<Player>;
            if (data.members != null)
            {
                _loc_2 = data.members;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new Player(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

        public function getOwner() : Player
        {
            if (data.owner != null)
            {
                return new Player(data.owner);
            }
            return null;
        }// end function

        public function getTeamId() : String
        {
            if (data.teamId != null)
            {
                return data.teamId;
            }
            return null;
        }// end function

        public function getTeamName() : String
        {
            if (data.teamName != null)
            {
                return data.teamName;
            }
            return null;
        }// end function

        public function getTeamType() : String
        {
            if (data.teamType != null)
            {
                return data.teamType;
            }
            return null;
        }// end function

    }
}
