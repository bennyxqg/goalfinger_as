package com.hurlant.crypto.symmetric
{
    import com.hurlant.crypto.prng.*;
    import com.hurlant.crypto.symmetric.*;
    import com.hurlant.util.*;
    import flash.utils.*;

    public class XTeaKey extends Object implements ISymmetricKey
    {
        public const NUM_ROUNDS:uint = 64;
        private var k:Array;

        public function XTeaKey(param1:ByteArray)
        {
            param1.position = 0;
            this.k = [param1.readUnsignedInt(), param1.readUnsignedInt(), param1.readUnsignedInt(), param1.readUnsignedInt()];
            return;
        }// end function

        public function getBlockSize() : uint
        {
            return 8;
        }// end function

        public function encrypt(param1:ByteArray, param2:uint = 0) : void
        {
            var _loc_5:* = 0;
            param1.position = param2;
            var _loc_3:* = param1.readUnsignedInt();
            var _loc_4:* = param1.readUnsignedInt();
            var _loc_6:* = 0;
            var _loc_7:* = 2654435769;
            _loc_5 = 0;
            while (_loc_5 < this.NUM_ROUNDS)
            {
                
                _loc_3 = _loc_3 + ((_loc_4 << 4 ^ _loc_4 >> 5) + _loc_4 ^ _loc_6 + this.k[_loc_6 & 3]);
                _loc_6 = _loc_6 + _loc_7;
                _loc_4 = _loc_4 + ((_loc_3 << 4 ^ _loc_3 >> 5) + _loc_3 ^ _loc_6 + this.k[_loc_6 >> 11 & 3]);
                _loc_5 = _loc_5 + 1;
            }
            param1.position = param1.position - 8;
            param1.writeUnsignedInt(_loc_3);
            param1.writeUnsignedInt(_loc_4);
            return;
        }// end function

        public function decrypt(param1:ByteArray, param2:uint = 0) : void
        {
            var _loc_5:* = 0;
            param1.position = param2;
            var _loc_3:* = param1.readUnsignedInt();
            var _loc_4:* = param1.readUnsignedInt();
            var _loc_6:* = 2654435769;
            var _loc_7:* = 2654435769 * this.NUM_ROUNDS;
            _loc_5 = 0;
            while (_loc_5 < this.NUM_ROUNDS)
            {
                
                _loc_4 = _loc_4 - ((_loc_3 << 4 ^ _loc_3 >> 5) + _loc_3 ^ _loc_7 + this.k[_loc_7 >> 11 & 3]);
                _loc_7 = _loc_7 - _loc_6;
                _loc_3 = _loc_3 - ((_loc_4 << 4 ^ _loc_4 >> 5) + _loc_4 ^ _loc_7 + this.k[_loc_7 & 3]);
                _loc_5 = _loc_5 + 1;
            }
            param1.position = param1.position - 8;
            param1.writeUnsignedInt(_loc_3);
            param1.writeUnsignedInt(_loc_4);
            return;
        }// end function

        public function dispose() : void
        {
            var _loc_1:* = new Random();
            var _loc_2:* = 0;
            while (_loc_2 < this.k.length)
            {
                
                this.k[_loc_2] = _loc_1.nextByte();
                delete this.k[_loc_2];
                _loc_2 = _loc_2 + 1;
            }
            this.k = null;
            Memory.gc();
            return;
        }// end function

        public function toString() : String
        {
            return "xtea";
        }// end function

        public static function parseKey(param1:String) : XTeaKey
        {
            var _loc_2:* = new ByteArray();
            _loc_2.writeUnsignedInt(parseInt(param1.substr(0, 8), 16));
            _loc_2.writeUnsignedInt(parseInt(param1.substr(8, 8), 16));
            _loc_2.writeUnsignedInt(parseInt(param1.substr(16, 8), 16));
            _loc_2.writeUnsignedInt(parseInt(param1.substr(24, 8), 16));
            _loc_2.position = 0;
            return new XTeaKey(_loc_2);
        }// end function

    }
}
