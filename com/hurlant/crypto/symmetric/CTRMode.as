package com.hurlant.crypto.symmetric
{
    import com.hurlant.crypto.symmetric.*;
    import flash.utils.*;

    public class CTRMode extends IVMode implements IMode
    {

        public function CTRMode(param1:ISymmetricKey, param2:IPad = null)
        {
            super(param1, param2);
            return;
        }// end function

        public function encrypt(param1:ByteArray) : void
        {
            padding.pad(param1);
            var _loc_2:* = getIV4e();
            this.core(param1, _loc_2);
            return;
        }// end function

        public function decrypt(param1:ByteArray) : void
        {
            var _loc_2:* = getIV4d();
            this.core(param1, _loc_2);
            padding.unpad(param1);
            return;
        }// end function

        private function core(param1:ByteArray, param2:ByteArray) : void
        {
            var _loc_6:* = 0;
            var _loc_3:* = new ByteArray();
            var _loc_4:* = new ByteArray();
            _loc_3.writeBytes(param2);
            var _loc_5:* = 0;
            while (_loc_5 < param1.length)
            {
                
                _loc_4.position = 0;
                _loc_4.writeBytes(_loc_3);
                key.encrypt(_loc_4);
                _loc_6 = 0;
                while (_loc_6 < blockSize)
                {
                    
                    param1[_loc_5 + _loc_6] = param1[_loc_5 + _loc_6] ^ _loc_4[_loc_6];
                    _loc_6 = _loc_6 + 1;
                }
                _loc_6 = blockSize - 1;
                while (_loc_6 >= 0)
                {
                    
                    var _loc_7:* = _loc_3;
                    var _loc_8:* = _loc_6;
                    var _loc_9:* = _loc_3[_loc_6] + 1;
                    _loc_7[_loc_8] = _loc_9;
                    if (_loc_3[_loc_6] != 0)
                    {
                        break;
                    }
                    _loc_6 = _loc_6 - 1;
                }
                _loc_5 = _loc_5 + blockSize;
            }
            return;
        }// end function

        public function toString() : String
        {
            return key.toString() + "-ctr";
        }// end function

    }
}
