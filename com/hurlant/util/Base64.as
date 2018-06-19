package com.hurlant.util
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class Base64 extends Object
    {
        private static const _encodeChars:Vector.<int> = InitEncoreChar();
        private static const _decodeChars:Vector.<int> = InitDecodeChar();

        public function Base64()
        {
            return;
        }// end function

        public static function encodeByteArray(param1:ByteArray) : String
        {
            var _loc_6:* = 0;
            var _loc_2:* = new ByteArray();
            _loc_2.length = (2 + param1.length - (param1.length + 2) % 3) * 4 / 3;
            var _loc_3:* = 0;
            var _loc_4:* = param1.length % 3;
            var _loc_5:* = param1.length - _loc_4;
            while (_loc_3 < _loc_5)
            {
                
                _loc_6 = param1[_loc_3++] << 16 | param1[_loc_3++] << 8 | param1[_loc_3++];
                _loc_6 = _encodeChars[_loc_6 >>> 18] << 24 | _encodeChars[_loc_6 >>> 12 & 63] << 16 | _encodeChars[_loc_6 >>> 6 & 63] << 8 | _encodeChars[_loc_6 & 63];
                _loc_2.writeInt(_loc_6);
            }
            if (_loc_4 == 1)
            {
                _loc_6 = param1[_loc_3];
                _loc_6 = _encodeChars[_loc_6 >>> 2] << 24 | _encodeChars[(_loc_6 & 3) << 4] << 16 | 61 << 8 | 61;
                _loc_2.writeInt(_loc_6);
            }
            else if (_loc_4 == 2)
            {
                _loc_6 = param1[_loc_3++] << 8 | param1[_loc_3];
                _loc_6 = _encodeChars[_loc_6 >>> 10] << 24 | _encodeChars[_loc_6 >>> 4 & 63] << 16 | _encodeChars[(_loc_6 & 15) << 2] << 8 | 61;
                _loc_2.writeInt(_loc_6);
            }
            _loc_2.position = 0;
            return _loc_2.readUTFBytes(_loc_2.length);
        }// end function

        public static function decodeToByteArray(param1:String) : ByteArray
        {
            var _loc_2:* = 0;
            var _loc_3:* = 0;
            var _loc_4:* = 0;
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_8:* = null;
            _loc_7 = param1.length;
            _loc_6 = 0;
            _loc_8 = new ByteArray();
            var _loc_9:* = new ByteArray();
            _loc_8.writeUTFBytes(param1);
            while (_loc_6 < _loc_7)
            {
                
                do
                {
                    
                    _loc_2 = _decodeChars[_loc_9[_loc_6++]];
                }while (_loc_6 < _loc_7 && _loc_2 == -1)
                if (_loc_2 == -1)
                {
                    break;
                }
                do
                {
                    
                    _loc_3 = _decodeChars[_loc_9[_loc_6++]];
                }while (_loc_6 < _loc_7 && _loc_3 == -1)
                if (_loc_3 == -1)
                {
                    break;
                }
                _loc_8.writeByte(_loc_2 << 2 | (_loc_3 & 48) >> 4);
                do
                {
                    
                    _loc_4 = _loc_9[_loc_6++];
                    if (_loc_4 == 61)
                    {
                        return _loc_8;
                    }
                    _loc_4 = _decodeChars[_loc_4];
                }while (_loc_6 < _loc_7 && _loc_4 == -1)
                if (_loc_4 == -1)
                {
                    break;
                }
                _loc_8.writeByte((_loc_3 & 15) << 4 | (_loc_4 & 60) >> 2);
                do
                {
                    
                    _loc_5 = _loc_9[_loc_6++];
                    if (_loc_5 == 61)
                    {
                        return _loc_8;
                    }
                    _loc_5 = _decodeChars[_loc_5];
                }while (_loc_6 < _loc_7 && _loc_5 == -1)
                if (_loc_5 == -1)
                {
                    break;
                }
                _loc_8.writeByte((_loc_4 & 3) << 6 | _loc_5);
            }
            _loc_8.position = 0;
            return _loc_8;
        }// end function

        public static function encode(param1:String) : String
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeUTFBytes(param1);
            return encodeByteArray(_loc_2);
        }// end function

        public static function decode(param1:String) : String
        {
            var _loc_2:* = decodeToByteArray(param1);
            return _loc_2.readUTFBytes(_loc_2.length);
        }// end function

        public static function InitEncoreChar() : Vector.<int>
        {
            var _loc_1:* = new Vector.<int>;
            var _loc_2:* = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
            var _loc_3:* = 0;
            while (_loc_3 < 64)
            {
                
                _loc_1.push(_loc_2.charCodeAt(_loc_3));
                _loc_3++;
            }
            return _loc_1;
        }// end function

        public static function InitDecodeChar() : Vector.<int>
        {
            var _loc_1:* = new Vector.<int>;
            _loc_1.push(-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, (-1 - 1), -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
            return _loc_1;
        }// end function

    }
}
