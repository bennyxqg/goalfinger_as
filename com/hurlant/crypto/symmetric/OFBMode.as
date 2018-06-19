package com.hurlant.crypto.symmetric
{
    import com.hurlant.crypto.symmetric.*;
    import flash.utils.*;

    public class OFBMode extends IVMode implements IMode
    {

        public function OFBMode(param1:ISymmetricKey, param2:IPad = null)
        {
            super(param1, null);
            return;
        }// end function

        public function encrypt(param1:ByteArray) : void
        {
            var _loc_2:* = getIV4e();
            this.core(param1, _loc_2);
            return;
        }// end function

        public function decrypt(param1:ByteArray) : void
        {
            var _loc_2:* = getIV4d();
            this.core(param1, _loc_2);
            return;
        }// end function

        private function core(param1:ByteArray, param2:ByteArray) : void
        {
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_3:* = param1.length;
            var _loc_4:* = new ByteArray();
            var _loc_5:* = 0;
            while (_loc_5 < param1.length)
            {
                
                key.encrypt(param2);
                _loc_4.position = 0;
                _loc_4.writeBytes(param2);
                _loc_6 = _loc_5 + blockSize < _loc_3 ? (blockSize) : (_loc_3 - _loc_5);
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    param1[_loc_5 + _loc_7] = param1[_loc_5 + _loc_7] ^ param2[_loc_7];
                    _loc_7 = _loc_7 + 1;
                }
                param2.position = 0;
                param2.writeBytes(_loc_4);
                _loc_5 = _loc_5 + blockSize;
            }
            return;
        }// end function

        public function toString() : String
        {
            return key.toString() + "-ofb";
        }// end function

    }
}
