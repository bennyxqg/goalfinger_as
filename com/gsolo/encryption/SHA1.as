package com.gsolo.encryption
{

    public class SHA1 extends Object
    {
        public static const HEX_FORMAT_LOWERCASE:uint = 0;
        public static const HEX_FORMAT_UPPERCASE:uint = 1;
        public static const BASE64_PAD_CHARACTER_DEFAULT_COMPLIANCE:String = "";
        public static const BASE64_PAD_CHARACTER_RFC_COMPLIANCE:String = "=";
        public static const BITS_PER_CHAR_ASCII:uint = 8;
        public static const BITS_PER_CHAR_UNICODE:uint = 8;
        public static var hexcase:uint = 0;
        public static var b64pad:String = "";
        public static var chrsz:uint = 8;

        public function SHA1()
        {
            return;
        }// end function

        public static function encrypt(param1:String) : String
        {
            return hex_sha1(param1);
        }// end function

        public static function hex_sha1(param1:String) : String
        {
            return binb2hex(core_sha1(str2binb(param1), param1.length * chrsz));
        }// end function

        public static function b64_sha1(param1:String) : String
        {
            return binb2b64(core_sha1(str2binb(param1), param1.length * chrsz));
        }// end function

        public static function str_sha1(param1:String) : String
        {
            return binb2str(core_sha1(str2binb(param1), param1.length * chrsz));
        }// end function

        public static function hex_hmac_sha1(param1:String, param2:String) : String
        {
            return binb2hex(core_hmac_sha1(param1, param2));
        }// end function

        public static function b64_hmac_sha1(param1:String, param2:String) : String
        {
            return binb2b64(core_hmac_sha1(param1, param2));
        }// end function

        public static function str_hmac_sha1(param1:String, param2:String) : String
        {
            return binb2str(core_hmac_sha1(param1, param2));
        }// end function

        public static function sha1_vm_test() : Boolean
        {
            return hex_sha1("abc") == "a9993e364706816aba3e25717850c26c9cd0d89d";
        }// end function

        public static function core_sha1(param1:Array, param2:Number) : Array
        {
            var _loc_10:* = NaN;
            var _loc_11:* = NaN;
            var _loc_12:* = NaN;
            var _loc_13:* = NaN;
            var _loc_14:* = NaN;
            var _loc_15:* = NaN;
            var _loc_16:* = NaN;
            param1[param2 >> 5] = param1[param2 >> 5] | 128 << 24 - param2 % 32;
            param1[(param2 + 64 >> 9 << 4) + 15] = param2;
            var _loc_3:* = new Array(80);
            var _loc_4:* = 1732584193;
            var _loc_5:* = -271733879;
            var _loc_6:* = -1732584194;
            var _loc_7:* = 271733878;
            var _loc_8:* = -1009589776;
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
                        _loc_3[_loc_15] = param1[_loc_9 + _loc_15];
                    }
                    else
                    {
                        _loc_3[_loc_15] = rol(_loc_3[_loc_15 - 3] ^ _loc_3[_loc_15 - 8] ^ _loc_3[_loc_15 - 14] ^ _loc_3[_loc_15 - 16], 1);
                    }
                    _loc_16 = safe_add(safe_add(rol(_loc_4, 5), sha1_ft(_loc_15, _loc_5, _loc_6, _loc_7)), safe_add(safe_add(_loc_8, _loc_3[_loc_15]), sha1_kt(_loc_15)));
                    _loc_8 = _loc_7;
                    _loc_7 = _loc_6;
                    _loc_6 = rol(_loc_5, 30);
                    _loc_5 = _loc_4;
                    _loc_4 = _loc_16;
                    _loc_15 = _loc_15 + 1;
                }
                _loc_4 = safe_add(_loc_4, _loc_10);
                _loc_5 = safe_add(_loc_5, _loc_11);
                _loc_6 = safe_add(_loc_6, _loc_12);
                _loc_7 = safe_add(_loc_7, _loc_13);
                _loc_8 = safe_add(_loc_8, _loc_14);
                _loc_9 = _loc_9 + 16;
            }
            return [_loc_4, _loc_5, _loc_6, _loc_7, _loc_8];
        }// end function

        public static function sha1_ft(param1:Number, param2:Number, param3:Number, param4:Number) : Number
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

        public static function sha1_kt(param1:Number) : Number
        {
            return param1 < 20 ? (1518500249) : (param1 < 40 ? (1859775393) : (param1 < 60 ? (-1894007588) : (-899497514)));
        }// end function

        public static function core_hmac_sha1(param1:String, param2:String) : Array
        {
            var _loc_3:* = str2binb(param1);
            if (_loc_3.length > 16)
            {
                _loc_3 = core_sha1(_loc_3, param1.length * chrsz);
            }
            var _loc_4:* = new Array(16);
            var _loc_5:* = new Array(16);
            var _loc_6:* = 0;
            while (_loc_6 < 16)
            {
                
                _loc_4[_loc_6] = _loc_3[_loc_6] ^ 909522486;
                _loc_5[_loc_6] = _loc_3[_loc_6] ^ 1549556828;
                _loc_6 = _loc_6 + 1;
            }
            var _loc_7:* = core_sha1(_loc_4.concat(str2binb(param2)), 512 + param2.length * chrsz);
            return core_sha1(_loc_5.concat(_loc_7), 512 + 160);
        }// end function

        public static function safe_add(param1:Number, param2:Number) : Number
        {
            var _loc_3:* = (param1 & 65535) + (param2 & 65535);
            var _loc_4:* = (param1 >> 16) + (param2 >> 16) + (_loc_3 >> 16);
            return (param1 >> 16) + (param2 >> 16) + (_loc_3 >> 16) << 16 | _loc_3 & 65535;
        }// end function

        public static function rol(param1:Number, param2:Number) : Number
        {
            return param1 << param2 | param1 >>> 32 - param2;
        }// end function

        public static function str2binb(param1:String) : Array
        {
            var _loc_2:* = new Array();
            var _loc_3:* = (1 << chrsz) - 1;
            var _loc_4:* = 0;
            while (_loc_4 < param1.length * chrsz)
            {
                
                _loc_2[_loc_4 >> 5] = _loc_2[_loc_4 >> 5] | (param1.charCodeAt(_loc_4 / chrsz) & _loc_3) << 32 - chrsz - _loc_4 % 32;
                _loc_4 = _loc_4 + chrsz;
            }
            return _loc_2;
        }// end function

        public static function binb2str(param1:Array) : String
        {
            var _loc_2:* = "";
            var _loc_3:* = (1 << chrsz) - 1;
            var _loc_4:* = 0;
            while (_loc_4 < param1.length * 32)
            {
                
                _loc_2 = _loc_2 + String.fromCharCode(param1[_loc_4 >> 5] >>> 32 - chrsz - _loc_4 % 32 & _loc_3);
                _loc_4 = _loc_4 + chrsz;
            }
            return _loc_2;
        }// end function

        public static function binb2hex(param1:Array) : String
        {
            var _loc_2:* = hexcase ? ("0123456789ABCDEF") : ("0123456789abcdef");
            var _loc_3:* = "";
            var _loc_4:* = 0;
            while (_loc_4 < param1.length * 4)
            {
                
                _loc_3 = _loc_3 + (_loc_2.charAt(param1[_loc_4 >> 2] >> (3 - _loc_4 % 4) * 8 + 4 & 15) + _loc_2.charAt(param1[_loc_4 >> 2] >> (3 - _loc_4 % 4) * 8 & 15));
                _loc_4 = _loc_4 + 1;
            }
            return _loc_3;
        }// end function

        public static function binb2b64(param1:Array) : String
        {
            var _loc_5:* = NaN;
            var _loc_6:* = NaN;
            var _loc_2:* = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
            var _loc_3:* = "";
            var _loc_4:* = 0;
            while (_loc_4 < param1.length * 4)
            {
                
                _loc_5 = (param1[_loc_4 >> 2] >> 8 * (3 - _loc_4 % 4) & 255) << 16 | (param1[(_loc_4 + 1) >> 2] >> 8 * (3 - (_loc_4 + 1) % 4) & 255) << 8 | param1[_loc_4 + 2 >> 2] >> 8 * (3 - (_loc_4 + 2) % 4) & 255;
                _loc_6 = 0;
                while (_loc_6 < 4)
                {
                    
                    if (_loc_4 * 8 + _loc_6 * 6 > param1.length * 32)
                    {
                        _loc_3 = _loc_3 + b64pad;
                    }
                    else
                    {
                        _loc_3 = _loc_3 + _loc_2.charAt(_loc_5 >> 6 * (3 - _loc_6) & 63);
                    }
                    _loc_6 = _loc_6 + 1;
                }
                _loc_4 = _loc_4 + 3;
            }
            return _loc_3;
        }// end function

    }
}
