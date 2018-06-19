package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class MatchDetailsResponse extends GSResponse
    {

        public function MatchDetailsResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getAccessToken() : String
        {
            if (data.accessToken != null)
            {
                return data.accessToken;
            }
            return null;
        }// end function

        public function getHost() : String
        {
            if (data.host != null)
            {
                return data.host;
            }
            return null;
        }// end function

        public function getMatchData() : Object
        {
            if (data.matchData != null)
            {
                return data.matchData;
            }
            return null;
        }// end function

        public function getMatchId() : String
        {
            if (data.matchId != null)
            {
                return data.matchId;
            }
            return null;
        }// end function

        public function getOpponents() : Vector.<Player>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<Player>;
            if (data.opponents != null)
            {
                _loc_2 = data.opponents;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new Player(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

        public function getPeerId() : Number
        {
            if (data.peerId != null)
            {
                return data.peerId;
            }
            return NaN;
        }// end function

        public function getPlayerId() : String
        {
            if (data.playerId != null)
            {
                return data.playerId;
            }
            return null;
        }// end function

        public function getPort() : Number
        {
            if (data.port != null)
            {
                return data.port;
            }
            return NaN;
        }// end function

    }
}
