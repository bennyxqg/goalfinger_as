package com.hurlant.crypto.hash
{
    import com.hurlant.crypto.hash.*;
    import flash.utils.*;

    public class HMAC extends Object implements IHMAC
    {
        private var hash:IHash;
        private var bits:uint;

        public function HMAC(param1:IHash, param2:uint = 0)
        {
            this.hash = param1;
            this.bits = param2;
            return;
        }// end function

        public function getHashSize() : uint
        {
            if (this.bits != 0)
            {
                return this.bits / 8;
            }
            return this.hash.getHashSize();
        }// end function

        public function compute(param1:ByteArray, param2:ByteArray) : ByteArray
        {
            var _loc_3:* = null;
            if (param1.length > this.hash.getInputSize())
            {
                _loc_3 = this.hash.hash(param1);
            }
            else
            {
                _loc_3 = new ByteArray();
                _loc_3.writeBytes(param1);
            }
            while (_loc_3.length < this.hash.getInputSize())
            {
                
                _loc_3[_loc_3.length] = 0;
            }
            var _loc_4:* = new ByteArray();
            var _loc_5:* = new ByteArray();
            var _loc_6:* = 0;
            while (_loc_6 < _loc_3.length)
            {
                
                _loc_4[_loc_6] = _loc_3[_loc_6] ^ 54;
                _loc_5[_loc_6] = _loc_3[_loc_6] ^ 92;
                _loc_6 = _loc_6 + 1;
            }
            _loc_4.position = _loc_3.length;
            _loc_4.writeBytes(param2);
            var _loc_7:* = this.hash.hash(_loc_4);
            _loc_5.position = _loc_3.length;
            _loc_5.writeBytes(_loc_7);
            var _loc_8:* = this.hash.hash(_loc_5);
            if (this.bits > 0 && this.bits < 8 * _loc_8.length)
            {
                _loc_8.length = this.bits / 8;
            }
            return _loc_8;
        }// end function

        public function dispose() : void
        {
            this.hash = null;
            this.bits = 0;
            return;
        }// end function

        public function toString() : String
        {
            return "hmac-" + (this.bits > 0 ? (this.bits + "-") : ("")) + this.hash.toString();
        }// end function

    }
}
