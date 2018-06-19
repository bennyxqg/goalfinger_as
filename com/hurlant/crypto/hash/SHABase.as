package com.hurlant.crypto.hash
{
    import com.hurlant.crypto.hash.*;
    import flash.utils.*;

    public class SHABase extends Object implements IHash
    {
        public var pad_size:int = 40;

        public function SHABase()
        {
            return;
        }// end function

        public function getInputSize() : uint
        {
            return 64;
        }// end function

        public function getHashSize() : uint
        {
            return 0;
        }// end function

        public function getPadSize() : int
        {
            return this.pad_size;
        }// end function

        public function hash(param1:ByteArray) : ByteArray
        {
            var _loc_2:* = param1.length;
            var _loc_3:* = param1.endian;
            param1.endian = Endian.BIG_ENDIAN;
            var _loc_4:* = _loc_2 * 8;
            while (param1.length % 4 != 0)
            {
                
                param1[param1.length] = 0;
            }
            param1.position = 0;
            var _loc_5:* = [];
            var _loc_6:* = 0;
            while (_loc_6 < param1.length)
            {
                
                _loc_5.push(param1.readUnsignedInt());
                _loc_6 = _loc_6 + 4;
            }
            var _loc_7:* = this.core(_loc_5, _loc_4);
            var _loc_8:* = new ByteArray();
            var _loc_9:* = this.getHashSize() / 4;
            _loc_6 = 0;
            while (_loc_6 < _loc_9)
            {
                
                _loc_8.writeUnsignedInt(_loc_7[_loc_6]);
                _loc_6 = _loc_6 + 1;
            }
            param1.length = _loc_2;
            param1.endian = _loc_3;
            return _loc_8;
        }// end function

        protected function core(param1:Array, param2:uint) : Array
        {
            return null;
        }// end function

        public function toString() : String
        {
            return "sha";
        }// end function

    }
}
