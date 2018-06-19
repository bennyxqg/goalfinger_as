package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class BuyVirtualGoodResponse extends GSResponse
    {

        public function BuyVirtualGoodResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getBoughtItems() : Vector.<Boughtitem>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<Boughtitem>;
            if (data.boughtItems != null)
            {
                _loc_2 = data.boughtItems;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(new Boughtitem(_loc_2[_loc_3]));
                }
            }
            return _loc_1;
        }// end function

        public function getCurrency1Added() : Number
        {
            if (data.currency1Added != null)
            {
                return data.currency1Added;
            }
            return NaN;
        }// end function

        public function getCurrency2Added() : Number
        {
            if (data.currency2Added != null)
            {
                return data.currency2Added;
            }
            return NaN;
        }// end function

        public function getCurrency3Added() : Number
        {
            if (data.currency3Added != null)
            {
                return data.currency3Added;
            }
            return NaN;
        }// end function

        public function getCurrency4Added() : Number
        {
            if (data.currency4Added != null)
            {
                return data.currency4Added;
            }
            return NaN;
        }// end function

        public function getCurrency5Added() : Number
        {
            if (data.currency5Added != null)
            {
                return data.currency5Added;
            }
            return NaN;
        }// end function

        public function getCurrency6Added() : Number
        {
            if (data.currency6Added != null)
            {
                return data.currency6Added;
            }
            return NaN;
        }// end function

        public function getCurrencyConsumed() : Number
        {
            if (data.currencyConsumed != null)
            {
                return data.currencyConsumed;
            }
            return NaN;
        }// end function

        public function getCurrencyType() : Number
        {
            if (data.currencyType != null)
            {
                return data.currencyType;
            }
            return NaN;
        }// end function

        public function getInvalidItems() : Vector.<String>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<String>;
            if (data.invalidItems != null)
            {
                _loc_2 = data.invalidItems;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(_loc_2[_loc_3]);
                }
            }
            return _loc_1;
        }// end function

        public function getTransactionIds() : Vector.<String>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<String>;
            if (data.transactionIds != null)
            {
                _loc_2 = data.transactionIds;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(_loc_2[_loc_3]);
                }
            }
            return _loc_1;
        }// end function

    }
}
