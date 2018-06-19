package com.hurlant.util
{
    import flash.utils.*;

    public class ArrayUtil extends Object
    {

        public function ArrayUtil()
        {
            return;
        }// end function

        public static function equals(param1:ByteArray, param2:ByteArray) : Boolean
        {
            if (param1.length != param2.length)
            {
                return false;
            }
            var _loc_3:* = param1.length;
            var _loc_4:* = 0;
            while (_loc_4 < _loc_3)
            {
                
                if (param1[_loc_4] != param2[_loc_4])
                {
                    return false;
                }
                _loc_4++;
            }
            return true;
        }// end function

    }
}
