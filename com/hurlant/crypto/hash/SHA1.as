package com.hurlant.crypto.hash
{
    import com.hurlant.crypto.hash.*;

    public class SHA1 extends SHABase implements IHash
    {
        public static const HASH_SIZE:int = 20;

        public function SHA1()
        {
            return;
        }// end function

        override public function getHashSize() : uint
        {
            return HASH_SIZE;
        }// end function

        override protected function core(param1:Array, param2:uint) : Array
        {
            var _loc_10:* = 0;
            var _loc_11:* = 0;
            var _loc_12:* = 0;
            var _loc_13:* = 0;
            var _loc_14:* = 0;
            var _loc_15:* = 0;
            var _loc_16:* = 0;
            param1[param2 >> 5] = param1[param2 >> 5] | 128 << 24 - param2 % 32;
            param1[(param2 + 64 >> 9 << 4) + 15] = param2;
            var _loc_3:* = [];
            var _loc_4:* = 1732584193;
            var _loc_5:* = 4023233417;
            var _loc_6:* = 2562383102;
            var _loc_7:* = 271733878;
            var _loc_8:* = 3285377520;
            var _loc_9:* = 0;
            while (_loc_9 < param1.length)
            {
                
                _loc_10 = _loc_4;
                _loc_11 = _loc_5;
                _loc_12 = _loc_6;
                _loc_13 = _loc_7;
                _loc_14 = _loc_8;
                _loc_15 = 0;
                while (_loc_15 < 80)
                {
                    
                    if (_loc_15 < 16)
                    {
                        _loc_3[_loc_15] = param1[_loc_9 + _loc_15] || 0;
                    }
                    else
                    {
                        _loc_3[_loc_15] = this.rol(_loc_3[_loc_15 - 3] ^ _loc_3[_loc_15 - 8] ^ _loc_3[_loc_15 - 14] ^ _loc_3[_loc_15 - 16], 1);
                    }
                    _loc_16 = this.rol(_loc_4, 5) + this.ft(_loc_15, _loc_5, _loc_6, _loc_7) + _loc_8 + _loc_3[_loc_15] + this.kt(_loc_15);
                    _loc_8 = _loc_7;
                    _loc_7 = _loc_6;
                    _loc_6 = this.rol(_loc_5, 30);
                    _loc_5 = _loc_4;
                    _loc_4 = _loc_16;
                    _loc_15 = _loc_15 + 1;
                }
                _loc_4 = _loc_4 + _loc_10;
                _loc_5 = _loc_5 + _loc_11;
                _loc_6 = _loc_6 + _loc_12;
                _loc_7 = _loc_7 + _loc_13;
                _loc_8 = _loc_8 + _loc_14;
                _loc_9 = _loc_9 + 16;
            }
            return [_loc_4, _loc_5, _loc_6, _loc_7, _loc_8];
        }// end function

        private function rol(param1:uint, param2:uint) : uint
        {
            return param1 << param2 | param1 >>> 32 - param2;
        }// end function

        private function ft(param1:uint, param2:uint, param3:uint, param4:uint) : uint
        {
            if (param1 < 20)
            {
                return param2 & param3 | ~param2 & param4;
            }
            if (param1 < 40)
            {
                return param2 ^ param3 ^ param4;
            }
            if (param1 < 60)
            {
                return param2 & param3 | param2 & param4 | param3 & param4;
            }
            return param2 ^ param3 ^ param4;
        }// end function

        private function kt(param1:uint) : uint
        {
            return param1 < 20 ? (1518500249) : (param1 < 40 ? (1859775393) : (param1 < 60 ? (2400959708) : (3395469782)));
        }// end function

        override public function toString() : String
        {
            return "sha1";
        }// end function

    }
}
