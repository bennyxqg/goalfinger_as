package com.hurlant.crypto.symmetric
{
    import com.hurlant.crypto.symmetric.*;
    import flash.utils.*;

    public class CFBMode extends IVMode implements IMode
    {

        public function CFBMode(param1:ISymmetricKey, param2:IPad = null)
        {
            super(param1, null);
            return;
        }// end function

        public function encrypt(param1:ByteArray) : void
        {
            var _loc_5:* = 0;
            var _loc_6:* = 0;
            var _loc_2:* = param1.length;
            var _loc_3:* = getIV4e();
            var _loc_4:* = 0;
            while (_loc_4 < param1.length)
            {
                
                key.encrypt(_loc_3);
                _loc_5 = _loc_4 + blockSize < _loc_2 ? (blockSize) : (_loc_2 - _loc_4);
                _loc_6 = 0;
                while (_loc_6 < _loc_5)
                {
                    
                    param1[_loc_4 + _loc_6] = param1[_loc_4 + _loc_6] ^ _loc_3[_loc_6];
                    _loc_6 = _loc_6 + 1;
                }
                _loc_3.position = 0;
                _loc_3.writeBytes(param1, _loc_4, _loc_5);
                _loc_4 = _loc_4 + blockSize;
            }
            return;
        }// end function

        public function decrypt(param1:ByteArray) : void
        {
            var _loc_6:* = 0;
            var _loc_7:* = 0;
            var _loc_2:* = param1.length;
            var _loc_3:* = getIV4d();
            var _loc_4:* = new ByteArray();
            var _loc_5:* = 0;
            while (_loc_5 < param1.length)
            {
                
                key.encrypt(_loc_3);
                _loc_6 = _loc_5 + blockSize < _loc_2 ? (blockSize) : (_loc_2 - _loc_5);
                _loc_4.position = 0;
                _loc_4.writeBytes(param1, _loc_5, _loc_6);
                _loc_7 = 0;
                while (_loc_7 < _loc_6)
                {
                    
                    param1[_loc_5 + _loc_7] = param1[_loc_5 + _loc_7] ^ _loc_3[_loc_7];
                    _loc_7 = _loc_7 + 1;
                }
                _loc_3.position = 0;
                _loc_3.writeBytes(_loc_4);
                _loc_5 = _loc_5 + blockSize;
            }
            return;
        }// end function

        public function toString() : String
        {
            return key.toString() + "-cfb";
        }// end function

    }
}
