package com.gamesparks.api.types
{
    import __AS3__.vec.*;
    import com.gamesparks.*;

    public class PlayerTransaction extends GSData
    {

        public function PlayerTransaction(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getItems() : Vector.<PlayerTransactionItem>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<PlayerTransactionItem>;
            if (data.items != null)
            {
                _loc_2 = data.items;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new PlayerTransactionItem(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

        public function getOriginalRequestId() : String
        {
            if (data.originalRequestId != null)
            {
                return data.originalRequestId;
            }
            return null;
        }// end function

        public function getPlayerId() : String
        {
            if (data.playerId != null)
            {
                return data.playerId;
            }
            return null;
        }// end function

        public function getReason() : String
        {
            if (data.reason != null)
            {
                return data.reason;
            }
            return null;
        }// end function

        public function getRevokeDate() : Date
        {
            if (data.revokeDate != null)
            {
                return RFC3339toDate(data.revokeDate);
            }
            return null;
        }// end function

        public function getRevoked() : Boolean
        {
            if (data.revoked != null)
            {
                return data.revoked;
            }
            return false;
        }// end function

        public function getScript() : String
        {
            if (data.script != null)
            {
                return data.script;
            }
            return null;
        }// end function

        public function getScriptType() : String
        {
            if (data.scriptType != null)
            {
                return data.scriptType;
            }
            return null;
        }// end function

        public function getTransactionId() : String
        {
            if (data.transactionId != null)
            {
                return data.transactionId;
            }
            return null;
        }// end function

        public function getWhen() : Date
        {
            if (data.when != null)
            {
                return RFC3339toDate(data.when);
            }
            return null;
        }// end function

    }
}
