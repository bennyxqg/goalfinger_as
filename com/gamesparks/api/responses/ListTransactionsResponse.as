package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class ListTransactionsResponse extends GSResponse
    {

        public function ListTransactionsResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getTransactionList() : Vector.<PlayerTransaction>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<PlayerTransaction>;
            if (data.transactionList != null)
            {
                _loc_2 = data.transactionList;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new PlayerTransaction(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

    }
}
