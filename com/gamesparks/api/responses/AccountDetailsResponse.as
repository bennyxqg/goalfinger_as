package com.gamesparks.api.responses
{
    import __AS3__.vec.*;
    import com.gamesparks.*;
    import com.gamesparks.api.types.*;

    public class AccountDetailsResponse extends GSResponse
    {

        public function AccountDetailsResponse(param1:Object)
        {
            super(param1);
            return;
        }// end function

        public function getAchievements() : Vector.<String>
        {
            var _loc_2:* = null;
            var _loc_3:* = null;
            var _loc_1:* = new Vector.<String>;
            if (data.achievements != null)
            {
                _loc_2 = data.achievements;
                for (_loc_3 in _loc_2)
                {
                    
                    _loc_1.push(_loc_2[_loc_3]);
                }
            }
            return _loc_1;
        }// end function

        public function getCurrency1() : Number
        {
            if (data.currency1 != null)
            {
                return data.currency1;
            }
            return NaN;
        }// end function

        public function getCurrency2() : Number
        {
            if (data.currency2 != null)
            {
                return data.currency2;
            }
            return NaN;
        }// end function

        public function getCurrency3() : Number
        {
            if (data.currency3 != null)
            {
                return data.currency3;
            }
            return NaN;
        }// end function

        public function getCurrency4() : Number
        {
            if (data.currency4 != null)
            {
                return data.currency4;
            }
            return NaN;
        }// end function

        public function getCurrency5() : Number
        {
            if (data.currency5 != null)
            {
                return data.currency5;
            }
            return NaN;
        }// end function

        public function getCurrency6() : Number
        {
            if (data.currency6 != null)
            {
                return data.currency6;
            }
            return NaN;
        }// end function

        public function getDisplayName() : String
        {
            if (data.displayName != null)
            {
                return data.displayName;
            }
            return null;
        }// end function

        public function getExternalIds() : Object
        {
            if (data.externalIds != null)
            {
                return data.externalIds;
            }
            return null;
        }// end function

        public function getLocation() : Location
        {
            if (data.location != null)
            {
                return new Location(data.location);
            }
            return null;
        }// end function

        public function getReservedCurrency1() : Object
        {
            if (data.reservedCurrency1 != null)
            {
                return data.reservedCurrency1;
            }
            return null;
        }// end function

        public function getReservedCurrency2() : Object
        {
            if (data.reservedCurrency2 != null)
            {
                return data.reservedCurrency2;
            }
            return null;
        }// end function

        public function getReservedCurrency3() : Object
        {
            if (data.reservedCurrency3 != null)
            {
                return data.reservedCurrency3;
            }
            return null;
        }// end function

        public function getReservedCurrency4() : Object
        {
            if (data.reservedCurrency4 != null)
            {
                return data.reservedCurrency4;
            }
            return null;
        }// end function

        public function getReservedCurrency5() : Object
        {
            if (data.reservedCurrency5 != null)
            {
                return data.reservedCurrency5;
            }
            return null;
        }// end function

        public function getReservedCurrency6() : Object
        {
            if (data.reservedCurrency6 != null)
            {
                return data.reservedCurrency6;
            }
            return null;
        }// end function

        public function getUserId() : String
        {
            if (data.userId != null)
            {
                return data.userId;
            }
            return null;
        }// end function

        public function getVirtualGoods() : Object
        {
            if (data.virtualGoods != null)
            {
                return data.virtualGoods;
            }
            return null;
        }// end function

    }
}
